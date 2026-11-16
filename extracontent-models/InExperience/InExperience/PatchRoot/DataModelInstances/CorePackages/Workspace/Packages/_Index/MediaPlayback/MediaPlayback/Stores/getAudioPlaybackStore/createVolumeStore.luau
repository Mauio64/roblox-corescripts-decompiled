local MediaPlayback = script:FindFirstAncestor("MediaPlayback")

local Signals = require(MediaPlayback.Parent.Signals)

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local function createVolumeStore()
	local signal, v = createSignal(1)
	local signal2, v2 = createSignal(signal(false))

	local getIsMuted = createComputed(function(p): boolean
		return signal(p) <= 0
	end)

	local function setClampedVolume(value: number)
		v((math.clamp(value, 0, 1)))
	end

	return {
		getVolume = signal,
		setVolume = setClampedVolume,
		getIsMuted = getIsMuted,
		mute = function()
			if not getIsMuted(false) then
				v2(signal(false))
				v(0)
			end
		end,
		unmute = function()
			if getIsMuted(false) then
				v(signal2(false))
			end
		end
	}
end

return createVolumeStore
