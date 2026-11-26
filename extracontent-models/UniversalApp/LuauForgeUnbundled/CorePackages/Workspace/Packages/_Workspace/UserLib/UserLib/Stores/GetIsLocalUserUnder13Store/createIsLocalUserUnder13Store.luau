require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/Signals")
local createSessionScopedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/SignalsUtils").createSessionScopedSignal

return function()
	local sessionScopedSignal, v5 = createSessionScopedSignal(false)

	return {
		getIsLocalUserUnder13 = sessionScopedSignal,
		setIsLocalUserUnder13 = v5,
		reset = function()
			v5(false)
		end
	}
end
