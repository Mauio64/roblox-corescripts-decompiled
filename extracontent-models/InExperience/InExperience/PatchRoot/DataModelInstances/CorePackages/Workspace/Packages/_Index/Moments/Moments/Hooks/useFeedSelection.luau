local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)

require(Moments.Components.Feed.FeedTypes)
local createMockFeedSource = require(Moments.Components.Feed.Sources.createMockFeedSource)
local FollowingFeedState = require(Moments.Components.FollowingFeedState)
local MomentsFeedType = require(Moments.Enums.MomentsFeedType)
local NavigationDestinationType = require(Moments.Enums.NavigationDestinationType)
local createFollowingFeedSource = require(Moments.Stores.GetMomentsStore.createFollowingFeedSource)
local isStudio = require(parent.MomentsCommon.isStudio)
local GetFFlagArgusStudioMockFeed = require(Moments.Flags.GetFFlagArgusStudioMockFeed)
local FFlagMomentsNavigationEvent = require(Moments.Flags.FFlagMomentsNavigationEvent)
local FFlagMomentsRecommendationFeedType = require(Moments.Flags.FFlagMomentsRecommendationFeedType)

local function getFeedTypeDestination(current) -- 2 equivalent calls inferred from this helper
	if FFlagMomentsNavigationEvent and current == MomentsFeedType.Trending then
		return NavigationDestinationType.Trending
	end

	return nil
end

local function createFollowingSource() -- 1 equivalent call inferred from this helper
	if isStudio() and GetFFlagArgusStudioMockFeed() then
		return createMockFeedSource()
	end

	return createFollowingFeedSource()
end

local function useFeedSelection(data)
	local refreshFeed = data.refreshFeed
	local flushView = data.flushView
	local state, setState = React.useState(MomentsFeedType.Trending)
	local ref = React.useRef(state)
	local ref2 = React.useRef(nil)

	local getSelected = React.useCallback(function()
		return ref.current
	end, {})

	local selection = React.useCallback(function(current)
		if ref.current == current then
			refreshFeed(getFeedTypeDestination(current)) -- inferred equivalent call
		else
			flushView(getFeedTypeDestination(current)) -- inferred equivalent call
			ref.current = current
			setState(current)
		end
	end, { refreshFeed, flushView })

	local v = state == MomentsFeedType.Following

	if v and ref2.current == nil then
		ref2.current = createFollowingSource() -- inferred equivalent call
	end

	local source = ref2.current

	if not v or source == nil then
		source = data.trendingSource
	end

	local telemetry

	if v then
		telemetry = nil
	else
		telemetry = data.trendingTelemetry
	end

	if FFlagMomentsRecommendationFeedType and v then
		telemetry = data.followingTelemetry
	end

	local v2 = React.useMemo(function()
		if not v then
			return {}
		end

		local function onViewRecommended()
			selection(MomentsFeedType.Trending)
		end
		return {
			emptyState = React.createElement(FollowingFeedState, {
				variant = "empty",
				onViewRecommended = onViewRecommended
			}),
			caughtUpState = React.createElement(FollowingFeedState, {
				variant = "caughtUp",
				onViewRecommended = onViewRecommended
			})
		}
	end, { v, selection })

	return React.useMemo(function()
		return {
			selected = state,
			getSelected = getSelected,
			select = selection,
			source = source,
			telemetry = telemetry,
			emptyState = v2.emptyState,
			caughtUpState = v2.caughtUpState
		}
	end, { state, getSelected, selection, source, telemetry, v2 })
end

return useFeedSelection
