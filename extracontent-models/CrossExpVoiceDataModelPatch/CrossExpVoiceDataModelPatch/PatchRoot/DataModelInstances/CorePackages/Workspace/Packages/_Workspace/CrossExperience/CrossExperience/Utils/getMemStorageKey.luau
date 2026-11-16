local MemStorageService = game:GetService("MemStorageService")

return function(p: string)
	local success, result = pcall(function()
		return MemStorageService:GetItem(p)
	end)
	return if success and result and result ~= "" then result else nil
end
