local ExperienceService = game:GetService("ExperienceService")
local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/Responsive")
local useNavigationFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/Navigation").useNavigationFocus

local videoEndReason = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/Analytics/Enums").VideoEndReason
local FeedVideoPlaybackContext = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/FeedVideoPlaybackContext")
require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/VideoPlaybackDetectionMethod")

local fFlagLuaAppSearchResultsPageGameTileVideo = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppSearchResultsPageGameTileVideo

local fFlagLuaAppSuppressVideoDetectorDuringScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppSuppressVideoDetectorDuringScroll
local fFlagLuaAppVideoAutoplayFeedElection = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppVideoAutoplayFeedElection
local fFlagLuaAppOneByTwoHoverIdleAutoplay = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppOneByTwoHoverIdleAutoplay
local fFlagEnableOnScreenAPIIntegration = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagEnableOnScreenAPIIntegration

local useIsRouteOnScreen = if fFlagEnableOnScreenAPIIntegration then require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/RobloxAppNavigation").useIsRouteOnScreen else nil

local function useFeedVideoPlaybackContext(p2, p3, p4, p5, p6)
	local v5 = if fFlagEnableOnScreenAPIIntegration then useIsRouteOnScreen() else useNavigationFocus()
	local v6

	if fFlagLuaAppSuppressVideoDetectorDuringScroll then
		v6 = Responsive.usePreferredInput() == Responsive.Input.Touch
	else
		v6 = nil
	end

	local state, setState

	if fFlagLuaAppSuppressVideoDetectorDuringScroll then
		state, setState = React.useState(false)
	else
		setState = nil
	end

	local v7 = fFlagLuaAppSearchResultsPageGameTileVideo and p3 == true and true or not v5
	local v8 = fFlagLuaAppSuppressVideoDetectorDuringScroll and state == true
	local useMemo = React.useMemo
	local function fn()
		local new = FeedVideoPlaybackContext.new
		local v9 = if not fFlagLuaAppOneByTwoHoverIdleAutoplay then p2 else nil
		local v10 = if fFlagLuaAppVideoAutoplayFeedElection then p4 else nil
		local v11 = if fFlagLuaAppVideoAutoplayFeedElection then p5 else nil
		return new(v9, v10, v11, if fFlagLuaAppOneByTwoHoverIdleAutoplay then p6 else nil)
	end

	local v10 = if fFlagLuaAppOneByTwoHoverIdleAutoplay then p6 else p2
	local v11 = if fFlagLuaAppVideoAutoplayFeedElection then p4 else nil
	local v13 = useMemo(fn, { v10, v11, if fFlagLuaAppVideoAutoplayFeedElection then p5 else nil })

	local function fn2()
		if v7 or fFlagLuaAppSuppressVideoDetectorDuringScroll and v8 then
			return (setmetatable({
				videoPlaybackCoordinator = v13.videoPlaybackCoordinator,
				viewportVideoAutoplayController = v13.viewportVideoAutoplayController,
				disablePlayback = (not fFlagLuaAppSuppressVideoDetectorDuringScroll or v7) and true or nil,
				disableDetectors = fFlagLuaAppSuppressVideoDetectorDuringScroll and v8 and true or nil
			}, FeedVideoPlaybackContext))
		end

		return v13
	end

	local v16 = React.useMemo(fn2, {
		v13,
		v7,
		if fFlagLuaAppSuppressVideoDetectorDuringScroll then v8 else nil
	})

	if fFlagLuaAppOneByTwoHoverIdleAutoplay then
		React.useEffect(function()
			local viewportVideoAutoplayController = v13.viewportVideoAutoplayController

			if
				v5
				and viewportVideoAutoplayController
				and viewportVideoAutoplayController:isUserIntentWithSelectiveAutoplay()
			then
				viewportVideoAutoplayController:scheduleUpdateWinner("Y", nil, true)
			end
		end, { v13.viewportVideoAutoplayController, v5 })
	end

	local function fn3()
		if v16.viewportVideoAutoplayController then
			if fFlagLuaAppSuppressVideoDetectorDuringScroll then
				v16.viewportVideoAutoplayController:setSuppressDetectorsDuringScroll(v6 == true)
			end

			v16.viewportVideoAutoplayController:onScrollStart()
		end

		if fFlagLuaAppSuppressVideoDetectorDuringScroll and v6 and setState then
			setState(true)
		end
	end

	local v19 = React.useCallback(fn3, {
		v16.viewportVideoAutoplayController,
		if fFlagLuaAppSuppressVideoDetectorDuringScroll then v6 else nil
	})

	local v20 = React.useCallback(function(p7)
		if fFlagLuaAppSuppressVideoDetectorDuringScroll and setState then
			setState(false)
		end

		if v16.viewportVideoAutoplayController then
			v16.viewportVideoAutoplayController:onScrollSettled("Y", p7, nil)
		end
	end, { v16.viewportVideoAutoplayController })

	if fFlagLuaAppSuppressVideoDetectorDuringScroll then
		React.useEffect(function()
			local viewportVideoAutoplayController2 = v16.viewportVideoAutoplayController

			if viewportVideoAutoplayController2 and v6 then
				local onHideConnection = AppLifecycleObserverService.OnHide:Connect(function()
					viewportVideoAutoplayController2:reset(videoEndReason.AppBackgrounded)
				end)
				local connection = ExperienceService:RegisterForExperienceJoin(function()
					viewportVideoAutoplayController2:reset(videoEndReason.ExperienceLaunched)
				end)

				return function()
					onHideConnection:Disconnect()
					connection:Disconnect()
				end
			end
		end, { v16.viewportVideoAutoplayController, v6 })
	end

	return v16, v19, v20
end

return useFeedVideoPlaybackContext
