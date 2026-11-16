local ExperienceService = game:GetService("ExperienceService")
local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SignalsReact")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/RoactUtils").Hooks.RoactRodux.useSelector
local useNavigationFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/Navigation").useNavigationFocus

local videoEndReason = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/Analytics/Enums").VideoEndReason
require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/VideoPlaybackCoordinator")
require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/ViewportVideoAutoplayController")
local useTargetedWinner = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/useTargetedWinner")

local fFlagLuaAppOneByTwoHoverIdleAutoplay = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppOneByTwoHoverIdleAutoplay
local fFlagLuaAppEdpMediaGalleryFullScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppEdpMediaGalleryFullScreen

local fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback

local fFlagVideoPlaybackDetectorCancelPendingScanTask = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagVideoPlaybackDetectorCancelPendingScanTask

local fIntVideoPlaybackDetectorScanDebounceInMilliseconds = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FIntVideoPlaybackDetectorScanDebounceInMilliseconds
local fFlagEnableOnScreenAPIIntegration = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagEnableOnScreenAPIIntegration

local useIsRouteOnScreen = if fFlagEnableOnScreenAPIIntegration then require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/RobloxAppNavigation").useIsRouteOnScreen else nil

local fFlagLuaAppVideoViewportTargetedWinnerSubscription = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppVideoViewportTargetedWinnerSubscription

local signal = Signals.createSignal({
	instance = nil,
	shouldUseDwell = true,
	isUserIntentWinner = if fFlagLuaAppOneByTwoHoverIdleAutoplay then false else nil
})

local v7 = not fFlagVideoPlaybackDetectorCancelPendingScanTask and 0.5
	or fIntVideoPlaybackDetectorScanDebounceInMilliseconds / 1000

local function VideoViewportPlaybackDetector(data): nil
	local v8 = if fFlagEnableOnScreenAPIIntegration then useIsRouteOnScreen() else useNavigationFocus()

	local v9 = useSelector(function(p2)
		return p2.ScreenSize
	end)

	local v10 = useSelector(function(p2)
		return p2.TopBar.topBarHeight
	end)

	local v11 = useSelector(function(p2)
		return p2.GlobalGuiInset
	end)

	local v12 = React.useMemo(function()
		return {
			min = Vector2.new(0, v10),
			max = Vector2.new(v9.X, v9.Y - v11.bottom)
		}
	end, { v10, v9, v11 })
	local v13

	if fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
		if data.viewportVideoAutoplayController == nil then
			v13 = false
		else
			v13 = data.viewportVideoAutoplayController:getAdsPlaybackCoordinator() == data.videoPlaybackCoordinator
		end
	else
		v13 = nil
	end

	if fFlagLuaAppVideoViewportTargetedWinnerSubscription then
		useTargetedWinner(data, v8, v13)
	end

	local useSignalState = SignalsReact.useSignalState
	local v14

	if
		fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback
		and data.viewportVideoAutoplayController
		and not fFlagLuaAppVideoViewportTargetedWinnerSubscription
	then
		v14 = data.viewportVideoAutoplayController:getWinnerStateForCoordinator(data.videoPlaybackCoordinator)
	elseif
		data.viewportVideoAutoplayController
		and not fFlagLuaAppVideoViewportTargetedWinnerSubscription
	then
		v14 = data.viewportVideoAutoplayController.getWinnerState
	else
		v14 = signal
	end

	local v15 = useSignalState(v14)

	if fFlagLuaAppOneByTwoHoverIdleAutoplay then
		React.useEffect(function()
			local viewportVideoAutoplayController = data.viewportVideoAutoplayController
			local current = data.itemFrameRef.current

			if
				viewportVideoAutoplayController
				and viewportVideoAutoplayController:isUserIntentWithSelectiveAutoplay()
				and current
			then
				viewportVideoAutoplayController:setCandidateUserIntent(
					current,
					data.hasVideoPlaybackUserIntent == true
				)

				return function()
					viewportVideoAutoplayController:setCandidateUserIntent(current, false)
				end
			end
		end, { data.viewportVideoAutoplayController, data.itemFrameRef, data.hasVideoPlaybackUserIntent })
	end

	local useEffect = React.useEffect
	local function fn()
		local viewportVideoAutoplayController = data.viewportVideoAutoplayController

		if fFlagLuaAppVideoViewportTargetedWinnerSubscription or not viewportVideoAutoplayController then
			return
		end

		local current = data.itemFrameRef.current
		local v16 = not (current == nil) and v15.instance == current

		if v16 then
			local videoPlaybackCoordinator = data.videoPlaybackCoordinator

			local v18 = if fFlagLuaAppEdpMediaGalleryFullScreen then data.isItemOccluded else nil

			if not videoPlaybackCoordinator:isPlaybackAllowed(v8, v18) then
				data.cancelVideoPlayback(videoEndReason.ExitViewport)
			elseif fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback and v13 then
				data.requestVideoPlayback(v15.shouldUseDwell)
			elseif fFlagLuaAppOneByTwoHoverIdleAutoplay then
				viewportVideoAutoplayController:requestWinnerPlayback(current, data.requestVideoPlayback)
			else
				data.requestVideoPlayback(v15.shouldUseDwell)
			end
		elseif
			fFlagLuaAppOneByTwoHoverIdleAutoplay
			and viewportVideoAutoplayController:isUserIntentWithSelectiveAutoplay()
			and data.videoPlaybackCoordinator.playingVideoKey == data.videoKey
		then
			data.cancelVideoPlayback(videoEndReason.ExitViewport)
		end
	end

	local viewportVideoAutoplayController = data.viewportVideoAutoplayController
	local itemFrameRef = data.itemFrameRef
	local requestVideoPlayback = data.requestVideoPlayback
	local cancelVideoPlayback = data.cancelVideoPlayback
	local videoPlaybackCoordinator = data.videoPlaybackCoordinator
	local v17 = if fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then v13 else nil
	local videoKey = if fFlagLuaAppOneByTwoHoverIdleAutoplay then data.videoKey else nil

	local v18 = if fFlagLuaAppEdpMediaGalleryFullScreen then data.isItemOccluded else nil
	useEffect(fn, {
		viewportVideoAutoplayController,
		itemFrameRef,
		requestVideoPlayback,
		cancelVideoPlayback,
		videoPlaybackCoordinator,
		v17,
		videoKey,
		v8,
		v15,
		v18
	})

	React.useEffect(function()
		local viewportVideoAutoplayController2 = data.viewportVideoAutoplayController

		if not viewportVideoAutoplayController2 then
			return
		end

		local onUnhideConnection = AppLifecycleObserverService.OnUnhide:Connect(function()
			viewportVideoAutoplayController2:scheduleUpdateWinner("Y", nil, true)
		end)

		local connection = ExperienceService:RegisterForExperienceLeave(function()
			viewportVideoAutoplayController2:scheduleUpdateWinner("Y", nil, true)
		end)

		return function()
			onUnhideConnection:Disconnect()
			connection:Disconnect()
		end
	end, { data.viewportVideoAutoplayController })

	local function fn2()
		if data.viewportVideoAutoplayController ~= nil then
			return
		end

		local v19 = {}
		local v20 = nil

		if data.itemFrameRef.current ~= nil then
			local current = data.itemFrameRef.current
			local now = nil
			local v21 = nil

			local function requestPlaybackIfEligible()
				now = tick()

				local videoPlaybackCoordinator2 = data.videoPlaybackCoordinator

				local v23 = if fFlagLuaAppEdpMediaGalleryFullScreen then data.isItemOccluded else nil

				if videoPlaybackCoordinator2:isPlaybackCandidate(
					v8,
					v23,
					data.itemFrameRef,
					v12,
					data.videoVisiblePercent
				) then
					data.requestVideoPlayback(true)
				else
					data.cancelVideoPlayback(videoEndReason.ExitViewport)
				end
			end

			local function onItemFrameLayoutChange()
				if v21 ~= nil then
					return
				end

				local v22

				if now == nil then
					v22 = 0
				else
					v21 = now + v7
					v22 = v21 - tick()
				end

				if v22 > 0 then
					local thread = task.delay(v22, function()
						v21 = nil
						requestPlaybackIfEligible()
					end)

					if fFlagVideoPlaybackDetectorCancelPendingScanTask then
						v20 = thread
					end
				else
					v21 = nil
					requestPlaybackIfEligible()
				end
			end

			requestPlaybackIfEligible()

			local onUnhideConnection = AppLifecycleObserverService.OnUnhide:Connect(function()
				requestPlaybackIfEligible()
			end)

			local v22 = ExperienceService:RegisterForExperienceLeave(function()
				requestPlaybackIfEligible()
			end)

			v19 = {
				current:GetPropertyChangedSignal("AbsolutePosition"):Connect(onItemFrameLayoutChange),
				current:GetPropertyChangedSignal("AbsoluteSize"):Connect(onItemFrameLayoutChange)
			}

			table.insert(v19, onUnhideConnection)
			table.insert(v19, v22)
		end

		return function()
			if fFlagVideoPlaybackDetectorCancelPendingScanTask and v20 then
				task.cancel(v20)
				v20 = nil
			end

			for k, connection in v19 do
				connection:Disconnect()
			end
		end
	end

	React.useEffect(fn2, {
		if fFlagLuaAppEdpMediaGalleryFullScreen then data.isItemOccluded else nil,
		data.itemFrameRef,
		data.videoVisiblePercent,
		v8,
		v12,
		data.videoPlaybackCoordinator,
		data.requestVideoPlayback,
		data.cancelVideoPlayback,
		data.viewportVideoAutoplayController
	})

	return nil
end

return VideoViewportPlaybackDetector
