--local isCh = locale == "Ch" or locale == "En"
--name = isCh and "启迪工具" or "Enlightened Tools"
name = "启迪工具"
--description =  isCh and "可制作的启迪系列工具！酷！" or "Craftable enlightened tools!COOL!"
description = "可制作的启迪系列工具！酷！"
author = "好黑好黑的大黑"
version = "1.0.0" -- 整体.内容更新.修bug

forumthread = ""

-- This lets other players know if your mod is out of date, update it to match the current version in the game
api_version = 10


-- Specify compatibility with the game!
dst_compatible = true
restart_required = false
all_clients_require_mod = true
 icon = "modicon.tex"
 icon_atlas = "modicon.xml"

--configuration_options = isCh and
--{
--    {
--        name = "language_switch",
--        label = "选择语言",
--        hover = "选择你的常用语言",
--        options =
--        {
--            {description = "中文", data = "ch", hover = "中文"},
--            {description = "English", data = "eng", hover = "English"},
--        },
--        default = "ch",
--    }
--} or
--{
--    {
--        name = "language_switch",
--        label = "Language",
--        hover = "Choose your common language",
--        options =
--        {
--            {description = "中文", data = "ch", hover = "中文"},
--            {description = "English", data = "eng", hover = "English"},
--        },
--        default = "eng",
--    }
--}