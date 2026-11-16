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

local MomentsLocalStorage = {}
MomentsLocalStorage.get = get

function MomentsLocalStorage.set(p)
	pcall(function()
		AppStorageService:SetItem("MomentsLocalStorage", HttpService:JSONEncode(p))
		AppStorageService:Flush()
	end)
end

function MomentsLocalStorage.getField(p: string)
	return get()[p]
end

function MomentsLocalStorage.setField(p: string, p2)
	local v = get()
	v[p] = p2
	pcall(function()
		AppStorageService:SetItem("MomentsLocalStorage", HttpService:JSONEncode(v))
		AppStorageService:Flush()
	end)
end

return MomentsLocalStorage
