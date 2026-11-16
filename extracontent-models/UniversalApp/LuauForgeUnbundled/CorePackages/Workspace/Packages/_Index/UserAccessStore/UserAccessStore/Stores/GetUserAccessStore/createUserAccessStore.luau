require("@game/CorePackages/Workspace/Packages/_Workspace/UserAccessStore/Signals")
local createSessionScopedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/UserAccessStore/SignalsUtils").createSessionScopedSignal

return function()
	local sessionScopedSignal, v5 = createSessionScopedSignal(nil)

	return {
		getUserAccessRestrictionDetail = sessionScopedSignal,
		setUserAccessRestrictionDetail = v5,
		reset = function()
			v5(nil)
		end
	}
end
