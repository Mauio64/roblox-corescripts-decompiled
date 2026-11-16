local rolloutByApplicationId = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/AppCommonLib").rolloutByApplicationId

game:DefineFastInt("CharacterNameHandlerUserProfileApiRollout", 0)
game:DefineFastFlag("CharacterNameHandlerUserProfileApiEnabledForAll", false)

local v5 = rolloutByApplicationId(function()
	return game:GetFastInt("CharacterNameHandlerUserProfileApiRollout")
end)

return function()
	return game:GetFastFlag("CharacterNameHandlerUserProfileApiEnabledForAll") or v5()
end
