local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaPlayback/Signals")
local SignalsExperimental = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaPlayback/SignalsExperimental")

local enableAudioPlaybackInApp = require("@game/CorePackages/Workspace/Packages/_Index/MediaPlayback/MediaPlayback/Common/enableAudioPlaybackInApp")
local createAudioSystem = require("@game/CorePackages/Workspace/Packages/_Index/MediaPlayback/MediaPlayback/Stores/getAudioPlaybackStore/createAudioSystem")
local createVolumeStore = require("@game/CorePackages/Workspace/Packages/_Index/MediaPlayback/MediaPlayback/Stores/getAudioPlaybackStore/createVolumeStore")
require("@game/CorePackages/Workspace/Packages/_Index/MediaPlayback/MediaPlayback/Stores/getAudioPlaybackStore/types")

local createSignal = Signals.createSignal
local createEffect = Signals.createEffect
local onDisposed = SignalsExperimental.onDisposed

local v5 = {
	spawn = function(callback)
		return task.spawn(callback)
	end,
	wait = function(duration)
		return task.wait(duration)
	end
}

local function createAudioStore(p2, p3, p4)
	local v6 = p4 or v5
	local signal, v7 = createSignal(0)
	local signal2, v8 = createSignal(0)
	local signal3, v9 = createSignal(false)
	local signal4, v10 = createSignal(false)
	local signal5, v11 = createSignal(false)
	local signal6, v12 = createSignal(false)

	local v13 = {}

	local v14 = createVolumeStore()

	enableAudioPlaybackInApp()

	local v15 = createAudioSystem(p2, p3)
	local audioPlayer = v15.audioPlayer

	audioPlayer:GetPropertyChangedSignal("TimeLength"):Connect(function()
		v7(audioPlayer.TimeLength)
	end)
	v7(audioPlayer.TimeLength)

	audioPlayer:GetPropertyChangedSignal("IsReady"):Connect(function()
		v12(audioPlayer.IsReady)
	end)
	v12(audioPlayer.IsReady)

	table.insert(v13, createEffect(function(p5)
		if signal3(p5) then
			if not audioPlayer.IsPlaying then
				audioPlayer:Play()
			end

			local flag = true

			v6.spawn(function()
				while flag do
					if audioPlayer.IsPlaying then
						v8(audioPlayer.TimePosition)
						v6.wait(0.0625)
					else
						v10(true)
						v9(false)
						audioPlayer.PlaybackSpeed = 0

						audioPlayer.TimePosition = 0
						v8(0)
						break
					end
				end
			end)

			onDisposed(p5, function()
				flag = false
			end)
		end
	end))

	table.insert(v13, createEffect(function(p5)
		audioPlayer.Volume = v14.getVolume(p5)
	end))
	return {
		assetId = p2,
		usePreview = p3,
		getDuration = signal,
		getElapsed = signal2,
		getIsPlaying = signal3,
		getIsElapsed = signal4,
		getIsDestroyed = signal5,
		getIsLoaded = signal6,
		destroy = function()
			v15.destroy()

			for k, v16 in v13 do
				v16()
			end

			v11(true)
		end,
		play = function()
			v9(true)
			v10(false)
			audioPlayer.PlaybackSpeed = 1
		end,
		pause = function()
			v9(false)
			audioPlayer.PlaybackSpeed = 0
		end,
		stop = function()
			v9(false)
			audioPlayer.PlaybackSpeed = 0

			audioPlayer.TimePosition = 0
			v8(0)
		end,
		seek = function(value)
			local v16 = math.clamp(value, 0, audioPlayer.TimeLength)
			audioPlayer.TimePosition = v16
			v8(v16)
		end,
		getIsMuted = v14.getIsMuted,
		getVolume = v14.getVolume,
		mute = v14.mute,
		setVolume = v14.setVolume,
		unmute = v14.unmute
	}
end

return createAudioStore
