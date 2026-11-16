local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)

local rodux = dependencies.Rodux
local roduxNetworking = dependencies.RoduxNetworking
local roduxUserPermissions = dependencies.RoduxUserPermissions

return function()
	return rodux.combineReducers({
		UserPermissions = roduxUserPermissions.installReducer(),
		NetworkStatus = roduxNetworking.installReducer()
	})
end
