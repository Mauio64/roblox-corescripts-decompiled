local MediaPlayback = script:FindFirstAncestor("MediaPlayback")

local Signals = require(MediaPlayback.Parent.Signals)
local SignalsExperimental = require(MediaPlayback.Parent.SignalsExperimental)

local enableAudioPlaybackInApp = require(MediaPlayback.Common.enableAudioPlaybackInApp)
local createAudioSystem = require(MediaPlayback.Stores.getAudioPlaybackStore.createAudioSystem)
local createVolumeStore = require(MediaPlayback.Stores.getAudioPlaybackStore.createVolumeStore)
require(MediaPlayback.Stores.getAudioPlaybackStore.types)

local createSignal = Signals.createSignal
local createEffect = Signals.createEffect
local onDisposed = SignalsExperimental.onDisposed

local v = {
	spawn = function(callback)
		return task.spawn(callback)
	end,
	wait = function(duration)
		return task.wait(duration)
	end
}

local function createAudioStore(assetId, usePreview: boolean?, p)
	local v2 = p or v
	local signal, v3 = createSignal(0)
	local signal2, v4 = createSignal(0)
	local signal3, v5 = createSignal(false)
	local signal4, v6 = createSignal(false)
	local signal5, v7 = createSignal(false)
	local signal6, v8 = createSignal(false)

	local v9 = {}

	local volumeStore = createVolumeStore()

	enableAudioPlaybackInApp()

	local audioSystem = createAudioSystem(assetId, usePreview)
	local audioPlayer = audioSystem.audioPlayer

	local function pause() -- 1 equivalent call inferred from this helper
		v5(false)
		audioPlayer.PlaybackSpeed = 0
	end

	local function stop() -- 1 equivalent call inferred from this helper
		pause() -- inferred equivalent call
		audioPlayer.TimePosition = 0
		v4(0)
	end

	audioPlayer:GetPropertyChangedSignal("TimeLength"):Connect(function()
		v3(audioPlayer.TimeLength)
	end)
	v3(audioPlayer.TimeLength)

	audioPlayer:GetPropertyChangedSignal("IsReady"):Connect(function()
		v8(audioPlayer.IsReady)
	end)
	v8(audioPlayer.IsReady)

	table.insert(v9, createEffect(function(p2)
		if signal3(p2) then
			if not audioPlayer.IsPlaying then
				audioPlayer:Play()
			end

			local flag = true

			v2.spawn(function()
				while flag do
					if audioPlayer.IsPlaying then
						v4(audioPlayer.TimePosition)
						v2.wait(0.0625)
					else
						v6(true)
						stop() -- inferred equivalent call
						break
					end
				end
			end)

			onDisposed(p2, function()
				flag = false
			end)
		end
	end))

	table.insert(v9, createEffect(function(p2)
		audioPlayer.Volume = volumeStore.getVolume(p2)
	end))
	return {
		assetId = assetId,
		usePreview = usePreview,
		getDuration = signal,
		getElapsed = signal2,
		getIsPlaying = signal3,
		getIsElapsed = signal4,
		getIsDestroyed = signal5,
		getIsLoaded = signal6,
		destroy = function()
			audioSystem.destroy()

			for _, v10 in v9 do
				v10()
			end

			v7(true)
		end,
		play = function()
			v5(true)
			v6(false)
			audioPlayer.PlaybackSpeed = 1
		end,
		pause = pause,
		stop = stop,
		seek = function(value: number)
			local timePosition = math.clamp(value, 0, audioPlayer.TimeLength)
			audioPlayer.TimePosition = timePosition
			v4(timePosition)
		end,
		getIsMuted = volumeStore.getIsMuted,
		getVolume = volumeStore.getVolume,
		mute = volumeStore.mute,
		setVolume = volumeStore.setVolume,
		unmute = volumeStore.unmute
	}
end

return createAudioStore
