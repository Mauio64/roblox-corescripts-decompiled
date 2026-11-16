local ExperienceService = game:GetService("ExperienceService")
local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
local VideoUtils = script:FindFirstAncestor("VideoUtils")

local parent = VideoUtils.Parent
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Navigation = require(parent.Navigation)
local useNavigationFocus = Navigation.useNavigationFocus

local Enums = require(VideoUtils.Analytics.Enums)
local VideoEndReason = Enums.VideoEndReason
require(VideoUtils.VideoPlaybackCoordinator)
require(VideoUtils.ViewportVideoAutoplayController)
local useTargetedWinner = require(VideoUtils.useTargetedWinner)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppOneByTwoHoverIdleAutoplay = SharedFlags.FFlagLuaAppOneByTwoHoverIdleAutoplay
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppEdpMediaGalleryFullScreen = SharedFlags2.FFlagLuaAppEdpMediaGalleryFullScreen

local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback = SharedFlags3.FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback

local SharedFlags4 = require(parent.SharedFlags)
local FFlagVideoPlaybackDetectorCancelPendingScanTask = SharedFlags4.FFlagVideoPlaybackDetectorCancelPendingScanTask

local SharedFlags5 = require(parent.SharedFlags)
local FIntVideoPlaybackDetectorScanDebounceInMilliseconds = SharedFlags5.FIntVideoPlaybackDetectorScanDebounceInMilliseconds
local SharedFlags6 = require(parent.SharedFlags)
local FFlagEnableOnScreenAPIIntegration = SharedFlags6.FFlagEnableOnScreenAPIIntegration
local useIsRouteOnScreen

if FFlagEnableOnScreenAPIIntegration then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	useIsRouteOnScreen = RobloxAppNavigation.useIsRouteOnScreen
else
	useIsRouteOnScreen = nil
end

local SharedFlags7 = require(parent.SharedFlags)
local FFlagLuaAppVideoViewportTargetedWinnerSubscription = SharedFlags7.FFlagLuaAppVideoViewportTargetedWinnerSubscription

local signal = Signals.createSignal({
	instance = nil,
	shouldUseDwell = true,
	isUserIntentWinner = not FFlagLuaAppOneByTwoHoverIdleAutoplay and nil
})

local v = not FFlagVideoPlaybackDetectorCancelPendingScanTask and 0.5
	or FIntVideoPlaybackDetectorScanDebounceInMilliseconds / 1000

local function VideoViewportPlaybackDetector(data): nil
	local v2

	if FFlagEnableOnScreenAPIIntegration then
		v2 = useIsRouteOnScreen()
	else
		v2 = useNavigationFocus()
	end

	local v3 = useSelector(function(p)
		return p.ScreenSize
	end)

	local v4 = useSelector(function(p)
		return p.TopBar.topBarHeight
	end)

	local v5 = useSelector(function(p)
		return p.GlobalGuiInset
	end)

	local v6 = React.useMemo(function()
		return {
			min = Vector2.new(0, v4),
			max = Vector2.new(v3.X, v3.Y - v5.bottom)
		}
	end, { v4, v3, v5 })
	local v7

	if FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
		if data.viewportVideoAutoplayController == nil then
			v7 = false
		else
			v7 = data.viewportVideoAutoplayController:getAdsPlaybackCoordinator() == data.videoPlaybackCoordinator
		end
	else
		v7 = nil
	end

	if FFlagLuaAppVideoViewportTargetedWinnerSubscription then
		useTargetedWinner(data, v2, v7)
	end

	local useSignalState = SignalsReact.useSignalState
	local v8

	if
		FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback
		and data.viewportVideoAutoplayController
		and not FFlagLuaAppVideoViewportTargetedWinnerSubscription
	then
		v8 = data.viewportVideoAutoplayController:getWinnerStateForCoordinator(data.videoPlaybackCoordinator)
	elseif data.viewportVideoAutoplayController and not FFlagLuaAppVideoViewportTargetedWinnerSubscription then
		v8 = data.viewportVideoAutoplayController.getWinnerState
	else
		v8 = signal
	end

	local v9 = useSignalState(v8)

	if FFlagLuaAppOneByTwoHoverIdleAutoplay then
		React.useEffect(function()
			local viewportVideoAutoplayController = data.viewportVideoAutoplayController
			local current = data.itemFrameRef.current

			if
				viewportVideoAutoplayController
				and viewportVideoAutoplayController:isUserIntentWithSelectiveAutoplay()
				and current
			then
				viewportVideoAutoplayController:setCandidateUserIntent(current, data.hasVideoPlaybackUserIntent == true)

				return function()
					viewportVideoAutoplayController:setCandidateUserIntent(current, false)
				end
			end
		end, { data.viewportVideoAutoplayController, data.itemFrameRef, data.hasVideoPlaybackUserIntent })
	end

	local useEffect = React.useEffect
	local function fn()
		local viewportVideoAutoplayController = data.viewportVideoAutoplayController

		if FFlagLuaAppVideoViewportTargetedWinnerSubscription or not viewportVideoAutoplayController then
			return
		end

		local current = data.itemFrameRef.current
		local v10

		if current == nil then
			v10 = false
		else
			v10 = v9.instance == current
		end

		if v10 then
			local videoPlaybackCoordinator = data.videoPlaybackCoordinator
			local v11

			if FFlagLuaAppEdpMediaGalleryFullScreen then
				v11 = data.isItemOccluded
			end

			if not videoPlaybackCoordinator:isPlaybackAllowed(v2, v11) then
				data.cancelVideoPlayback(VideoEndReason.ExitViewport)
			elseif FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback and v7 then
				data.requestVideoPlayback(v9.shouldUseDwell)
			elseif FFlagLuaAppOneByTwoHoverIdleAutoplay then
				viewportVideoAutoplayController:requestWinnerPlayback(current, data.requestVideoPlayback)
			else
				data.requestVideoPlayback(v9.shouldUseDwell)
			end
		elseif
			FFlagLuaAppOneByTwoHoverIdleAutoplay
			and viewportVideoAutoplayController:isUserIntentWithSelectiveAutoplay()
			and data.videoPlaybackCoordinator.playingVideoKey == data.videoKey
		then
			data.cancelVideoPlayback(VideoEndReason.ExitViewport)
		end
	end

	local viewportVideoAutoplayController = data.viewportVideoAutoplayController
	local itemFrameRef = data.itemFrameRef
	local requestVideoPlayback = data.requestVideoPlayback
	local cancelVideoPlayback = data.cancelVideoPlayback
	local videoPlaybackCoordinator = data.videoPlaybackCoordinator
	local v10

	if FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
		v10 = v7
	end

	local videoKey

	if FFlagLuaAppOneByTwoHoverIdleAutoplay then
		videoKey = data.videoKey
	end

	local v11

	if FFlagLuaAppEdpMediaGalleryFullScreen then
		v11 = data.isItemOccluded
	end

	useEffect(fn, {
		viewportVideoAutoplayController,
		itemFrameRef,
		requestVideoPlayback,
		cancelVideoPlayback,
		videoPlaybackCoordinator,
		v10,
		videoKey,
		v2,
		v9,
		v11
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

	local useEffect2 = React.useEffect
	local function fn2()
		if data.viewportVideoAutoplayController ~= nil then
			return
		end

		local v12 = {}
		local v13 = nil

		if data.itemFrameRef.current ~= nil then
			local current = data.itemFrameRef.current
			local now = nil
			local v14 = nil

			local function requestPlaybackIfEligible()
				now = tick()

				local videoPlaybackCoordinator2 = data.videoPlaybackCoordinator
				local v15

				if FFlagLuaAppEdpMediaGalleryFullScreen then
					v15 = data.isItemOccluded
				end

				if videoPlaybackCoordinator2:isPlaybackCandidate(
					v2,
					v15,
					data.itemFrameRef,
					v6,
					data.videoVisiblePercent
				) then
					data.requestVideoPlayback(true)
				else
					data.cancelVideoPlayback(VideoEndReason.ExitViewport)
				end
			end

			local function onItemFrameLayoutChange()
				if v14 ~= nil then
					return
				end

				local v15

				if now == nil then
					v15 = 0
				else
					v14 = now + v
					v15 = v14 - tick()
				end

				if v15 > 0 then
					local thread = task.delay(v15, function()
						v14 = nil
						requestPlaybackIfEligible()
					end)

					if FFlagVideoPlaybackDetectorCancelPendingScanTask then
						v13 = thread
					end
				else
					v14 = nil
					requestPlaybackIfEligible()
				end
			end

			requestPlaybackIfEligible()

			local onUnhideConnection = AppLifecycleObserverService.OnUnhide:Connect(function()
				requestPlaybackIfEligible()
			end)

			local v15 = ExperienceService:RegisterForExperienceLeave(function()
				requestPlaybackIfEligible()
			end)

			v12 = {
				current:GetPropertyChangedSignal("AbsolutePosition"):Connect(onItemFrameLayoutChange),
				current:GetPropertyChangedSignal("AbsoluteSize"):Connect(onItemFrameLayoutChange)
			}

			table.insert(v12, onUnhideConnection)
			table.insert(v12, v15)
		end

		return function()
			if FFlagVideoPlaybackDetectorCancelPendingScanTask and v13 then
				task.cancel(v13)
				v13 = nil
			end

			for _, connection in v12 do
				connection:Disconnect()
			end
		end
	end

	local v12

	if FFlagLuaAppEdpMediaGalleryFullScreen then
		v12 = data.isItemOccluded
	end

	useEffect2(fn2, {
		v12,
		data.itemFrameRef,
		data.videoVisiblePercent,
		v2,
		v6,
		data.videoPlaybackCoordinator,
		data.requestVideoPlayback,
		data.cancelVideoPlayback,
		data.viewportVideoAutoplayController
	})

	return nil
end

return VideoViewportPlaybackDetector
