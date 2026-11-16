local parent = script:FindFirstAncestor("SocialCarousel").Parent

local Signals = require(parent.Signals)

local createSignal = Signals.createSignal

local function createMarqueeSessionStore()
	local signal, v = createSignal({})
	local signal2, v2 = createSignal(0)

	return {
		getLoopsRemaining = signal,
		getHomeFocusVersion = signal2,
		notifyHomeFocused = function()
			v2(signal2(false) + 1)
		end,
		reset = function()
			v({})
		end
	}
end

return createMarqueeSessionStore
