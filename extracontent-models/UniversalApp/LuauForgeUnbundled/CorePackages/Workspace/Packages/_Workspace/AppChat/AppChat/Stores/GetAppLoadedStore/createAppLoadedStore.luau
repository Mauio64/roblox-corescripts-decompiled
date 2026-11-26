require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local createSessionScopedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsUtils").createSessionScopedSignal

local function createAppLoadedStore()
	local sessionScopedSignal, v5 = createSessionScopedSignal(false)

	return {
		getAppLoaded = sessionScopedSignal,
		setAppLoaded = function(p2)
			v5(p2)
		end
	}
end

return createAppLoadedStore
