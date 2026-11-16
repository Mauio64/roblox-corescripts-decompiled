local ExperienceService = game:GetService("ExperienceService")
local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")

local VideoUtils = script:FindFirstAncestor("VideoUtils")
local parent = VideoUtils.Parent

local React = require(parent.React)
local Responsive = require(parent.Responsive)
local Navigation = require(parent.Navigation)
local useNavigationFocus = Navigation.useNavigationFocus

local Enums = require(VideoUtils.Analytics.Enums)
local VideoEndReason = Enums.VideoEndReason
local FeedVideoPlaybackContext = require(script.Parent.FeedVideoPlaybackContext)
require(script.Parent.VideoPlaybackDetectionMethod)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppSearchResultsPageGameTileVideo = SharedFlags.FFlagLuaAppSearchResultsPageGameTileVideo

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppSuppressVideoDetectorDuringScroll = SharedFlags2.FFlagLuaAppSuppressVideoDetectorDuringScroll
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppVideoAutoplayFeedElection = SharedFlags3.FFlagLuaAppVideoAutoplayFeedElection
local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppOneByTwoHoverIdleAutoplay = SharedFlags4.FFlagLuaAppOneByTwoHoverIdleAutoplay
local SharedFlags5 = require(parent.SharedFlags)
local FFlagEnableOnScreenAPIIntegration = SharedFlags5.FFlagEnableOnScreenAPIIntegration
local useIsRouteOnScreen

if FFlagEnableOnScreenAPIIntegration then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	useIsRouteOnScreen = RobloxAppNavigation.useIsRouteOnScreen
else
	useIsRouteOnScreen = nil
end

local function useFeedVideoPlaybackContext(flag: boolean?, flag2: boolean?, flag3: boolean?, flag4: boolean?, p)
	local v

	if FFlagEnableOnScreenAPIIntegration then
		v = useIsRouteOnScreen()
	else
		v = useNavigationFocus()
	end

	local v2

	if FFlagLuaAppSuppressVideoDetectorDuringScroll then
		v2 = Responsive.usePreferredInput() == Responsive.Input.Touch
	else
		v2 = nil
	end

	local state, setState

	if FFlagLuaAppSuppressVideoDetectorDuringScroll then
		state, setState = React.useState(false)
	else
		setState = nil
	end

	local v3 = FFlagLuaAppSearchResultsPageGameTileVideo and flag2 == true and true or not v
	local v4 = FFlagLuaAppSuppressVideoDetectorDuringScroll and state == true
	local useMemo = React.useMemo
	local function fn()
		local new = FeedVideoPlaybackContext.new
		local v5

		if not FFlagLuaAppOneByTwoHoverIdleAutoplay then
			v5 = flag
		end

		local v6

		if FFlagLuaAppVideoAutoplayFeedElection then
			v6 = flag3
		end

		local v7

		if FFlagLuaAppVideoAutoplayFeedElection then
			v7 = flag4
		end

		local v8

		if FFlagLuaAppOneByTwoHoverIdleAutoplay then
			v8 = p
		end

		return new(v5, v6, v7, v8)
	end

	local v5 = if FFlagLuaAppOneByTwoHoverIdleAutoplay then p else flag
	local v6

	if FFlagLuaAppVideoAutoplayFeedElection then
		v6 = flag3
	end

	local v7

	if FFlagLuaAppVideoAutoplayFeedElection then
		v7 = flag4
	end

	local v8 = useMemo(fn, { v5, v6, v7 })

	local useMemo2 = React.useMemo
	local function fn2()
		if v3 or FFlagLuaAppSuppressVideoDetectorDuringScroll and v4 then
			return (setmetatable({
				videoPlaybackCoordinator = v8.videoPlaybackCoordinator,
				viewportVideoAutoplayController = v8.viewportVideoAutoplayController,
				disablePlayback = (not FFlagLuaAppSuppressVideoDetectorDuringScroll or v3) and true or nil,
				disableDetectors = FFlagLuaAppSuppressVideoDetectorDuringScroll and v4 and true or nil
			}, FeedVideoPlaybackContext))
		end

		return v8
	end

	local v9

	if FFlagLuaAppSuppressVideoDetectorDuringScroll then
		v9 = v4
	end

	local v10 = useMemo2(fn2, { v8, v3, v9 })

	if FFlagLuaAppOneByTwoHoverIdleAutoplay then
		React.useEffect(function()
			local viewportVideoAutoplayController = v8.viewportVideoAutoplayController

			if
				v
				and viewportVideoAutoplayController
				and viewportVideoAutoplayController:isUserIntentWithSelectiveAutoplay()
			then
				viewportVideoAutoplayController:scheduleUpdateWinner("Y", nil, true)
			end
		end, { v8.viewportVideoAutoplayController, v })
	end

	local useCallback = React.useCallback
	local function fn3()
		if v10.viewportVideoAutoplayController then
			if FFlagLuaAppSuppressVideoDetectorDuringScroll then
				v10.viewportVideoAutoplayController:setSuppressDetectorsDuringScroll(v2 == true)
			end

			v10.viewportVideoAutoplayController:onScrollStart()
		end

		if FFlagLuaAppSuppressVideoDetectorDuringScroll and v2 and setState then
			setState(true)
		end
	end

	local viewportVideoAutoplayController = v10.viewportVideoAutoplayController
	local v11

	if FFlagLuaAppSuppressVideoDetectorDuringScroll then
		v11 = v2
	end

	local v12 = useCallback(fn3, { viewportVideoAutoplayController, v11 })

	local v13 = React.useCallback(function(p2: number)
		if FFlagLuaAppSuppressVideoDetectorDuringScroll and setState then
			setState(false)
		end

		if v10.viewportVideoAutoplayController then
			v10.viewportVideoAutoplayController:onScrollSettled("Y", p2, nil)
		end
	end, { v10.viewportVideoAutoplayController })

	if FFlagLuaAppSuppressVideoDetectorDuringScroll then
		React.useEffect(function()
			local viewportVideoAutoplayController2 = v10.viewportVideoAutoplayController

			if viewportVideoAutoplayController2 and v2 then
				local onHideConnection = AppLifecycleObserverService.OnHide:Connect(function()
					viewportVideoAutoplayController2:reset(VideoEndReason.AppBackgrounded)
				end)
				local connection = ExperienceService:RegisterForExperienceJoin(function()
					viewportVideoAutoplayController2:reset(VideoEndReason.ExperienceLaunched)
				end)

				return function()
					onHideConnection:Disconnect()
					connection:Disconnect()
				end
			end
		end, { v10.viewportVideoAutoplayController, v2 })
	end

	return v10, v12, v13
end

return useFeedVideoPlaybackContext
