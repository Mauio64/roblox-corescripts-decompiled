local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Localization = require(parent.Localization)

local useIsPersonalizedFeed = require(Moments.Hooks.useIsPersonalizedFeed)

local useLocalization = Localization.Hooks.useLocalization

local v = {
	recommended = "Feature.Moments.Label.FeedRecommended",
	trending = "Feature.Moments.Label.FeedTrending"
}

local v2 = { recommended = "Recommended", trending = "Trending" }

local function useTrendingFeedLabel()
	local v3 = useLocalization(v)
	local v4 = useIsPersonalizedFeed() and "recommended" or "trending"
	local v5 = v3[v4]

	if v5 == nil or v5 == "" then
		return v2[v4]
	end

	return v5
end

return useTrendingFeedLabel
