local Constants = require(script.Parent.Parent.Constants)
local EngineFeature = game:GetEngineFeature(Constants.UNIVERSAL_APP_CONTACT_IMPORTER_STORAGE_KEYS)

return {
	clearLocalStorage = function(_, p2) -- line: 6
		-- upvalues: EngineFeature (copy), Constants (copy)
		if not EngineFeature then
			return
		end

		pcall(function() -- line: 10
			-- upvalues: p2 (copy), Constants (copy)
			p2:SetItem(Constants.LOCAL_STORAGE_KEY_OPTED_IN_USERS, "")
			p2:Flush()
		end)
	end,
	addUserToLocalStorage = function(_, p4, p5) -- line: 16
		-- upvalues: EngineFeature (copy), Constants (copy)
		if not EngineFeature then
			return
		end

		local ok, result = pcall(function() -- line: 21
			-- upvalues: p4 (copy), Constants (copy)
			return p4:GetItem(Constants.LOCAL_STORAGE_KEY_OPTED_IN_USERS)
		end)

		if ok then
			local t1 = {
				[1] = p5
			}

			if result ~= nil and result ~= "" then
				local v11 = #t1 + 1

				for match in string.gmatch(result, "([^,]+)") do
					if match == p5 then
						return
					end

					t1[v11] = match
					v11 += 1
				end
			end

			local u13 = table.concat(t1, ","):gsub("%s+", "")

			pcall(function() -- line: 41
				-- upvalues: p4 (copy), Constants (copy), u13 (ref)
				p4:SetItem(Constants.LOCAL_STORAGE_KEY_OPTED_IN_USERS, u13)
				p4:Flush()
			end)
		end
	end
}
