local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SignalsReact")

local videoEndReason = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/Analytics/Enums").VideoEndReason
require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/VideoPlaybackCoordinator")
require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/ViewportVideoAutoplayController")

local fFlagLuaAppEdpMediaGalleryFullScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppEdpMediaGalleryFullScreen
local fFlagLuaAppOneByTwoHoverIdleAutoplay = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppOneByTwoHoverIdleAutoplay

local fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback

local frozen = table.freeze({ isWinner = false, shouldUseDwell = false })
local signal = Signals.createSignal(frozen)

local function verdictEquals(data, data2): boolean
	return data.isWinner == data2.isWinner
		and data.shouldUseDwell == data2.shouldUseDwell
		and data.isUserIntentWinner == data2.isUserIntentWinner
end

local function useTargetedWinner(data, p2, p3)
	local v5 = React.useMemo(function()
		local signal2, v6 = Signals.createSignal(nil)
		return { get = signal2, set = v6 }
	end, {})

	React.useEffect(function()
		if v5.get(false) ~= data.itemFrameRef.current then
			v5.set(data.itemFrameRef.current)
		end
	end)

	local useMemo = React.useMemo
	local function fn()
		local viewportVideoAutoplayController = data.viewportVideoAutoplayController

		if not viewportVideoAutoplayController then
			return signal
		end

		local v6

		if fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
			v6 = viewportVideoAutoplayController:getWinnerStateForCoordinator(data.videoPlaybackCoordinator)
		else
			v6 = viewportVideoAutoplayController.getWinnerState
		end

		return Signals.createComputed(function(p4)
			local v7 = v6(p4)
			local v8 = v5.get(p4)

			if v8 == nil or v7.instance ~= v8 then
				return frozen
			end

			local v9 = {
				isWinner = true,
				shouldUseDwell = v7.shouldUseDwell,
				isUserIntentWinner = 0
			}

			local v10 = if fFlagLuaAppOneByTwoHoverIdleAutoplay then v7.isUserIntentWinner else nil
			v9.isUserIntentWinner = v10
			return v9
		end, verdictEquals)
	end

	local viewportVideoAutoplayController = data.viewportVideoAutoplayController
	local videoPlaybackCoordinator

	if fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
		videoPlaybackCoordinator = data.videoPlaybackCoordinator
	end

	local v8 = useMemo(fn, {
		viewportVideoAutoplayController,
		v5,
		videoPlaybackCoordinator,
		if fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then p3 else nil
	})

	local v9 = SignalsReact.useSignalState(v8)

	local useEffect = React.useEffect
	local function fn2()
		local viewportVideoAutoplayController2 = data.viewportVideoAutoplayController

		if not viewportVideoAutoplayController2 then
			return
		end

		if v9.isWinner then
			local videoPlaybackCoordinator2 = data.videoPlaybackCoordinator

			local v11 = if fFlagLuaAppEdpMediaGalleryFullScreen then data.isItemOccluded else nil

			if not videoPlaybackCoordinator2:isPlaybackAllowed(p2, v11) then
				data.cancelVideoPlayback(videoEndReason.ExitViewport)
			elseif fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback and p3 then
				data.requestVideoPlayback(v9.shouldUseDwell)
			elseif fFlagLuaAppOneByTwoHoverIdleAutoplay then
				viewportVideoAutoplayController2:requestWinnerPlayback(
					v5.get(false),
					data.requestVideoPlayback
				)
			else
				data.requestVideoPlayback(v9.shouldUseDwell)
			end
		elseif
			fFlagLuaAppOneByTwoHoverIdleAutoplay
			and viewportVideoAutoplayController2:isUserIntentWithSelectiveAutoplay()
			and data.videoPlaybackCoordinator.playingVideoKey == data.videoKey
		then
			data.cancelVideoPlayback(videoEndReason.ExitViewport)
		end
	end

	local viewportVideoAutoplayController2 = data.viewportVideoAutoplayController
	local videoPlaybackCoordinator2 = data.videoPlaybackCoordinator
	local requestVideoPlayback = data.requestVideoPlayback
	local cancelVideoPlayback = data.cancelVideoPlayback
	local v11 = if fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then p3 else nil
	local videoKey = if fFlagLuaAppOneByTwoHoverIdleAutoplay then data.videoKey else nil

	local v12 = if fFlagLuaAppEdpMediaGalleryFullScreen then data.isItemOccluded else nil
	useEffect(fn2, {
		viewportVideoAutoplayController2,
		videoPlaybackCoordinator2,
		requestVideoPlayback,
		cancelVideoPlayback,
		v11,
		videoKey,
		v5,
		p2,
		v9,
		v12
	})
end

return useTargetedWinner
