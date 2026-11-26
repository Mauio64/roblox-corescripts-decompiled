local MemStorageService = game:GetService("MemStorageService")

return function(p2)
	local success, result = pcall(function()
		return MemStorageService:GetItem(p2)
	end)

	if success and result and result ~= "" then
		return result
	end

	return nil
end
