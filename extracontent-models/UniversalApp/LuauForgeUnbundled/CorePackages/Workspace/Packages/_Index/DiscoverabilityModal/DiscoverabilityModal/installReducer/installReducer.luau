local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/dependencies")

local rodux = dependencies.Rodux
local roduxNetworking = dependencies.RoduxNetworking
local roduxUserPermissions = dependencies.RoduxUserPermissions

return function()
	return rodux.combineReducers({
		UserPermissions = roduxUserPermissions.installReducer(),
		NetworkStatus = roduxNetworking.installReducer()
	})
end
