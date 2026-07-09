local ContactsToast = script:FindFirstAncestor("ContactsToast")
local AppStorageService = game:GetService("AppStorageService")
local Constants = require(ContactsToast.Common.Constants)
local EngineFeature = game:GetEngineFeature(Constants.ENGINE_FEATURE_STORAGE_KEY)

return {
	AddUser = function(_, p2) -- line: 8
		-- upvalues: EngineFeature (copy), AppStorageService (copy), Constants (copy)
		if not EngineFeature then
			return
		end

		local ok, result = pcall(function() -- line: 13
			-- upvalues: AppStorageService (copy), Constants (copy)
			return AppStorageService:GetItem(Constants.TOAST_SEEN_STORAGE_KEY)
		end)

		if ok then
			local t1 = {
				[1] = p2
			}

			if result ~= nil and result ~= "" then
				local v10 = #t1 + 1

				for match in string.gmatch(result, "([^,]+)") do
					if match == p2 then
						return
					end

					t1[v10] = match
					v10 += 1
				end
			end

			local u12 = table.concat(t1, ","):gsub("%s+", "")

			pcall(function() -- line: 32
				-- upvalues: AppStorageService (copy), Constants (copy), u12 (ref)
				AppStorageService:SetItem(Constants.TOAST_SEEN_STORAGE_KEY, u12)
				AppStorageService:Flush()
			end)
		end
	end,
	CheckUserHasNotSeen = function(_, p4) -- line: 39
		-- upvalues: EngineFeature (copy), AppStorageService (copy), Constants (copy)
		if not EngineFeature then
			return false
		end

		local ok, result = pcall(function() -- line: 44
			-- upvalues: AppStorageService (copy), Constants (copy)
			return AppStorageService:GetItem(Constants.TOAST_SEEN_STORAGE_KEY)
		end)

		if ok then
			for match in string.gmatch(result or "", "([^,]+)") do
				if p4 == match then
					return false
				end
			end
		end

		return true
	end,
	CheckUserHasNotOptedIn = function(_, p6) -- line: 58
		-- upvalues: EngineFeature (copy), AppStorageService (copy), Constants (copy)
		if not EngineFeature then
			return false
		end

		local ok, result = pcall(function() -- line: 63
			-- upvalues: AppStorageService (copy), Constants (copy)
			return AppStorageService:GetItem(Constants.OPTED_IN_USERS_STORAGE_KEY)
		end)

		if ok then
			for match in string.gmatch(result or "", "([^,]+)") do
				if p6 == match then
					return false
				end
			end
		end

		return true
	end
}
