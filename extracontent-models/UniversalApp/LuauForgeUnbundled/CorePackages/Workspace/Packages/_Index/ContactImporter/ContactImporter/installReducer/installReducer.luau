local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies")

local rodux = dependencies.Rodux
local roduxNetworking = dependencies.RoduxNetworking

local module2 = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/installReducer/Contacts")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/installReducer/ShowContactImporterParams")
local roduxUserPermissions = dependencies.RoduxUserPermissions

return function()
	return rodux.combineReducers({
		Contacts = module2,
		UserPermissions = roduxUserPermissions.installReducer(),
		NetworkStatus = roduxNetworking.installReducer(),
		ShowContactImporterParams = module3
	})
end
