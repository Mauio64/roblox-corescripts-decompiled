local HttpService = game:GetService("HttpService")
local AppStorageService = game:GetService("AppStorageService")
local AppStorageAccess = {}

function AppStorageAccess.getTableAppStorageKey(p)
	local success, result = pcall(function()
		return AppStorageService:GetItem(p)
	end)

	if success and result ~= nil then
		return HttpService:JSONDecode(result)
	end

	return {}
end

function AppStorageAccess.setTableAppStorageKey(p, p2)
	pcall(function()
		AppStorageService:SetItem(p, (tostring(p2)))
		AppStorageService:Flush()
	end)
end

return AppStorageAccess
