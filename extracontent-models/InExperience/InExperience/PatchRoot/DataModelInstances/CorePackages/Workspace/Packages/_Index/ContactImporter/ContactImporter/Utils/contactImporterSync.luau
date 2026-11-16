local Constants = require(script.Parent.Parent.Parent.ContactImporter.Common.Constants)

local engineFeature = game:GetEngineFeature(Constants.UNIVERSAL_APP_CONTACT_IMPORTER_STORAGE_KEYS)
local getFIntContactImporterSyncMinHours = require(script.Parent.Parent.Flags.getFIntContactImporterSyncMinHours)
local ContactImporterSync = {}

function ContactImporterSync.updateSyncTimestamp(_, object, p: string, p2: number)
	if not engineFeature then
		return
	end

	local success, result = pcall(function()
		return object:GetItem(Constants.LOCAL_STORAGE_KEY_CONTACTS_SYNC)
	end)

	if success then
		local v = ""

		if result == "" then
			v = p .. ":" .. tostring(p2)
		else
			local v2 = false

			for k in string.gmatch(result or "", "([^,]+)") do
				local v3 = string.split(k, ":")
				local v4 = v3[1]
				local v5 = tonumber(v3[2]) or 0

				if v4 == p then
					v5 = p2
					v2 = true
				end

				local v6 = v4 .. ":" .. tostring(v5)

				if v == "" then
					v = v6
				else
					v ..= "," .. v6
				end
			end

			if not v2 then
				v ..= "," .. p .. ":" .. tostring(p2)
			end
		end

		pcall(function()
			object:SetItem(Constants.LOCAL_STORAGE_KEY_CONTACTS_SYNC, v)
			object:Flush()
		end)
	end
end

function ContactImporterSync.shouldSyncContacts(_, object, p: string, p2: number): boolean
	if not engineFeature then
		return true
	end

	local success, result = pcall(function()
		return object:GetItem(Constants.LOCAL_STORAGE_KEY_CONTACTS_SYNC)
	end)

	if not success then
		return true
	end

	local v = 0

	for k in string.gmatch(result or "", "([^,]+)") do
		local v2 = string.split(k, ":")

		if v2[1] == p then
			v = tonumber(v2[2])
			break
		end
	end

	return getFIntContactImporterSyncMinHours() * 3600000 <= p2 - v
end

return ContactImporterSync
