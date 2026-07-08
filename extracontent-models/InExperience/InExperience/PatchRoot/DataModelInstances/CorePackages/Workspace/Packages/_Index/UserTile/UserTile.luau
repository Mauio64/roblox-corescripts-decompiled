local v1 = game:DefineFastFlag("UserTileAddDataHydrationWrapper", false)

return {
	["jest.config"] = script["jest.config"],
	UserTileEventHandlers = require(script.Components.UserTileEventHandlers),
	UserTile = if not v1 then require(script.Components.UserTile) else require(script.UserTileEntry.UserTileContainer),
	LayoutMode = require(script.Enums.LayoutMode)
}
