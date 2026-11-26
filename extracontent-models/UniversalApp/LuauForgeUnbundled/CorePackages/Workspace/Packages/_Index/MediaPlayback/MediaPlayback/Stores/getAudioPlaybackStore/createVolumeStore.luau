local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaPlayback/Signals")

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local function createVolumeStore()
	local signal, v5 = createSignal(1)
	local signal2, v6 = createSignal(signal(false))

	local computed = createComputed(function(p2): boolean
		return signal(p2) <= 0
	end)

	local function setClampedVolume(value)
		v5((math.clamp(value, 0, 1)))
	end

	return {
		getVolume = signal,
		setVolume = setClampedVolume,
		getIsMuted = computed,
		mute = function()
			if not computed(false) then
				v6(signal(false))
				v5(0)
			end
		end,
		unmute = function()
			if computed(false) then
				v5(signal2(false))
			end
		end
	}
end

return createVolumeStore
