require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Signals")
local createSessionScopedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SignalsUtils").createSessionScopedSignal
require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Common/Types")

return function()
	local sessionScopedSignal, v5 = createSessionScopedSignal({})

	return {
		getCountryCodeList = sessionScopedSignal,
		setCountryCodeList = function(p2)
			v5(p2)
		end,
		reset = function()
			v5({})
		end
	}
end
