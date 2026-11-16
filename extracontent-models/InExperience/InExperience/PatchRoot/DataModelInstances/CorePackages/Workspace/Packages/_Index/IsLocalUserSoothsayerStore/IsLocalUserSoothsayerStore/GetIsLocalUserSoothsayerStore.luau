local parent = script:FindFirstAncestor("IsLocalUserSoothsayerStore").Parent

local Signals = require(parent.Signals)
local SignalsUtils = require(parent.SignalsUtils)

return Signals.createComputed(function()
	local sessionScopedSignal, v = SignalsUtils.createSessionScopedSignal(false)

	return {
		getIsLocalUserSoothsayer = sessionScopedSignal,
		setIsLocalUserSoothsayer = function(flag: boolean)
			v(flag)
		end,
		reset = function()
			v(false)
		end
	}
end)
