local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local Rodux = dependencies.Rodux
local RoduxNetworking = dependencies.RoduxNetworking
local Contacts = require(script.Parent.Contacts)
local ShowContactImporterParams = require(script.Parent.ShowContactImporterParams)
local RoduxUserPermissions = dependencies.RoduxUserPermissions

return function() -- line: 11
	-- upvalues: Rodux (copy), Contacts (copy), RoduxUserPermissions (copy), RoduxNetworking (copy), ShowContactImporterParams (copy)
	return Rodux.combineReducers({
		Contacts = Contacts,
		UserPermissions = RoduxUserPermissions.installReducer(),
		NetworkStatus = RoduxNetworking.installReducer(),
		ShowContactImporterParams = ShowContactImporterParams
	})
end
