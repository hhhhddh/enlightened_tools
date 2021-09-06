local assets =
{
    Asset("ANIM", "anim/enlightened_axe.zip"), -- 放在地上的动画
    Asset("ANIM", "anim/swap_enlightened_axe.zip"), -- 手持动画
    -- Asset("ANIM", "anim/floating_items.zip"), -- 浮在水面上的动画
    Asset("ATLAS", "images/enlightened_axe.xml"), -- 物品栏图片
}

local prefabs =
{
    "enlightened_light"
}

local function onpocket(inst)
    inst.components.burnable:Extinguish()
end

local function onactive(inst, owner)
    if inst._is_active then
        return
    end
    inst._is_active = true

    if owner.components.workmultiplier then
        owner.components.workmultiplier:AddMultiplier(ACTIONS.CHOP, 5, inst) -- san值高时人物砍树效率为5倍
    end

    if inst._light == nil then
        inst._light = SpawnPrefab("enlightened_light")
        inst._light.entity:SetParent(owner.entity)
    end
end

local function ondeactive(inst, owner)
    if not inst._is_active then
        return
    end
    inst._is_active = false

    if owner.components.workmultiplier then
        owner.components.workmultiplier:RemoveMultiplier(ACTIONS.CHOP, inst) -- san值低时人物砍树效率恢复
    end

    if inst._light ~= nil then
        inst._light:Remove()
        inst._light = nil
    end
end

local function lightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.Light:SetFalloff(0.5)
    inst.Light:SetColour(180 / 255, 195 / 255, 150 / 255)
    inst.Light:SetIntensity(.8)
    inst.Light:SetRadius(4)
    inst.Light:Enable(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

local function onsanitydelta(inst, owner)
    local sanity = owner.components.sanity ~= nil and owner.components.sanity:GetPercent() or 0
    if sanity > TUNING.SANITY_BECOME_ENLIGHTENED_THRESH then
        onactive(inst, owner)
    else
        ondeactive(inst, owner)
    end
end

local function finishedChop(inst, owner, data)
    if not inst._is_active then
        return
    end
    if data ~= nil and data.action ~= nil then
        if data.action.id and data.action.id=="CHOP" then
            -- 砍倒烧焦的树不消耗san值
            if data.target:HasTag("burnt") then
                return
            end
            -- 每次砍倒树消耗san值
            if owner.components.sanity ~= nil then
                owner.components.sanity:DoDelta(-1, true)
            end
        end
    end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_enlightened_axe", "swap_enlightened_axe")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if inst._light == nil then
        inst._light = SpawnPrefab("enlightened_light")
        inst._light.entity:SetParent(owner.entity)
    end

    inst._onsanitydelta = function() onsanitydelta(inst, owner) end
    inst:ListenForEvent("sanitydelta", inst._onsanitydelta, owner)

    inst.finishedwork = function(owner, data)
        finishedChop(inst, owner, data)
    end
    owner:ListenForEvent("finishedwork", inst.finishedwork)

    local sanity = owner.components.sanity ~= nil and owner.components.sanity:GetPercent() or 0
    if sanity > TUNING.SANITY_BECOME_ENLIGHTENED_THRESH then
        onactive(inst, owner)
    end
end

local function onunequip(inst, owner)
    if inst._light ~= nil then
        inst._light:Remove()
        inst._light = nil
    end

    inst.components.burnable:Extinguish()
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    owner:RemoveEventCallback("finishedwork", inst.finishedwork)
end

-- 对树人伤害翻倍
local function attack_calculation(inst, attacker, target)
    return target ~= nil and target:IsValid() and (target:HasTag("leif")) and 2*TUNING.AXE_DAMAGE or TUNING.AXE_DAMAGE
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform() -- 添加变换组件，一般只需要添加组件就行了
    inst.entity:AddAnimState() -- 添加动画组件
    inst.entity:AddNetwork() -- 添加网络组件

    MakeInventoryPhysics(inst) -- 设置物品拥有一般物品栏物体的物理特性，这是一个系统封装好的函数，内部已经含有对物理引擎的设置

    inst.AnimState:SetBank("enlightened_axe") -- 设置动画属性Bank
    inst.AnimState:SetBuild("enlightened_axe") -- 设置动画属性Build
    inst.AnimState:PlayAnimation("idle") -- 设置默认播放动感为idle

    inst:AddTag("sharp")
    inst:AddTag("pointy")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("tool")

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst.entity:SetPristine() -- 以下这几句是设置网络状态的，并且作为一个分界线，从这个if then 块往上是主客机通用代码，往下则是只限于主机使用的代码。

    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("weapon") -- 添加武器组件
    inst.components.weapon:SetDamage(attack_calculation) -- 设置武器伤害

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, 1) -- 效率待实现

    inst:AddComponent("inspectable") -- 设置可以检查

    inst:AddComponent("inventoryitem") -- 设置可放入物品栏
    inst.components.inventoryitem.imagename = "enlightened_axe"
    inst.components.inventoryitem.atlasname = "images/enlightened_axe.xml" -- 设置物品栏图片文档。官方内置的物体有默认的图片文档，所以不需要设置这一项，但自己额外添加的物体使用自己的图片文档，就应该设置这一项

    inst:AddComponent("equippable") -- 设置可装备
    inst.components.equippable:SetOnPocket(onpocket)
    inst.components.equippable:SetOnEquip(onequip) -- 添加装备函数
    inst.components.equippable:SetOnUnequip(onunequip) -- 添加卸装函数

    inst:AddComponent("burnable") -- 设置光源
    inst.components.burnable.canlight = false -- 攻击时不可点燃敌人
    inst.components.burnable.fxprefab = nil

    MakeHauntableLaunch(inst) -- 设置可作祟

    return inst
end

return Prefab("enlightened_axe", fn, assets,prefabs),
       Prefab("enlightened_light", lightfn)