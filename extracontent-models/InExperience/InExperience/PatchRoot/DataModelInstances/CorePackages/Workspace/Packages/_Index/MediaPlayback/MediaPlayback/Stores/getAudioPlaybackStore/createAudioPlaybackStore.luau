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

local function createEffect(p1, p2: ((...any) -> ...any)) -- line: 17
	-- upvalues: SignalsExperimental (copy), Signals (copy)
	SignalsExperimental.onDisposed(p1, Signals.createEffect(p2))
end
local function audioStoreKey(p3, b1: boolean?) -- line: 21
	-- upvalues: getFFlagAudioPreviewLua (copy)
	if getFFlagAudioPreviewLua() and b1 then
		return tostring(p3) .. ":preview"
	end

	return (tostring(p3))
end
local function createAudioPlaybackStore(p4) -- line: 28
	-- upvalues: createSignal (copy), createConsumerCounterStore (copy), createVolumeStore (copy), createPlaylistStore (copy), getFFlagAudioPreviewLua (copy), createAudioStore (copy), Cryo (copy), createComputed (copy), SignalsExperimental (copy), Signals (copy)
	local v20, v21 = createSignal({})
	local v22 = createConsumerCounterStore()
	local v23 = createVolumeStore()
	local v24 = createPlaylistStore()

	local function getOrCreateAudioStore(p5, b2: boolean?) -- line: 36
		-- upvalues: getFFlagAudioPreviewLua (copy), v20 (copy), createAudioStore (copy), v21 (copy), Cryo (copy), v22 (copy)
		local v36 = if not getFFlagAudioPreviewLua() or not b2 then tostring(p5) else tostring(p5) .. ":preview"
		local u37 = v20(false)[v36]

		if not u37 then
			u37 = createAudioStore(p5, b2)
			v21(function(p6) -- line: 43
				-- upvalues: Cryo (copy), v36 (copy), u37 (ref)
				return Cryo.Dictionary.join(p6, {
					[v36] = u37
				})
			end)
		end

		v22.subscribe(v36)

		return u37
	end

	local v26, v27 = createSignal({})
	local u28 = nil
	local v29 = createComputed(function(p7) -- line: 58
		-- upvalues: v26 (copy), u28 (ref)
		local v39 = v26(p7)
		local v40 = v39[#v39]

		if v40 then
			u28 = v40
		end

		return u28
	end)

	local function getNextSong() -- line: 69
		-- upvalues: v29 (copy), v24 (copy), getOrCreateAudioStore (copy)
		local v41 = v29(false)

		if v41 then
			local v42 = v24.getNext(v41.assetId)

			if v42 then
				return (getOrCreateAudioStore(v42))
			end
		end

		return nil
	end

	local v31 = createComputed(function(p8) -- line: 81
		-- upvalues: v29 (copy), v24 (copy)
		local v44 = v29(p8)

		if v44 then
			return v24.getNext(v44.assetId) ~= nil
		end

		return false
	end)
	local v32 = createComputed(function(p9) -- line: 89
		-- upvalues: v29 (copy), v24 (copy)
		local v46 = v29(p9)

		if v46 then
			return v24.getPrev(v46.assetId) ~= nil
		end

		return false
	end)

	local function destroyByKey(s1: string) -- line: 137
		-- upvalues: v20 (copy), v22 (copy), v21 (copy), Cryo (copy)
		local v58 = v20(false)[s1]

		if v58 then
			if v22.unsubscribe(s1) > 0 then
				return
			end

			v58.destroy()
			v21(function(p10) -- line: 149
				-- upvalues: Cryo (copy), s1 (copy)
				return Cryo.Dictionary.join(p10, {
					[s1] = Cryo.None
				})
			end)
		end
	end

	SignalsExperimental.onDisposed(p4, Signals.createEffect(function(p11) -- line: 169
		-- upvalues: v22 (copy), destroyByKey (copy)
		for v64, v65 in v22.getConsumerCounts(p11) do
			if v65 <= 0 then
				destroyByKey(v64)
			end
		end
	end))
	SignalsExperimental.onDisposed(p4, Signals.createEffect(function(p12) -- line: 179
		-- upvalues: v20 (copy), destroyByKey (copy)
		for v67, v68 in v20(p12) do
			if v68.getIsDestroyed(p12) then
				destroyByKey(v67)
			end
		end
	end))
	SignalsExperimental.onDisposed(p4, Signals.createEffect(function(p13) -- line: 187
		-- upvalues: v20 (copy), Cryo (copy), v26 (copy), v27 (copy)
		for _, v71 in v20(p13) do
			local v72 = v71.getIsPlaying(p13)
			local v73 = Cryo.List.find(v26(p13), v71)
			local v74 = v73 ~= nil

			if v74 and not v72 then
				v27(function(p14) -- line: 195
					-- upvalues: Cryo (copy), v73 (copy)
					return Cryo.List.removeIndex(p14, v73)
				end)
			elseif v72 and not v74 then
				v27(function(p15) -- line: 199
					-- upvalues: Cryo (copy), v71 (copy)
					return Cryo.List.join(p15, { v71 })
				end)
			end
		end
	end))
	SignalsExperimental.onDisposed(p4, Signals.createEffect(function(p16) -- line: 206
		-- upvalues: v23 (copy), v20 (copy)
		local v76 = v23.getVolume(p16)

		for _, v78 in v20(p16) do
			v78.setVolume(v76)
		end
	end))
	SignalsExperimental.onDisposed(p4, Signals.createEffect(function(p17) -- line: 213
		-- upvalues: v29 (copy), v31 (copy), v24 (copy), getOrCreateAudioStore (copy)
		local v80 = v29(p17)

		if not v80 or (not v80.getIsElapsed(p17) or not v31(p17)) then
			return
		end

		local v81 = v29(false)
		local g82 = nil
		local v83 = nil
		local v84 = nil

		repeat
			if g82 or v81 then
				if not g82 then
					v83 = v24.getNext(v81.assetId)
				end

				if g82 or v83 then
					if not g82 then
						v84 = getOrCreateAudioStore(v83)
					end

					g82 = false

					if v84 then
						v84.play()
					end

					return
				end
			end

			v84 = nil
			g82 = true
		until not g82
	end))

	return {
		getAudioStores = v20,
		stopAll = function() -- line: 97
			-- upvalues: v20 (copy)
			for _, v48 in v20(false) do
				v48.stop()
			end
		end,
		pauseAll = function() -- line: 103
			-- upvalues: v20 (copy)
			for _, v50 in v20(false) do
				v50.pause()
			end
		end,
		getLastPlayedAudioStore = v29,
		getOrCreateAudioStore = getOrCreateAudioStore,
		getPlayingAudioStores = v26,
		destroyAudioStore = function(p18, b3: boolean?) -- line: 157
			-- upvalues: destroyByKey (copy), getFFlagAudioPreviewLua (copy)
			destroyByKey(if not getFFlagAudioPreviewLua() or not b3 then tostring(p18) else tostring(p18) .. ":preview")
		end,
		destroy = function() -- line: 161
			-- upvalues: v20 (copy), v21 (copy), v27 (copy)
			for _, v62 in v20(false) do
				v62.destroy()
			end

			v21({})
			v27({})
		end,
		getGlobalVolume = v23.getVolume,
		setGlobalVolume = v23.setVolume,
		mute = v23.mute,
		unmute = v23.unmute,
		getIsMuted = v23.getIsMuted,
		hasNextSong = v31,
		hasPrevSong = v32,
		playNextSong = function() -- line: 109
			-- upvalues: v29 (copy), v24 (copy), getOrCreateAudioStore (copy)
			local v51 = v29(false)

			if v51 then
				local v52 = v24.getNext(v51.assetId)

				if v52 then
					local v53 = getOrCreateAudioStore(v52)

					v51.stop()
					v53.play()
				end
			end
		end,
		playPrevSong = function() -- line: 123
			-- upvalues: v29 (copy), v24 (copy), getOrCreateAudioStore (copy)
			local v54 = v29(false)

			if v54 then
				local v55 = v24.getPrev(v54.assetId)

				if v55 then
					local v56 = getOrCreateAudioStore(v55)

					v54.stop()
					v56.play()
				end
			end
		end,
		setPlaylist = v24.set
	}
end

return createAudioPlaybackStore
