local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local Rodux = dependencies.Rodux
local RoduxNetworking = dependencies.RoduxNetworking
local RoduxUserPermissions = dependencies.RoduxUserPermissions

return function() -- line: 8
	-- upvalues: Rodux (copy), RoduxUserPermissions (copy), RoduxNetworking (copy)
	return Rodux.combineReducers({
		UserPermissions = RoduxUserPermissions.installReducer(),
		NetworkStatus = RoduxNetworking.installReducer()
	})
end
