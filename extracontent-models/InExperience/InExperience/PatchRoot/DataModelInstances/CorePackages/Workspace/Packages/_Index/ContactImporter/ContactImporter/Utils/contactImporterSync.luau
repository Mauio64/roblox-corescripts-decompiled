local Constants = require(script.Parent.Parent.Parent.ContactImporter.Common.Constants)
local EngineFeature = game:GetEngineFeature(Constants.UNIVERSAL_APP_CONTACT_IMPORTER_STORAGE_KEYS)
local getFIntContactImporterSyncMinHours = require(script.Parent.Parent.Flags.getFIntContactImporterSyncMinHours)

return {
	updateSyncTimestamp = function(_: {[any]: any}, p1, s1: string, n1: number) -- line: 11
		-- upvalues: EngineFeature (copy), Constants (copy)
		if not EngineFeature then
			return
		end

		local ok, result = pcall(function() -- line: 15
			-- upvalues: p1 (copy), Constants (copy)
			return p1:GetItem(Constants.LOCAL_STORAGE_KEY_CONTACTS_SYNC)
		end)

		if ok then
			local s2 = ""

			if result == "" then
				s2 = s1 .. ":" .. tostring(n1)
			else
				local v11 = false

				for match in string.gmatch(result or "", "([^,]+)") do
					local parts = string.split(match, ":")
					local v14 = parts[1]
					local v15 = tonumber(parts[2]) or 0

					if v14 == s1 then
						v11 = true
						v15 = n1
					end

					local v16 = v14 .. ":" .. tostring(v15)

					s2 = if s2 == "" then v16 else s2 .. "," .. v16
				end

				if not v11 then
					s2 ..= "," .. s1 .. ":" .. tostring(n1)
				end
			end

			pcall(function() -- line: 46
				-- upvalues: p1 (copy), Constants (copy), s2 (ref)
				p1:SetItem(Constants.LOCAL_STORAGE_KEY_CONTACTS_SYNC, s2)
				p1:Flush()
			end)
		end
	end,
	shouldSyncContacts = function(_: {[any]: any}, p2, s3: string, n2: number) -- line: 53
		-- upvalues: EngineFeature (copy), Constants (copy), getFIntContactImporterSyncMinHours (copy)
		if not EngineFeature then
			return true
		end

		local ok, result = pcall(function() -- line: 57
			-- upvalues: p2 (copy), Constants (copy)
			return p2:GetItem(Constants.LOCAL_STORAGE_KEY_CONTACTS_SYNC)
		end)

		if not ok then
			return true
		end

		local n3 = 0

		for match in string.gmatch(result or "", "([^,]+)") do
			local parts = string.split(match, ":")

			if s3 == parts[1] then
				n3 = tonumber(parts[2])

				break
			end
		end

		if getFIntContactImporterSyncMinHours() * 3600000 <= n2 - n3 then
			return true
		end

		return false
	end
}
