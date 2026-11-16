local createSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Signals").createSignal

local function createMarqueeSessionStore()
	local signal, v5 = createSignal({})
	local signal2, v6 = createSignal(0)

	return {
		getLoopsRemaining = signal,
		getHomeFocusVersion = signal2,
		notifyHomeFocused = function()
			v6(signal2(false) + 1)
		end,
		reset = function()
			v5({})
		end
	}
end

return createMarqueeSessionStore
