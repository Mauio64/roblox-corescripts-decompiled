local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local NetworkingContacts = require(ParentParent.dependencies).NetworkingContacts
local contactImporterSync = require(ParentParent.Utils.contactImporterSync)
local formatContacts = require(ParentParent.Utils.formatContacts)
local UploadContactsSources = require(ParentParent.Analytics.Enums.UploadContactsSources)
local PermissionsProtocol = require(ParentParentParent.PermissionsProtocol).PermissionsProtocol
local default = PermissionsProtocol.default
local t1 = { PermissionsProtocol.Permissions.CONTACTS_ACCESS }

return function(s1: string, p1, p2, b1: boolean?) -- line: 14
	-- upvalues: default (copy), t1 (copy), PermissionsProtocol (copy), contactImporterSync (copy), formatContacts (copy), UploadContactsSources (copy), NetworkingContacts (copy)
	return function(p3) -- line: 15
		-- upvalues: default (copy), t1 (copy), PermissionsProtocol (copy), contactImporterSync (copy), p2 (copy), s1 (copy), b1 (copy), p1 (copy), formatContacts (copy), UploadContactsSources (copy), NetworkingContacts (copy)
		default:hasPermissions(t1):andThen(function(p4) -- line: 18
			-- upvalues: PermissionsProtocol (copy), contactImporterSync (copy), p2 (copy), s1 (copy), b1 (copy), p1 (copy), formatContacts (copy), UploadContactsSources (copy), p3 (copy), NetworkingContacts (copy)
			if p4 and p4.status == PermissionsProtocol.Status.AUTHORIZED then
				local UnixTimestampMillis = DateTime.now().UnixTimestampMillis
				local v17 = contactImporterSync:shouldSyncContacts(p2, s1, UnixTimestampMillis)

				if b1 or v17 then
					return p1:getContacts():andThen(function(p5) -- line: 27
						-- upvalues: formatContacts (copy), UploadContactsSources (copy), p3 (copy), NetworkingContacts (copy)
						local v19 = formatContacts(p5)

						v19.source = UploadContactsSources.AutoSync

						return p3:dispatch(NetworkingContacts.UploadContactsByUser.API(v19))
					end):andThen(function() -- line: 32
						-- upvalues: contactImporterSync (copy), p2 (copy), s1 (copy), UnixTimestampMillis (copy)
						return contactImporterSync:updateSyncTimestamp(p2, s1, UnixTimestampMillis)
					end):catch(function() -- line: 35
					end)
				end
			end
		end):catch(function() -- line: 39
		end)
	end
end
