local MemStorageService = game:GetService("MemStorageService")

return function(s1: string, p1: ((...any) -> ...any)) -- line: 6
	-- upvalues: MemStorageService (copy)
	if p1 == nil then
		return
	end

	if MemStorageService:HasItem(s1) then
		return
	end

	MemStorageService:SetItem(s1, "true")
	p1()
end
