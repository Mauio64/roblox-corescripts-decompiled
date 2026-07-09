local Parent = script:FindFirstAncestor("SocialTab").Parent
local rolloutByApplicationId = require(Parent.AppCommonLib).rolloutByApplicationId

game:DefineFastInt("SocialTabUserProfileApiRollout", 0)
game:DefineFastFlag("SocialTabUserProfileApiEnabledForAll", false)

local v3 = rolloutByApplicationId(function() -- line: 8
	return game:GetFastInt("SocialTabUserProfileApiRollout")
end)

return function() -- line: 18
	-- upvalues: v3 (copy)
	return game:GetFastFlag("SocialTabUserProfileApiEnabledForAll") or v3()
end
