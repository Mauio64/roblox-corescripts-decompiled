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

local function createAudioStore(p1, b1: boolean?) -- line: 17
	-- upvalues: createSignal (copy), createVolumeStore (copy), enableAudioPlaybackInApp (copy), createAudioSystem (copy), createEffect (copy), onDisposed (copy)
	local v13, v14 = createSignal(0)
	local v15, v16 = createSignal(0)
	local v17, v18 = createSignal(false)
	local v19, v20 = createSignal(false)
	local v21, v22 = createSignal(false)
	local v23, v24 = createSignal(false)
	local t1 = {}
	local v26 = createVolumeStore()

	enableAudioPlaybackInApp()

	local v27 = createAudioSystem(p1, b1)
	local audioPlayer = v27.audioPlayer

	audioPlayer:GetPropertyChangedSignal("TimeLength"):Connect(function() -- line: 57
		-- upvalues: v14 (copy), audioPlayer (copy)
		v14(audioPlayer.TimeLength)
	end)
	v14(audioPlayer.TimeLength)
	audioPlayer:GetPropertyChangedSignal("IsReady"):Connect(function() -- line: 62
		-- upvalues: v24 (copy), audioPlayer (copy)
		v24(audioPlayer.IsReady)
	end)
	v24(audioPlayer.IsReady)
	table.insert(t1, createEffect(function(p2) -- line: 69
		-- upvalues: v17 (copy), audioPlayer (copy), v20 (copy), v18 (copy), v16 (copy), onDisposed (copy)
		if v17(p2) then
			if not audioPlayer.IsPlaying then
				audioPlayer:Play()
			end

			local u32 = true

			task.spawn(function() -- line: 79
				-- upvalues: u32 (ref), audioPlayer (copy), v20 (copy), v18 (copy), v16 (copy)
				while u32 do
					if not audioPlayer.IsPlaying then
						v20(true)
						v18(false)
						audioPlayer.PlaybackSpeed = 0
						audioPlayer.TimePosition = 0
						v16(0)

						return
					end

					v16(audioPlayer.TimePosition)
					task.wait(0.0625)
				end
			end)
			onDisposed(p2, function() -- line: 92
				-- upvalues: u32 (ref)
				u32 = false
			end)
		end
	end))
	table.insert(t1, createEffect(function(p3) -- line: 101
		-- upvalues: audioPlayer (copy), v26 (copy)
		audioPlayer.Volume = v26.getVolume(p3)
	end))

	return {
		assetId = p1,
		usePreview = b1,
		getDuration = v13,
		getElapsed = v15,
		getIsPlaying = v17,
		getIsElapsed = v19,
		getIsDestroyed = v21,
		getIsLoaded = v23,
		destroy = function() -- line: 106
			-- upvalues: v27 (copy), t1 (copy), v22 (copy)
			v27.destroy()

			for _, v35 in t1 do
				v35()
			end

			v22(true)
		end,
		play = function() -- line: 34
			-- upvalues: v18 (copy), v20 (copy), audioPlayer (copy)
			v18(true)
			v20(false)
			audioPlayer.PlaybackSpeed = 1
		end,
		pause = function() -- line: 40
			-- upvalues: v18 (copy), audioPlayer (copy)
			v18(false)
			audioPlayer.PlaybackSpeed = 0
		end,
		stop = function() -- line: 45
			-- upvalues: v18 (copy), audioPlayer (copy), v16 (copy)
			v18(false)
			audioPlayer.PlaybackSpeed = 0
			audioPlayer.TimePosition = 0
			v16(0)
		end,
		seek = function(n1: number) -- line: 51
			-- upvalues: audioPlayer (copy), v16 (copy)
			local v30 = math.clamp(n1, 0, audioPlayer.TimeLength)

			audioPlayer.TimePosition = v30
			v16(v30)
		end,
		getIsMuted = v26.getIsMuted,
		getVolume = v26.getVolume,
		mute = v26.mute,
		setVolume = v26.setVolume,
		unmute = v26.unmute
	}
end

return createAudioStore
