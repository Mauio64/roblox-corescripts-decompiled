local Constants = require(script.Parent.Parent.Parent.ContactImporter.Common.Constants)
local EngineFeature = game:GetEngineFeature(Constants.UNIVERSAL_APP_CONTACT_IMPORTER_STORAGE_KEYS)

return {
	addSeenCount = function(_: {[any]: any}, p1, s1: string) -- line: 9
		-- upvalues: EngineFeature (copy), Constants (copy)
		if not EngineFeature then
			return
		end

		local ok, result = pcall(function() -- line: 13
			-- upvalues: p1 (copy), Constants (copy)
			return p1:GetItem(Constants.LOCAL_STORAGE_KEY_MODAL_DISPLAY_COUNT)
		end)

		if ok then
			local s2 = ""

			if result == "" then
				s2 = s1 .. ":" .. "1"
			else
				local v9 = false

				for match in string.gmatch(result or "", "([^,]+)") do
					local parts = string.split(match, ":")
					local v12 = parts[1]
					local v13 = tonumber(parts[2]) or 0

					if v12 == s1 then
						v9 = true
						v13 += 1
					end

					local v14 = v12 .. ":" .. tostring(v13)

					s2 = if s2 == "" then v14 else s2 .. "," .. v14
				end

				if not v9 then
					s2 ..= "," .. s1 .. ":" .. "1"
				end
			end

			pcall(function() -- line: 44
				-- upvalues: p1 (copy), Constants (copy), s2 (ref)
				p1:SetItem(Constants.LOCAL_STORAGE_KEY_MODAL_DISPLAY_COUNT, s2)
				p1:Flush()
			end)
		end
	end,
	updateTimestamp = function(_: {[any]: any}, p2, s3: string, n1: number) -- line: 51
		-- upvalues: EngineFeature (copy), Constants (copy)
		if not EngineFeature then
			return
		end

		local ok, result = pcall(function() -- line: 60
			-- upvalues: p2 (copy), Constants (copy)
			return p2:GetItem(Constants.LOCAL_STORAGE_KEY_MODAL_TIMESTAMP)
		end)

		if ok then
			local s4 = ""

			if result == "" then
				s4 = s3 .. ":" .. tostring(n1)
			else
				local v22 = false

				for match in string.gmatch(result or "", "([^,]+)") do
					local parts = string.split(match, ":")
					local v25 = parts[1]
					local v26 = parts[2]

					if v25 == s3 then
						v26 = tostring(n1)
						v22 = true
					end

					local v27 = v25 .. ":" .. tostring(v26)

					s4 = if s4 == "" then v27 else s4 .. "," .. v27
				end

				if not v22 then
					s4 ..= "," .. s3 .. ":" .. tostring(n1)
				end
			end

			pcall(function() -- line: 92
				-- upvalues: p2 (copy), Constants (copy), s4 (ref)
				p2:SetItem(Constants.LOCAL_STORAGE_KEY_MODAL_TIMESTAMP, s4)
				p2:Flush()
			end)
		end
	end
}
