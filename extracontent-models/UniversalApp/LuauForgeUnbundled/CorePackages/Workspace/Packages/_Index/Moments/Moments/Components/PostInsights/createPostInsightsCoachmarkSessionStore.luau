local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")

local function createPostInsightsCoachmarkSessionStore()
	local signal, v5 = Signals.createSignal(false)

	return {
		getIsHandled = signal,
		markHandled = function()
			v5(true)
		end,
		reset = function()
			v5(false)
		end
	}
end

return createPostInsightsCoachmarkSessionStore
