local VideoUtils = script:FindFirstAncestor("VideoUtils")
local parent = VideoUtils.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local Enums = require(VideoUtils.Analytics.Enums)
local VideoEndReason = Enums.VideoEndReason
require(VideoUtils.VideoPlaybackCoordinator)
require(VideoUtils.ViewportVideoAutoplayController)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEdpMediaGalleryFullScreen = SharedFlags.FFlagLuaAppEdpMediaGalleryFullScreen
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppOneByTwoHoverIdleAutoplay = SharedFlags2.FFlagLuaAppOneByTwoHoverIdleAutoplay

local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback = SharedFlags3.FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback

local frozen = table.freeze({ isWinner = false, shouldUseDwell = false })
local signal = Signals.createSignal(frozen)

local function verdictEquals(data, data2): boolean
	return data.isWinner == data2.isWinner
		and data.shouldUseDwell == data2.shouldUseDwell
		and data.isUserIntentWinner == data2.isUserIntentWinner
end

local function useTargetedWinner(data, flag: boolean, flag2: boolean)
	local v = React.useMemo(function()
		local signal2, set = Signals.createSignal(nil)
		return { get = signal2, set = set }
	end, {})

	React.useEffect(function()
		if v.get(false) ~= data.itemFrameRef.current then
			v.set(data.itemFrameRef.current)
		end
	end)

	local useMemo = React.useMemo
	local function fn()
		local viewportVideoAutoplayController = data.viewportVideoAutoplayController

		if not viewportVideoAutoplayController then
			return signal
		end

		local v2

		if FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
			v2 = viewportVideoAutoplayController:getWinnerStateForCoordinator(data.videoPlaybackCoordinator)
		else
			v2 = viewportVideoAutoplayController.getWinnerState
		end

		return Signals.createComputed(function(p)
			local v3 = v2(p)
			local v4 = v.get(p)

			if v4 == nil or v3.instance ~= v4 then
				return frozen
			end

			local v5 = {
				isWinner = true,
				shouldUseDwell = v3.shouldUseDwell,
				isUserIntentWinner = 0
			}
			local isUserIntentWinner

			if FFlagLuaAppOneByTwoHoverIdleAutoplay then
				isUserIntentWinner = v3.isUserIntentWinner
			end

			v5.isUserIntentWinner = isUserIntentWinner
			return v5
		end, verdictEquals)
	end

	local viewportVideoAutoplayController = data.viewportVideoAutoplayController
	local videoPlaybackCoordinator

	if FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
		videoPlaybackCoordinator = data.videoPlaybackCoordinator
	end

	local v2

	if FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
		v2 = flag2
	end

	local v3 = useMemo(fn, { viewportVideoAutoplayController, v, videoPlaybackCoordinator, v2 })

	local v4 = SignalsReact.useSignalState(v3)

	local useEffect = React.useEffect
	local function fn2()
		local viewportVideoAutoplayController2 = data.viewportVideoAutoplayController

		if not viewportVideoAutoplayController2 then
			return
		end

		if v4.isWinner then
			local videoPlaybackCoordinator2 = data.videoPlaybackCoordinator
			local v5

			if FFlagLuaAppEdpMediaGalleryFullScreen then
				v5 = data.isItemOccluded
			end

			if not videoPlaybackCoordinator2:isPlaybackAllowed(flag, v5) then
				data.cancelVideoPlayback(VideoEndReason.ExitViewport)
			elseif FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback and flag2 then
				data.requestVideoPlayback(v4.shouldUseDwell)
			elseif FFlagLuaAppOneByTwoHoverIdleAutoplay then
				viewportVideoAutoplayController2:requestWinnerPlayback(v.get(false), data.requestVideoPlayback)
			else
				data.requestVideoPlayback(v4.shouldUseDwell)
			end
		elseif
			FFlagLuaAppOneByTwoHoverIdleAutoplay
			and viewportVideoAutoplayController2:isUserIntentWithSelectiveAutoplay()
			and data.videoPlaybackCoordinator.playingVideoKey == data.videoKey
		then
			data.cancelVideoPlayback(VideoEndReason.ExitViewport)
		end
	end

	local viewportVideoAutoplayController2 = data.viewportVideoAutoplayController
	local videoPlaybackCoordinator2 = data.videoPlaybackCoordinator
	local requestVideoPlayback = data.requestVideoPlayback
	local cancelVideoPlayback = data.cancelVideoPlayback
	local v5

	if FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
		v5 = flag2
	end

	local videoKey

	if FFlagLuaAppOneByTwoHoverIdleAutoplay then
		videoKey = data.videoKey
	end

	local v6

	if FFlagLuaAppEdpMediaGalleryFullScreen then
		v6 = data.isItemOccluded
	end

	useEffect(fn2, {
		viewportVideoAutoplayController2,
		videoPlaybackCoordinator2,
		requestVideoPlayback,
		cancelVideoPlayback,
		v5,
		videoKey,
		v,
		flag,
		v4,
		v6
	})
end

return useTargetedWinner
