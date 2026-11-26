local HttpService = game:GetService("HttpService")
local AppStorageService = game:GetService("AppStorageService")

local function get()
	local success, item = pcall(AppStorageService.GetItem, AppStorageService, "MomentsLocalStorage")

	if not success or item == "" then
		return {}
	end

	local success2, result = pcall(HttpService.JSONDecode, HttpService, item)

	if success2 and typeof(result) == "table" then
		return result
	end

	return {}
end

return {
	get = get,
	set = function(p2)
		pcall(function()
			AppStorageService:SetItem("MomentsLocalStorage", HttpService:JSONEncode(p2))
			AppStorageService:Flush()
		end)
	end,
	getField = function(p2)
		return get()[p2]
	end,
	setField = function(p2, p3)
		local v5 = get()
		v5[p2] = p3
		pcall(function()
			AppStorageService:SetItem("MomentsLocalStorage", HttpService:JSONEncode(v5))
			AppStorageService:Flush()
		end)
	end
}
