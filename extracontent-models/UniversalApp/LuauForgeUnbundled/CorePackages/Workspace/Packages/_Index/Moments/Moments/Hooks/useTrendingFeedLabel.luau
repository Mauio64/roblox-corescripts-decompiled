local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")

local useIsPersonalizedFeed = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useIsPersonalizedFeed")

local useLocalization = Localization.Hooks.useLocalization

local v5 = {
	recommended = "Feature.Moments.Label.FeedRecommended",
	trending = "Feature.Moments.Label.FeedTrending"
}

local v6 = { recommended = "Recommended", trending = "Trending" }

local function useTrendingFeedLabel()
	local v7 = useLocalization(v5)
	local v8 = useIsPersonalizedFeed() and "recommended" or "trending"
	local v9 = v7[v8]

	if v9 == nil or v9 == "" then
		return v6[v8]
	end

	return v9
end

return useTrendingFeedLabel
