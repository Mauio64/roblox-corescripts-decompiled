local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/IsLocalUserSoothsayerStore/Signals")
local SignalsUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/IsLocalUserSoothsayerStore/SignalsUtils")

return Signals.createComputed(function()
	local sessionScopedSignal, v5 = SignalsUtils.createSessionScopedSignal(false)

	return {
		getIsLocalUserSoothsayer = sessionScopedSignal,
		setIsLocalUserSoothsayer = function(p2)
			v5(p2)
		end,
		reset = function()
			v5(false)
		end
	}
end)
