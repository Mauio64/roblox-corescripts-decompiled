local Parent = script:FindFirstAncestor("AddFriends").Parent
local getDeepValue = require(Parent.LuaSocialLibrariesDeps).SocialLibraries.config({}).Dictionary.getDeepValue
local RecommendationSourceEnum = require(Parent.SocialCommon).Enums.RecommendationSourceEnum
local RODUX_KEY = require(Parent.AddFriendsState).RODUX_KEY

return function(p1) -- line: 13
	-- upvalues: getDeepValue (copy), RODUX_KEY (copy), RecommendationSourceEnum (copy)
	local v6 = getDeepValue(p1, string.format("%s.Friends.recommendations.byUserId.%s", RODUX_KEY, "test")) or {}
	local t1 = {}

	for k, _ in pairs(v6) do
		t1[k] = true
	end

	p1[RODUX_KEY].Friends.recommendations.bySource = {
		[RecommendationSourceEnum.AddFriendsPage] = t1
	}
end
