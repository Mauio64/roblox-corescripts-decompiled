require("@luauforge/bundled/ftL")
local module = require("@luauforge/bundled/ftN")
local module2 = require("@luauforge/bundled/ftO")

return function()
	local sessionScopedSignal, v5 = module2.createSessionScopedSignal(false)
	local sessionScopedSignal2, v6 = module2.createSessionScopedSignal(false)
	local sessionScopedSignal3, v7 = module2.createSessionScopedSignal(false)

	local function reset()
		module.batch(function()
			v5(false)
			v6(false)
			v7(false)
		end)
	end

	return {
		getShowBuyRobuxButtonBadge = sessionScopedSignal,
		getBuyRobuxButtonClicked = sessionScopedSignal2,
		getHasFetchedRobuxBadge = sessionScopedSignal3,
		setShowBuyRobuxButtonBadge = v5,
		setBuyRobuxButtonClicked = v6,
		setHasFetchedRobuxBadge = v7,
		reset = reset
	}
end
