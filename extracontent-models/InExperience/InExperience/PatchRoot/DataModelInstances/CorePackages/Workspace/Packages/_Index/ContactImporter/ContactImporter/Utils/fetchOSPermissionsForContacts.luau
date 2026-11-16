local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)
local updateOptedInUsers = dependencies.SocialModalsCommon.Utils.updateOptedInUsers
local permissionsProtocol = dependencies.PermissionsProtocol
local appStorageService = dependencies.AppStorageService

return function(object, callback)
	object:hasPermissions({ permissionsProtocol.Permissions.CONTACTS_ACCESS }):andThen(function(p)
		local v = p and p.status == permissionsProtocol.Status.AUTHORIZED

		if not v then
			updateOptedInUsers:clearLocalStorage(appStorageService)
		end

		if callback then
			callback(v)
		end
	end):catch(function(_)
		if callback then
			callback(false)
		end
	end)
end
