local defineFastFlag = game:DefineFastFlag("UserTileAddDataHydrationWrapper", false)

local UserTile = {
	["jest.config"] = nil,
	["jest.config"] = script["jest.config"],
	UserTileEventHandlers = require(script.Components.UserTileEventHandlers)
}
local userTile

if defineFastFlag then
	userTile = require(script.UserTileEntry.UserTileContainer)
else
	userTile = require(script.Components.UserTile)
end

UserTile.UserTile = userTile

UserTile.LayoutMode = require(script.Enums.LayoutMode)
return UserTile
