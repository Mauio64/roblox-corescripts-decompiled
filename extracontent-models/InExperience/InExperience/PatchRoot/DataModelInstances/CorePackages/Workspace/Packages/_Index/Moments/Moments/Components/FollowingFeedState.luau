local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local FoundationCloudAssets = require(parent.FoundationCloudAssets)
local Localization = require(parent.Localization)
local React = require(parent.React)

local FeedMessageView = require(Moments.Components.Feed.FeedMessageView)
local useIsPersonalizedFeed = require(Moments.Hooks.useIsPersonalizedFeed)

local useLocalization = Localization.Hooks.useLocalization

local v = {
	emptyTitle = "Feature.Moments.Label.FollowingEmptyTitle",
	emptyBodyRecommended = "Feature.Moments.Description.FollowingEmptyBodyRecommended",
	emptyBodyTrending = "Feature.Moments.Description.FollowingEmptyBodyTrending",
	emptyActionRecommended = "Feature.Moments.Action.ViewRecommended",
	emptyActionTrending = "Feature.Moments.Action.ViewTrending",
	caughtUpTitle = "Feature.Moments.Label.FollowingCaughtUpTitle",
	caughtUpBody = "Feature.Moments.Description.FollowingCaughtUpBody",
	caughtUpAction = "Feature.Moments.Action.ViewOtherFeed"
}

local v2 = {
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
	local v3 = useLocalization(v)
	local v4 = useIsPersonalizedFeed()

	local function text(p: string) -- 3 equivalent calls inferred from this helper
		local v5 = v3[p]

		if v5 == nil or v5 == "" then
			return v2[p]
		end

		return v5
	end

	local v5 = props.variant == "empty"

	return React.createElement(FeedMessageView, {
		LayoutOrder = props.LayoutOrder,
		iconName = not v5 and "icons/brands/moments_large" or nil,
		tilted = true,
		pictogram = v5 and "pictograms/magnifyglassperson" or nil,
		title = text(v5 and "emptyTitle" or "caughtUpTitle"), -- inferred equivalent call
		description = text(not v5 and "caughtUpBody" or v4 and "emptyBodyRecommended" or "emptyBodyTrending"), -- inferred equivalent call
		primaryAction = {
			text = text(not v5 and "caughtUpAction" or v4 and "emptyActionRecommended" or "emptyActionTrending"), -- inferred equivalent call
			onActivated = props.onViewRecommended,
			testId = "--moments-following-view-recommended"
		},
		testId = v5 and "--moments-following-empty" or "--moments-following-caught-up"
	})
end

return FollowingFeedState
