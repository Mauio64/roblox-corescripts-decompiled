local HttpService = game:GetService("HttpService")
local AppStorageService = game:GetService("AppStorageService")

return {
	getTableAppStorageKey = function(p2)
		local success, result = pcall(function()
			return AppStorageService:GetItem(p2)
		end)

		if success and result ~= nil then
			return HttpService:JSONDecode(result)
		end

		return {}
	end,
	setTableAppStorageKey = function(p2, p3)
		pcall(function()
			AppStorageService:SetItem(p2, (tostring(p3)))
			AppStorageService:Flush()
		end)
	end
}
