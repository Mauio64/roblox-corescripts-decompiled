local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies")
local updateOptedInUsers = dependencies.SocialModalsCommon.Utils.updateOptedInUsers
local permissionsProtocol = dependencies.PermissionsProtocol
local appStorageService = dependencies.AppStorageService

return function(object, callback)
	object:hasPermissions({ permissionsProtocol.Permissions.CONTACTS_ACCESS }):andThen(function(p2)
		local v5 = p2 and p2.status == permissionsProtocol.Status.AUTHORIZED

		if not v5 then
			updateOptedInUsers:clearLocalStorage(appStorageService)
		end

		if callback then
			callback(v5)
		end
	end):catch(function(p2)
		if callback then
			callback(false)
		end
	end)
end
