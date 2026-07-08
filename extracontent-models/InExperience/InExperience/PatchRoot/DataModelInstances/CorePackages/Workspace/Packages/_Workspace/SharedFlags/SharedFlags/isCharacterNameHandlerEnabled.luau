local Parent = script:FindFirstAncestor("SharedFlags").Parent
local rolloutByApplicationId = require(Parent.AppCommonLib).rolloutByApplicationId

game:DefineFastInt("CharacterNameHandlerUserProfileApiRollout", 0)
game:DefineFastFlag("CharacterNameHandlerUserProfileApiEnabledForAll", false)

local v3 = rolloutByApplicationId(function() -- line: 8
	return game:GetFastInt("CharacterNameHandlerUserProfileApiRollout")
end)

return function() -- line: 18
	-- upvalues: v3 (copy)
	return game:GetFastFlag("CharacterNameHandlerUserProfileApiEnabledForAll") or v3()
end
