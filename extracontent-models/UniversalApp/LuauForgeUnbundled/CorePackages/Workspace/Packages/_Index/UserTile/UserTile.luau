local defineFastFlag = game:DefineFastFlag("UserTileAddDataHydrationWrapper", false)

local v5 = {
	UserTileEventHandlers = require("@game/CorePackages/Workspace/Packages/_Index/UserTile/UserTile/Components/UserTileEventHandlers"),
	UserTile = 0,
	LayoutMode = 0
}

local v6 = if defineFastFlag then require("@game/CorePackages/Workspace/Packages/_Index/UserTile/UserTile/UserTileEntry/UserTileContainer") else require("@game/CorePackages/Workspace/Packages/_Index/UserTile/UserTile/Components/UserTile")
v5.UserTile = v6

v5.LayoutMode = require("@game/CorePackages/Workspace/Packages/_Index/UserTile/UserTile/Enums/LayoutMode")
return v5
