local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")
local createMockFeedSource = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Sources/createMockFeedSource")
local FollowingFeedState = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/FollowingFeedState")
local MomentsFeedType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Enums/MomentsFeedType")
local NavigationDestinationType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Enums/NavigationDestinationType")
local createFollowingFeedSource = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/createFollowingFeedSource")
local isStudio = require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsCommon/isStudio")
local GetFFlagArgusStudioMockFeed = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/GetFFlagArgusStudioMockFeed")
local FFlagMomentsNavigationEvent = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsNavigationEvent")

local function getFeedTypeDestination(p2)
	if FFlagMomentsNavigationEvent and p2 == MomentsFeedType.Trending then
		return NavigationDestinationType.Trending
	end

	return nil
end

local function createFollowingSource()
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

	local v5 = React.useCallback(function()
		return ref.current
	end, {})

	local v6 = React.useCallback(function(current)
		if ref.current == current then
			local v8 = if FFlagMomentsNavigationEvent and current == MomentsFeedType.Trending then NavigationDestinationType.Trending else nil

			refreshFeed(v8)
		else
			local v8 = if FFlagMomentsNavigationEvent and current == MomentsFeedType.Trending then NavigationDestinationType.Trending else nil

			flushView(v8)
			ref.current = current
			setState(current)
		end
	end, { refreshFeed, flushView })

	local v7 = state == MomentsFeedType.Following

	if v7 and ref2.current == nil then
		local v8 = if isStudio() and GetFFlagArgusStudioMockFeed() then createMockFeedSource() else createFollowingFeedSource()

		ref2.current = v8
	end

	local v8 = ref2.current

	if not v7 or v8 == nil then
		v8 = data.trendingSource
	end

	local trendingTelemetry = if not v7 then data.trendingTelemetry else nil

	local v9 = React.useMemo(function()
		if not v7 then
			return {}
		end

		local function onViewRecommended()
			v6(MomentsFeedType.Trending)
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
	end, { v7, v6 })

	return React.useMemo(function()
		return {
			selected = state,
			getSelected = v5,
			select = v6,
			source = v8,
			telemetry = trendingTelemetry,
			emptyState = v9.emptyState,
			caughtUpState = v9.caughtUpState
		}
	end, { state, v5, v6, v8, trendingTelemetry, v9 })
end

return useFeedSelection
