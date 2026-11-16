local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)

local rodux = dependencies.Rodux
local roduxNetworking = dependencies.RoduxNetworking

local Contacts = require(script.Parent.Contacts)
local ShowContactImporterParams = require(script.Parent.ShowContactImporterParams)
local roduxUserPermissions = dependencies.RoduxUserPermissions

return function()
	return rodux.combineReducers({
		Contacts = Contacts,
		UserPermissions = roduxUserPermissions.installReducer(),
		NetworkStatus = roduxNetworking.installReducer(),
		ShowContactImporterParams = ShowContactImporterParams
	})
end
