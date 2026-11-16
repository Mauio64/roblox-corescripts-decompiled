local networkingContacts = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies").NetworkingContacts
local contactImporterSync = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Utils/contactImporterSync")
local formatContacts = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Utils/formatContacts")
local UploadContactsSources = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Analytics/Enums/UploadContactsSources")
local permissionsProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/PermissionsProtocol").PermissionsProtocol

local default = permissionsProtocol.default
local v5 = { permissionsProtocol.Permissions.CONTACTS_ACCESS }

return function(p2, object, p3, p4)
	return function(object2)
		default:hasPermissions(v5):andThen(function(p5)
			if p5 and p5.status == permissionsProtocol.Status.AUTHORIZED then
				local unixTimestampMillis = DateTime.now().UnixTimestampMillis

				local shouldSyncContacts = contactImporterSync:shouldSyncContacts(p3, p2, unixTimestampMillis)

				if p4 or shouldSyncContacts then
					return object:getContacts():andThen(function(p6)
						local v6 = formatContacts(p6)
						v6.source = UploadContactsSources.AutoSync
						return object2:dispatch(networkingContacts.UploadContactsByUser.API(v6))
					end):andThen(function()
						return contactImporterSync:updateSyncTimestamp(p3, p2, unixTimestampMillis)
					end):catch(function() end)
				end
			end
		end):catch(function() end)
	end
end
