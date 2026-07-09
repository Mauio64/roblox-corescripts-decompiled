local HttpService = game:GetService("HttpService")
local AppStorageService = game:GetService("AppStorageService")

return {
	getTableAppStorageKey = function(p1) -- line: 4
		-- upvalues: AppStorageService (copy), HttpService (copy)
		local ok, result = pcall(function() -- line: 5
			-- upvalues: AppStorageService (copy), p1 (copy)
			return AppStorageService:GetItem(p1)
		end)

		if not ok or result == nil then
			return {}
		end

		return HttpService:JSONDecode(result)
	end,
	setTableAppStorageKey = function(p2, p3) -- line: 16
		-- upvalues: AppStorageService (copy)
		pcall(function() -- line: 17
			-- upvalues: AppStorageService (copy), p2 (copy), p3 (copy)
			AppStorageService:SetItem(p2, (tostring(p3)))
			AppStorageService:Flush()
		end)
	end
}
