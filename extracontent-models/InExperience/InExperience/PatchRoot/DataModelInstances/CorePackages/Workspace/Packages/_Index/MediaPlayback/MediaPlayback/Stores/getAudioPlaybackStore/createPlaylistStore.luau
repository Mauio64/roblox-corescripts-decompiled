local MediaPlayback = script:FindFirstAncestor("MediaPlayback")

local Signals = require(MediaPlayback.Parent.Signals)

require(MediaPlayback.Stores.getAudioPlaybackStore.types)

local createSignal = Signals.createSignal

local function createPlaylistStore()
	local signal, v = createSignal({})
	local signal2, v2 = createSignal({})

	local function getRelativeIndex(p, p2: number) -- 2 equivalent calls inferred from this helper
		local v3 = signal2(false)[tostring(p)]

		if v3 then
			return signal(false)[v3 + p2]
		end

		return nil
	end

	return {
		get = signal,
		set = function(items)
			v(items)

			local v3 = {}

			for k, item in items do
				v3[tostring(item)] = k
			end

			v2(v3)
		end,
		getNext = function(p)
			return getRelativeIndex(p, 1) -- inferred equivalent call
		end,
		getPrev = function(p)
			return getRelativeIndex(p, -1) -- inferred equivalent call
		end
	}
end

return createPlaylistStore
