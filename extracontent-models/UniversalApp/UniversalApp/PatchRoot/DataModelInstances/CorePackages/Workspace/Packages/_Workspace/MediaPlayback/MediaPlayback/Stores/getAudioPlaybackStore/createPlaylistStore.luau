local MediaPlayback = script:FindFirstAncestor("MediaPlayback")
local Signals = require(MediaPlayback.Parent.Signals)

require(MediaPlayback.Stores.getAudioPlaybackStore.types)

local createSignal = Signals.createSignal

local function createPlaylistStore() -- line: 9
	-- upvalues: createSignal (copy)
	local v5, v6 = createSignal({})
	local v7, v8 = createSignal({})

	local function getRelativeIndex(p1, n1: number) -- line: 13
		-- upvalues: v7 (copy), v5 (copy)
		local v12 = v7(false)[tostring(p1)]

		if v12 then
			return v5(false)[v12 + n1]
		end

		return nil
	end

	return {
		get = v5,
		set = function(t1: {[any]: any}) -- line: 22
			-- upvalues: v6 (copy), v8 (copy)
			v6(t1)

			local t2 = {}

			for v15, v16 in t1 do
				t2[tostring(v16)] = v15
			end

			v8(t2)
		end,
		getNext = function(p2) -- line: 32
			-- upvalues: v7 (copy), v5 (copy)
			local v18 = v7(false)[tostring(p2)]

			if v18 then
				return v5(false)[v18 + 1]
			end

			return nil
		end,
		getPrev = function(p3) -- line: 36
			-- upvalues: v7 (copy), v5 (copy)
			local v20 = v7(false)[tostring(p3)]

			if v20 then
				return v5(false)[v20 + -1]
			end

			return nil
		end
	}
end

return createPlaylistStore
