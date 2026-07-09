local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local RecommendationSourceEnum = dependencies.SocialCommon.Enums.RecommendationSourceEnum
local RODUX_KEY = require(ParentParent.Common.Constants).RODUX_KEY
local HomepageFriendsCarousel = RecommendationSourceEnum.HomepageFriendsCarousel

return function(p1) -- line: 11
	-- upvalues: getDeepValue (copy), RODUX_KEY (copy), HomepageFriendsCarousel (copy)
	local v8 = getDeepValue(p1, string.format("%s.Friends.recommendations.byUserId.%s", RODUX_KEY, "test")) or {}
	local t1 = {}

	for k, _ in pairs(v8) do
		t1[k] = true
	end

	p1[RODUX_KEY].Friends.recommendations.bySource = {
		[HomepageFriendsCarousel] = t1
	}
end
