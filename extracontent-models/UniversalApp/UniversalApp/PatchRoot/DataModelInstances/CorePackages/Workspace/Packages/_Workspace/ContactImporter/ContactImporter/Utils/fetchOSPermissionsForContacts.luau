local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local updateOptedInUsers = dependencies.SocialModalsCommon.Utils.updateOptedInUsers
local PermissionsProtocol = dependencies.PermissionsProtocol
local AppStorageService = dependencies.AppStorageService

return function(p1, p2: ((...any) -> ...any)?) -- line: 10
	-- upvalues: PermissionsProtocol (copy), updateOptedInUsers (copy), AppStorageService (copy)
	p1:hasPermissions({ PermissionsProtocol.Permissions.CONTACTS_ACCESS }):andThen(function(p3) -- line: 13
		-- upvalues: PermissionsProtocol (copy), updateOptedInUsers (copy), AppStorageService (copy), p2 (copy)
		local v9 = p3 and p3.status == PermissionsProtocol.Status.AUTHORIZED

		if not v9 then
			updateOptedInUsers:clearLocalStorage(AppStorageService)
		end

		if p2 then
			p2(v9)
		end
	end):catch(function(_) -- line: 24
		-- upvalues: p2 (copy)
		if p2 then
			p2(false)
		end
	end)
end
