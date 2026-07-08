local MemStorageService = game:GetService("MemStorageService")

return function(s1: string) -- line: 3
	-- upvalues: MemStorageService (copy)
	local ok, result = pcall(function() -- line: 4
		-- upvalues: MemStorageService (copy), s1 (copy)
		return MemStorageService:GetItem(s1)
	end)

	if ok and (result and result ~= "") then
		return result
	end

	return nil
end
