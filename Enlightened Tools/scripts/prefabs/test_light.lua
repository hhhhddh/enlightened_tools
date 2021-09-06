local assets =
{
    Asset("ANIM", "anim/test_light.zip"),
    Asset("ANIM", "anim/swap_test_light.zip"),
    Asset("ATLAS", "images/test_light.xml"), -- 物品栏图片
}

local prefabs =
{
    "test_lightfire"
}

local function onpocket(inst)
    inst.components.burnable:Extinguish()
end

local function onremovefire(fire)
    fire.nightstick.fire = nil
end

local function onequip(inst, owner)
    inst.components.burnable:Ignite()
    owner.AnimState:OverrideSymbol("swap_object", "swap_test_light", "swap_test_light")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")


    if inst.fire == nil then
        inst.fire = SpawnPrefab("test_lightfire")
        inst.fire.nightstick = inst
        inst:ListenForEvent("onremove", onremovefire, inst.fire)
    end
    inst.fire.entity:SetParent(owner.entity)
end

local function onunequip(inst, owner)
    if inst.fire ~= nil then
        inst.fire:Remove()
    end

    inst.components.burnable:Extinguish()
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("test_light")
    inst.AnimState:SetBuild("test_light")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)

    inst:AddTag("wildfireprotected")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.4, 1.1}, true, -19, {sym_build = "swap_test_light"})

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.NIGHTSTICK_DAMAGE)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "test_light"
    inst.components.inventoryitem.atlasname = "images/test_light.xml" -- 设置物品栏图片文档。官方内置的物体有默认的图片文档，所以不需要设置这一项，但自己额外添加的物体使用自己的图片文档，就应该设置这一项

    -----------------------------------

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnPocket(onpocket)
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    -----------------------------------

    inst:AddComponent("inspectable")

    -----------------------------------

    inst:AddComponent("burnable")
    inst.components.burnable.canlight = false
    inst.components.burnable.fxprefab = nil

    -----------------------------------
    MakeHauntableLaunch(inst)


    return inst
end

return Prefab("test_light", fn, assets, prefabs)
