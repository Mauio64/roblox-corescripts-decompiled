local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/Constants")
local engineFeature = game:GetEngineFeature(Constants.UNIVERSAL_APP_CONTACT_IMPORTER_STORAGE_KEYS)

return {
	getLastOSPermissionSettings = function(self, object): boolean
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
	end,
	updateOSPermissionSettings = function(self, object, p3)
		if not engineFeature then
			return
		end

		pcall(function()
			object:SetItem(Constants.LOCAL_STORAGE_KEY_LAST_CONTACTS_OS_PERMISSIONS, (tostring(p3)))
			object:Flush()
		end)
	end
}
