local FoundationCloudAssets = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/FoundationCloudAssets")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local FeedMessageView = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedMessageView")
local useIsPersonalizedFeed = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useIsPersonalizedFeed")

local useLocalization = Localization.Hooks.useLocalization

local v5 = {
	emptyTitle = "Feature.Moments.Label.FollowingEmptyTitle",
	emptyBodyRecommended = "Feature.Moments.Description.FollowingEmptyBodyRecommended",
	emptyBodyTrending = "Feature.Moments.Description.FollowingEmptyBodyTrending",
	emptyActionRecommended = "Feature.Moments.Action.ViewRecommended",
	emptyActionTrending = "Feature.Moments.Action.ViewTrending",
	caughtUpTitle = "Feature.Moments.Label.FollowingCaughtUpTitle",
	caughtUpBody = "Feature.Moments.Description.FollowingCaughtUpBody",
	caughtUpAction = "Feature.Moments.Action.ViewOtherFeed"
}

local v6 = {
	emptyTitle = "Follow creators to view their Moments",
	emptyBodyRecommended = "Enjoy Moments from your favorites after you follow a few creators. View recommended to find some.",
	emptyBodyTrending = "Enjoy Moments from your favorites after you follow a few creators. View trending to find some.",
	emptyActionRecommended = "View recommended",
	emptyActionTrending = "View trending",
	caughtUpTitle = "You're caught up for now",
	caughtUpBody = "You've watched all the new Moments in this feed. Switch feeds to view more.",
	caughtUpAction = "View other feed"
}

FoundationCloudAssets.preloadAsset("pictograms/magnifyglassperson")

local function FollowingFeedState(props)
	local v7 = useLocalization(v5)
	local v8 = useIsPersonalizedFeed()

	local function text(p2)
		local v9 = v7[p2]

		if v9 == nil or v9 == "" then
			return v6[p2]
		end

		return v9
	end

	local v9 = props.variant == "empty"

	local createElement = React.createElement
	local v13 = {
		LayoutOrder = props.LayoutOrder,
		iconName = not v9 and "icons/brands/moments_large" or nil,
		tilted = true,
		pictogram = v9 and "pictograms/magnifyglassperson" or nil,
		title = 0,
		description = 0,
		primaryAction = 0,
		testId = 0
	}
	local v14 = v9 and "emptyTitle" or "caughtUpTitle"
	local v15 = v7[v14]

	if v15 == nil or v15 == "" then
		v15 = v6[v14]
	end

	v13.title = v15
	local v16 = not v9 and "caughtUpBody" or v8 and "emptyBodyRecommended" or "emptyBodyTrending"
	local v17 = v7[v16]

	if v17 == nil or v17 == "" then
		v17 = v6[v16]
	end

	v13.description = v17
	local v19 = not v9 and "caughtUpAction" or v8 and "emptyActionRecommended" or "emptyActionTrending"
	local v20 = v7[v19]

	if v20 == nil or v20 == "" then
		v20 = v6[v19]
	end

	v13.primaryAction = {
		text = v20,
		onActivated = props.onViewRecommended,
		testId = "--moments-following-view-recommended"
	}

	v13.testId = v9 and "--moments-following-empty" or "--moments-following-caught-up"
	return createElement(FeedMessageView, v13)
end

return FollowingFeedState
