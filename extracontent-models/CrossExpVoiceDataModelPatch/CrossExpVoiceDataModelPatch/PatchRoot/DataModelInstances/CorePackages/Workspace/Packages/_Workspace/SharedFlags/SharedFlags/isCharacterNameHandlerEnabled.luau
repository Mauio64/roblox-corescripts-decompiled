local parent = script:FindFirstAncestor("SharedFlags").Parent
local AppCommonLib = require(parent.AppCommonLib)
local rolloutByApplicationId = AppCommonLib.rolloutByApplicationId

game:DefineFastInt("CharacterNameHandlerUserProfileApiRollout", 0)
game:DefineFastFlag("CharacterNameHandlerUserProfileApiEnabledForAll", false)

local v = rolloutByApplicationId(function()
	return game:GetFastInt("CharacterNameHandlerUserProfileApiRollout")
end)

local function fn() -- 1 equivalent call inferred from this helper
	return game:GetFastFlag("CharacterNameHandlerUserProfileApiEnabledForAll")
end

return function()
	return fn() or v() -- inferred equivalent call
end
