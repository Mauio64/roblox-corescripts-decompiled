local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Rodux")

local SetAppLoaded = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Actions/SetAppLoaded")

return Rodux.createReducer(false, {
	[SetAppLoaded.name] = function(p2, p3)
		return p3.value
	end
})
