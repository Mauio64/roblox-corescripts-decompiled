local Constants = require(script.Parent.Parent.Parent.ContactImporter.Common.Constants)
local engineFeature = game:GetEngineFeature(Constants.UNIVERSAL_APP_CONTACT_IMPORTER_STORAGE_KEYS)
local ContactImporterOSPermissions = {}

function ContactImporterOSPermissions.getLastOSPermissionSettings(_, object): boolean
	if not engineFeature then
		return true
	end

	local success, result = pcall(function()
		return object:GetItem(Constants.LOCAL_STORAGE_KEY_LAST_CONTACTS_OS_PERMISSIONS)
	end)

	if success then
		return result == "true"
	end

	return false
end

function ContactImporterOSPermissions.updateOSPermissionSettings(_, object, p)
	if not engineFeature then
		return
	end

	pcall(function()
		object:SetItem(Constants.LOCAL_STORAGE_KEY_LAST_CONTACTS_OS_PERMISSIONS, (tostring(p)))
		object:Flush()
	end)
end

return ContactImporterOSPermissions
