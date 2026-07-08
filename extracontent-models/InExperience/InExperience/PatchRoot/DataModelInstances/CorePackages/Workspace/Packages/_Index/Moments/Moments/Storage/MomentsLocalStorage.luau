local HttpService = game:GetService("HttpService")
local AppStorageService = game:GetService("AppStorageService")

local function get() -- line: 7
	-- upvalues: AppStorageService (copy), HttpService (copy)
	local ok, result = pcall(AppStorageService.GetItem, AppStorageService, "MomentsLocalStorage")

	if not ok or result == "" then
		return {}
	end

	local ok2, result2 = pcall(HttpService.JSONDecode, HttpService, result)

	if ok2 and typeof(result2) == "table" then
		return result2
	end

	return {}
end

return {
	get = get,
	set = function(t1: {[any]: any}) -- line: 16
		-- upvalues: AppStorageService (copy), HttpService (copy)
		pcall(function() -- line: 17
			-- upvalues: AppStorageService (copy), HttpService (copy), t1 (copy)
			AppStorageService:SetItem("MomentsLocalStorage", HttpService:JSONEncode(t1))
			AppStorageService:Flush()
		end)
	end,
	getField = function(s1: string) -- line: 23
		-- upvalues: get (copy)
		return get()[s1]
	end,
	setField = function(s2: string, p1) -- line: 27
		-- upvalues: get (copy), AppStorageService (copy), HttpService (copy)
		local v12 = get()

		v12[s2] = p1
		pcall(function() -- line: 17
			-- upvalues: AppStorageService (copy), HttpService (copy), v12 (copy)
			AppStorageService:SetItem("MomentsLocalStorage", HttpService:JSONEncode(v12))
			AppStorageService:Flush()
		end)
	end
}
