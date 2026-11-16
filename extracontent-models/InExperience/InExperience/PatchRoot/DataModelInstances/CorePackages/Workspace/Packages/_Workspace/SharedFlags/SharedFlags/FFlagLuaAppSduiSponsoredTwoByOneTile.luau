local FFlagLuaAppSduiGameTileFeedback = require(script.Parent.FFlagLuaAppSduiGameTileFeedback)
local FFlagMigrateGameInfoToStore = require(script.Parent.FFlagMigrateGameInfoToStore)

return game:DefineFastFlag("LuaAppSduiSponsoredTwoByOneTile2", false)
	and FFlagLuaAppSduiGameTileFeedback
	and FFlagMigrateGameInfoToStore
