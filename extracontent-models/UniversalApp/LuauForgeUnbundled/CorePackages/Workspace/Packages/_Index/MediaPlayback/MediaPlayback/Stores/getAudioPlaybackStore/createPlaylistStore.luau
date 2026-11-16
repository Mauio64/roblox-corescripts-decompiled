local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaPlayback/Signals")

require("@game/CorePackages/Workspace/Packages/_Index/MediaPlayback/MediaPlayback/Stores/getAudioPlaybackStore/types")

local createSignal = Signals.createSignal

local function createPlaylistStore()
	local signal, v5 = createSignal({})
	local signal2, v6 = createSignal({})

	local function getRelativeIndex(p2, p3)
		local v7 = signal2(false)[tostring(p2)]

		if v7 then
			return signal(false)[v7 + p3]
		end

		return nil
	end

	return {
		get = signal,
		set = function(items)
			v5(items)

			local v7 = {}

			for k, item in items do
				v7[tostring(item)] = k
			end

			v6(v7)
		end,
		getNext = function(p2)
			local v7 = signal2(false)[tostring(p2)]

			if v7 then
				return signal(false)[v7 + 1]
			end

			return nil
		end,
		getPrev = function(p2)
			local v7 = signal2(false)[tostring(p2)]

			if v7 then
				return signal(false)[v7 + -1]
			end

			return nil
		end
	}
end

return createPlaylistStore
