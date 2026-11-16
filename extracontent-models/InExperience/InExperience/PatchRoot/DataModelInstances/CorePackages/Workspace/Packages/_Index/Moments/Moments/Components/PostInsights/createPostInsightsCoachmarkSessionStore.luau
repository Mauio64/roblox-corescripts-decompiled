local parent = script:FindFirstAncestor("Moments").Parent

local Signals = require(parent.Signals)

local function createPostInsightsCoachmarkSessionStore()
	local signal, v = Signals.createSignal(false)

	return {
		getIsHandled = signal,
		markHandled = function()
			v(true)
		end,
		reset = function()
			v(false)
		end
	}
end

return createPostInsightsCoachmarkSessionStore
