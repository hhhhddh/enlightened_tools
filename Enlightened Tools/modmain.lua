PrefabFiles = {
    "enlightened_light",
    "enlightened_axe",
    "enlightened_pickaxe",
    "test_light",
    "test_lightfire"
}

-- 一些预设置，防止系统报错
env.RECIPETABS = GLOBAL.RECIPETABS
env.TECH = GLOBAL.TECH


--[[
{
	name,--配方名，一般情况下和需要合成的道具同名
	ingredients,--配方，这边为了区分不同难度的配方，做了嵌套{{正常难度},{简易难度}}，只填一个视为不做难度区分
	tab,--合成栏
	level,--解锁科技
	placer,--建筑类科技放置时显示的贴图、占位等/也可以配List用于添加更多额外参数，比如不可分解{no_deconstruction = true}
	min_spacing,--最小间距，不填默认为3.2
	nounlock,--不解锁配方，只能在满足科技条件的情况下制作
	numtogive,--一次性制作的数量，不填默认为1
	builder_tag,--制作者需要拥有的标签
	atlas,--需要用到的图集文件(.xml)，不填默认用images/name.xml
	image,--物品贴图(.tex)，不填默认用name.tex
	testfn,--尝试放下物品时的函数，可用于判断坐标点是否符合预期
	product,--实际合成道具，不填默认取name
	needHidden,--简易模式隐藏
	noatlas,--不需要图集文件
	noimage,--不需要贴图
}
--]]
AddRecipe("enlightened_axe", {Ingredient("alterguardianhatshard", 2),Ingredient("livinglog", 1)}, RECIPETABS.MOON_ALTAR, TECH.CELESTIAL_THREE, {no_deconstruction = true}, nil, {nounlock = true}, nil, nil,"images/enlightened_axe.xml")
AddRecipe("enlightened_pickaxe", {Ingredient("alterguardianhatshard", 3),Ingredient("livinglog", 2)}, RECIPETABS.MOON_ALTAR, TECH.CELESTIAL_THREE, {no_deconstruction = true}, nil, {nounlock = true}, nil, nil,"images/enlightened_pickaxe.xml")
AddRecipe("test_light", {Ingredient("twigs", 1)}, RECIPETABS.LIGHT, TECH.NONE, nil, nil, nil, nil, nil,"images/test_light.xml")
env.STRINGS = GLOBAL.STRINGS -- 预设置

STRINGS.NAMES.ENLIGHTENED_AXE = "启迪之斧" -- 物体在游戏中显示的名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ENLIGHTENED_AXE = "究竟是谁在砍树，是我还是它？" -- 物体的通用检查描述
STRINGS.CHARACTERS.WOODIE.DESCRIBE.ENLIGHTENED_AXE = "对不起，露西……我无法抗拒……" -- 物体的伍迪特殊检查描述
STRINGS.RECIPE_DESC.ENLIGHTENED_AXE = "它注视着树林，就像祂们注视着你" -- 物体的制作栏描述

STRINGS.NAMES.ENLIGHTENED_PICKAXE = "启迪鹤嘴锄" -- 物体在游戏中显示的名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ENLIGHTENED_PICKAXE = "有种要天降横祸的预感……" -- 物体的通用检查描述
STRINGS.RECIPE_DESC.ENLIGHTENED_PICKAXE = "它注视着故乡，等待着祂们的回应" -- 物体的制作栏描述

STRINGS.NAMES.TEST_LIGHT = "装备光源测试" -- 物体在游戏中显示的名字
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TEST_LIGHT = "装备光源测试" -- 物体的通用检查描述
STRINGS.RECIPE_DESC.TEST_LIGHT = "装备光源测试" -- 物体的制作栏描述