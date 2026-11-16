local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaPlayback/Cryo")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaPlayback/Signals")
local SignalsExperimental = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaPlayback/SignalsExperimental")

local createConsumerCounterStore = require("@game/CorePackages/Workspace/Packages/_Index/MediaPlayback/MediaPlayback/Stores/getAudioPlaybackStore/createConsumerCounterStore")
local createAudioStore = require("@game/CorePackages/Workspace/Packages/_Index/MediaPlayback/MediaPlayback/Stores/getAudioPlaybackStore/createAudioStore")
local createPlaylistStore = require("@game/CorePackages/Workspace/Packages/_Index/MediaPlayback/MediaPlayback/Stores/getAudioPlaybackStore/createPlaylistStore")
local createVolumeStore = require("@game/CorePackages/Workspace/Packages/_Index/MediaPlayback/MediaPlayback/Stores/getAudioPlaybackStore/createVolumeStore")
require("@game/CorePackages/Workspace/Packages/_Index/MediaPlayback/MediaPlayback/Stores/getAudioPlaybackStore/types")
local getFFlagAudioPreviewLua = require("@game/CorePackages/Workspace/Packages/_Index/MediaPlayback/MediaPlayback/Flags/getFFlagAudioPreviewLua")

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local function createEffect(p2, p3)
	SignalsExperimental.onDisposed(p2, Signals.createEffect(p3))
end

local function audioStoreKey(p2, p3)
	if getFFlagAudioPreviewLua() and p3 then
		return tostring(p2) .. ":preview"
	end

	return (tostring(p2))
end

local function createAudioPlaybackStore(p2)
	local signal, v5 = createSignal({})

	local v6 = createConsumerCounterStore()
	local v7 = createVolumeStore()
	local v8 = createPlaylistStore()

	local function getOrCreateAudioStore(p3, p4)
		local v9 = if getFFlagAudioPreviewLua() and p4 then tostring(p3) .. ":preview" else tostring(p3)

		local audioStore = signal(false)[v9]

		if not audioStore then
			audioStore = createAudioStore(p3, p4)

			v5(function(p5)
				return Cryo.Dictionary.join(p5, { [v9] = audioStore })
			end)
		end

		v6.subscribe(v9)

		return audioStore
	end

	local signal2, v9 = createSignal({})

	local v10 = nil
	local computed = createComputed(function(p3)
		local v11 = signal2(p3)
		local v12 = v11[#v11]

		if v12 then
			v10 = v12
		end

		return v10
	end)

	local function getNextSong()
		local v11 = computed(false)

		local v12 = v11 and v8.getNext(v11.assetId)

		if v12 then
			return getOrCreateAudioStore(v12)
		end

		return nil
	end

	local computed2 = createComputed(function(p3): boolean
		local v11 = computed(p3)

		if v11 then
			return v8.getNext(v11.assetId) ~= nil
		end

		return false
	end)

	local computed3 = createComputed(function(p3): boolean
		local v11 = computed(p3)

		if v11 then
			return v8.getPrev(v11.assetId) ~= nil
		end

		return false
	end)

	local function destroyByKey(k)
		local v11 = signal(false)[k]

		if v11 then
			if v6.unsubscribe(k) > 0 then
				return
			end

			v11.destroy()

			v5(function(p3)
				return Cryo.Dictionary.join(p3, { [k] = Cryo.None })
			end)
		end
	end

	SignalsExperimental.onDisposed(p2, Signals.createEffect(function(p3)
		for k, v11 in v6.getConsumerCounts(p3) do
			if v11 <= 0 then
				destroyByKey(k)
			end
		end
	end))
	SignalsExperimental.onDisposed(p2, Signals.createEffect(function(p3)
		for k, v11 in signal(p3) do
			if v11.getIsDestroyed(p3) then
				destroyByKey(k)
			end
		end
	end))

	local function fn(p3)
		for k, v11 in signal(p3) do
			local isPlaying = v11.getIsPlaying(p3)

			local v12 = Cryo.List.find(signal2(p3), v11)
			local v13 = v12 ~= nil

			if v13 and not isPlaying then
				v9(function(p4)
					return Cryo.List.removeIndex(p4, v12)
				end)
			elseif isPlaying and not v13 then
				v9(function(p4)
					return Cryo.List.join(p4, { v11 })
				end)
			end
		end
	end

	SignalsExperimental.onDisposed(p2, Signals.createEffect(fn))
	SignalsExperimental.onDisposed(p2, Signals.createEffect(function(p3)
		local volume = v7.getVolume(p3)

		for k, v11 in signal(p3) do
			v11.setVolume(volume)
		end
	end))
	SignalsExperimental.onDisposed(p2, Signals.createEffect(function(p3)
		local v11 = computed(p3)

		if v11 and v11.getIsElapsed(p3) and computed2(p3) then
			local v12 = computed(false)

			local v13 = v12 and v8.getNext(v12.assetId)

			local v14 = if v13 then getOrCreateAudioStore(v13) else nil

			if v14 then
				v14.play()
			end
		end
	end))
	return {
		getAudioStores = signal,
		stopAll = function()
			for k, v11 in signal(false) do
				v11.stop()
			end
		end,
		pauseAll = function()
			for k, v11 in signal(false) do
				v11.pause()
			end
		end,
		getLastPlayedAudioStore = computed,
		getOrCreateAudioStore = getOrCreateAudioStore,
		getPlayingAudioStores = signal2,
		destroyAudioStore = function(p3, p4)
			local v12 = if getFFlagAudioPreviewLua() and p4 then tostring(p3) .. ":preview" else tostring(p3)

			destroyByKey(v12)
		end,
		destroy = function()
			for k, v11 in signal(false) do
				v11.destroy()
			end

			v5({})
			v9({})
		end,
		getGlobalVolume = v7.getVolume,
		setGlobalVolume = v7.setVolume,
		mute = v7.mute,
		unmute = v7.unmute,
		getIsMuted = v7.getIsMuted,
		hasNextSong = computed2,
		hasPrevSong = computed3,
		playNextSong = function()
			local v11 = computed(false)

			local v12 = v11 and v8.getNext(v11.assetId)

			if v12 then
				local audioStore = getOrCreateAudioStore(v12)

				v11.stop()
				audioStore.play()
			end
		end,
		playPrevSong = function()
			local v11 = computed(false)

			local v12 = v11 and v8.getPrev(v11.assetId)

			if v12 then
				local audioStore = getOrCreateAudioStore(v12)

				v11.stop()
				audioStore.play()
			end
		end,
		setPlaylist = v8.set
	}
end

return createAudioPlaybackStore
