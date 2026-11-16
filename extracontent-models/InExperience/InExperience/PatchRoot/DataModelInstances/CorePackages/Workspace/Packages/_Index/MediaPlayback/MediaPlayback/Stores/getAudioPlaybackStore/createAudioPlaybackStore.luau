local MediaPlayback = script:FindFirstAncestor("MediaPlayback")

local Cryo = require(MediaPlayback.Parent.Cryo)
local Signals = require(MediaPlayback.Parent.Signals)
local SignalsExperimental = require(MediaPlayback.Parent.SignalsExperimental)

local createConsumerCounterStore = require(MediaPlayback.Stores.getAudioPlaybackStore.createConsumerCounterStore)
local createAudioStore = require(MediaPlayback.Stores.getAudioPlaybackStore.createAudioStore)
local createPlaylistStore = require(MediaPlayback.Stores.getAudioPlaybackStore.createPlaylistStore)
local createVolumeStore = require(MediaPlayback.Stores.getAudioPlaybackStore.createVolumeStore)
require(MediaPlayback.Stores.getAudioPlaybackStore.types)
local getFFlagAudioPreviewLua = require(MediaPlayback.Flags.getFFlagAudioPreviewLua)

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local function createEffect(p, fn) -- 1 equivalent call inferred from this helper
	SignalsExperimental.onDisposed(p, Signals.createEffect(fn))
end

local function audioStoreKey(p, flag: boolean?) -- 2 equivalent calls inferred from this helper
	if getFFlagAudioPreviewLua() and flag then
		return tostring(p) .. ":preview"
	end

	return (tostring(p))
end

local function createAudioPlaybackStore(p)
	local signal, v = createSignal({})

	local consumerCounterStore = createConsumerCounterStore()
	local volumeStore = createVolumeStore()
	local playlistStore = createPlaylistStore()

	local function getOrCreateAudioStore(p2, flag: boolean?)
		local v2 = audioStoreKey(p2, flag) -- inferred equivalent call
		local audioStore = signal(false)[v2]

		if not audioStore then
			audioStore = createAudioStore(p2, flag)

			v(function(p3)
				return Cryo.Dictionary.join(p3, { [v2] = audioStore })
			end)
		end

		consumerCounterStore.subscribe(v2)

		return audioStore
	end

	local signal2, v2 = createSignal({})

	local v3 = nil
	local getLastPlayedAudioStore = createComputed(function(p2)
		local v4 = signal2(p2)
		local v5 = v4[#v4]

		if v5 then
			v3 = v5
		end

		return v3
	end)

	local function getNextSong() -- 1 equivalent call inferred from this helper
		local v4 = getLastPlayedAudioStore(false)

		local v5 = v4 and playlistStore.getNext(v4.assetId)

		if v5 then
			return getOrCreateAudioStore(v5)
		end

		return nil
	end

	local hasNextSong = createComputed(function(p2): boolean
		local v4 = getLastPlayedAudioStore(p2)

		if v4 then
			return playlistStore.getNext(v4.assetId) ~= nil
		end

		return false
	end)

	local hasPrevSong = createComputed(function(p2): boolean
		local v4 = getLastPlayedAudioStore(p2)

		if v4 then
			return playlistStore.getPrev(v4.assetId) ~= nil
		end

		return false
	end)

	local function destroyByKey(p2: string)
		local v4 = signal(false)[p2]

		if v4 then
			if consumerCounterStore.unsubscribe(p2) > 0 then
				return
			end

			v4.destroy()

			v(function(p3)
				return Cryo.Dictionary.join(p3, { [p2] = Cryo.None })
			end)
		end
	end

	SignalsExperimental.onDisposed(p, Signals.createEffect(function(p2)
		for k, v4 in consumerCounterStore.getConsumerCounts(p2) do
			if v4 <= 0 then
				destroyByKey(k)
			end
		end
	end))
	SignalsExperimental.onDisposed(p, Signals.createEffect(function(p2)
		for k, v4 in signal(p2) do
			if v4.getIsDestroyed(p2) then
				destroyByKey(k)
			end
		end
	end))

	local function fn(p2)
		for _, v4 in signal(p2) do
			local isPlaying = v4.getIsPlaying(p2)

			local v5 = Cryo.List.find(signal2(p2), v4)
			local v6 = v5 ~= nil

			if v6 and not isPlaying then
				v2(function(p3)
					return Cryo.List.removeIndex(p3, v5)
				end)
			elseif isPlaying and not v6 then
				v2(function(p3)
					local v7 = { v4 }
					return Cryo.List.join(p3, v7)
				end)
			end
		end
	end

	createEffect(p, fn) -- inferred equivalent call
	SignalsExperimental.onDisposed(p, Signals.createEffect(function(p2)
		local volume = volumeStore.getVolume(p2)

		for _, v4 in signal(p2) do
			v4.setVolume(volume)
		end
	end))
	SignalsExperimental.onDisposed(p, Signals.createEffect(function(p2)
		local v4 = getLastPlayedAudioStore(p2)

		if v4 and v4.getIsElapsed(p2) and hasNextSong(p2) then
			local nextSong = getNextSong() -- inferred equivalent call

			if nextSong then
				nextSong.play()
			end
		end
	end))
	return {
		getAudioStores = signal,
		stopAll = function()
			for _, v4 in signal(false) do
				v4.stop()
			end
		end,
		pauseAll = function()
			for _, v4 in signal(false) do
				v4.pause()
			end
		end,
		getLastPlayedAudioStore = getLastPlayedAudioStore,
		getOrCreateAudioStore = getOrCreateAudioStore,
		getPlayingAudioStores = signal2,
		destroyAudioStore = function(p2, flag: boolean?)
			destroyByKey(audioStoreKey(p2, flag)) -- inferred equivalent call
		end,
		destroy = function()
			for _, v4 in signal(false) do
				v4.destroy()
			end

			v({})
			v2({})
		end,
		getGlobalVolume = volumeStore.getVolume,
		setGlobalVolume = volumeStore.setVolume,
		mute = volumeStore.mute,
		unmute = volumeStore.unmute,
		getIsMuted = volumeStore.getIsMuted,
		hasNextSong = hasNextSong,
		hasPrevSong = hasPrevSong,
		playNextSong = function()
			local v4 = getLastPlayedAudioStore(false)

			local v5 = v4 and playlistStore.getNext(v4.assetId)

			if v5 then
				local audioStore = getOrCreateAudioStore(v5)

				v4.stop()
				audioStore.play()
			end
		end,
		playPrevSong = function()
			local v4 = getLastPlayedAudioStore(false)

			local v5 = v4 and playlistStore.getPrev(v4.assetId)

			if v5 then
				local audioStore = getOrCreateAudioStore(v5)

				v4.stop()
				audioStore.play()
			end
		end,
		setPlaylist = playlistStore.set
	}
end

return createAudioPlaybackStore
