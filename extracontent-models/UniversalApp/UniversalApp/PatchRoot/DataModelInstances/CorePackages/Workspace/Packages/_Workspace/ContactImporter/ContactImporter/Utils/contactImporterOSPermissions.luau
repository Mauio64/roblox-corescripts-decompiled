local Constants = require(script.Parent.Parent.Parent.ContactImporter.Common.Constants)
local EngineFeature = game:GetEngineFeature(Constants.UNIVERSAL_APP_CONTACT_IMPORTER_STORAGE_KEYS)

return {
	getLastOSPermissionSettings = function(_, p2) -- line: 8
		-- upvalues: EngineFeature (copy), Constants (copy)
		if not EngineFeature then
			return true
		end

		local ok, result = pcall(function() -- line: 14
			-- upvalues: p2 (copy), Constants (copy)
			return p2:GetItem(Constants.LOCAL_STORAGE_KEY_LAST_CONTACTS_OS_PERMISSIONS)
		end)

		if ok then
			return result == "true"
		end

		return false
	end,
	updateOSPermissionSettings = function(_, p4, p5) -- line: 25
		-- upvalues: EngineFeature (copy), Constants (copy)
		if not EngineFeature then
			return
		end

		pcall(function() -- line: 30
			-- upvalues: p4 (copy), Constants (copy), p5 (copy)
			p4:SetItem(Constants.LOCAL_STORAGE_KEY_LAST_CONTACTS_OS_PERMISSIONS, (tostring(p5)))
			p4:Flush()
		end)
	end
}
