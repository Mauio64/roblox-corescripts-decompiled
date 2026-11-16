local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/Constants")

local engineFeature = game:GetEngineFeature(Constants.UNIVERSAL_APP_CONTACT_IMPORTER_STORAGE_KEYS)
local getFIntContactImporterSyncMinHours = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Flags/getFIntContactImporterSyncMinHours")

return {
	updateSyncTimestamp = function(self, object, p3, p4)
		if not engineFeature then
			return
		end

		local success, result = pcall(function()
			return object:GetItem(Constants.LOCAL_STORAGE_KEY_CONTACTS_SYNC)
		end)

		if success then
			local v5 = ""

			if result == "" then
				v5 = p3 .. ":" .. tostring(p4)
			else
				local v6 = false

				for k in string.gmatch(result or "", "([^,]+)") do
					local v7 = string.split(k, ":")
					local v8 = v7[1]
					local v9 = tonumber(v7[2]) or 0

					if v8 == p3 then
						v9 = p4
						v6 = true
					end

					local v10 = v8 .. ":" .. tostring(v9)
					v5 = if v5 == "" then v10 else v5 .. "," .. v10
				end

				if not v6 then
					v5 ..= "," .. p3 .. ":" .. tostring(p4)
				end
			end

			pcall(function()
				object:SetItem(Constants.LOCAL_STORAGE_KEY_CONTACTS_SYNC, v5)
				object:Flush()
			end)
		end
	end,
	shouldSyncContacts = function(self, object, p3, p4): boolean
		if not engineFeature then
			return true
		end

		local success, result = pcall(function()
			return object:GetItem(Constants.LOCAL_STORAGE_KEY_CONTACTS_SYNC)
		end)

		if not success then
			return true
		end

		local v5 = 0

		for k in string.gmatch(result or "", "([^,]+)") do
			local v7 = string.split(k, ":")

			if v7[1] == p3 then
				v5 = tonumber(v7[2])
				break
			end
		end

		return getFIntContactImporterSyncMinHours() * 3600000 <= p4 - v5
	end
}
