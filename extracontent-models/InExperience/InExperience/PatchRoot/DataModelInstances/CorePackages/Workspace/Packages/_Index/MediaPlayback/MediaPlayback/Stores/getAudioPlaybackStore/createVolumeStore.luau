local MediaPlayback = script:FindFirstAncestor("MediaPlayback")
local Signals = require(MediaPlayback.Parent.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local function createVolumeStore() -- line: 16
	-- upvalues: createSignal (copy), createComputed (copy)
	local v6, v7 = createSignal(1)
	local v8, v9 = createSignal(v6(false))
	local v10 = createComputed(function(p1) -- line: 20
		-- upvalues: v6 (copy)
		return v6(p1) <= 0
	end)

	local function setClampedVolume(n1: number) -- line: 24
		-- upvalues: v7 (copy)
		v7((math.clamp(n1, 0, 1)))
	end

	return {
		getVolume = v6,
		setVolume = setClampedVolume,
		getIsMuted = v10,
		mute = function() -- line: 28
			-- upvalues: v10 (copy), v9 (copy), v6 (copy), v7 (copy)
			if not v10(false) then
				v9(v6(false))
				v7(0)
			end
		end,
		unmute = function() -- line: 35
			-- upvalues: v10 (copy), v7 (copy), v8 (copy)
			if v10(false) then
				v7(v8(false))
			end
		end
	}
end

return createVolumeStore
