local FFlagLuaAppSduiGameTileFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppSduiGameTileFeedback")
local FFlagMigrateGameInfoToStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagMigrateGameInfoToStore")

return game:DefineFastFlag("LuaAppSduiSponsoredTwoByOneTile2", false) and FFlagLuaAppSduiGameTileFeedback and FFlagMigrateGameInfoToStore
