local parent = script.Parent.Parent
local parent2 = parent.Parent
local dependencies = require(parent.dependencies)

local networkingContacts = dependencies.NetworkingContacts
local contactImporterSync = require(parent.Utils.contactImporterSync)
local formatContacts = require(parent.Utils.formatContacts)
local UploadContactsSources = require(parent.Analytics.Enums.UploadContactsSources)
local PermissionsProtocol = require(parent2.PermissionsProtocol)
local permissionsProtocol = PermissionsProtocol.PermissionsProtocol

local default = permissionsProtocol.default
local v = { permissionsProtocol.Permissions.CONTACTS_ACCESS }

return function(p: string, object, p2, flag: boolean?)
	return function(object2)
		default:hasPermissions(v):andThen(function(p3)
			if p3 and p3.status == permissionsProtocol.Status.AUTHORIZED then
				local unixTimestampMillis = DateTime.now().UnixTimestampMillis

				local shouldSyncContacts = contactImporterSync:shouldSyncContacts(p2, p, unixTimestampMillis)

				if flag or shouldSyncContacts then
					return object:getContacts():andThen(function(p4)
						local v2 = formatContacts(p4)
						v2.source = UploadContactsSources.AutoSync
						return object2:dispatch(networkingContacts.UploadContactsByUser.API(v2))
					end):andThen(function()
						return contactImporterSync:updateSyncTimestamp(p2, p, unixTimestampMillis)
					end):catch(function() end)
				end
			end
		end):catch(function() end)
	end
end
