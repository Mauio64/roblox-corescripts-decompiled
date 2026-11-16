local MemStorageService = game:GetService("MemStorageService")

return function(p: string, callback)
	if callback == nil or MemStorageService:HasItem(p) then
		return
	end

	MemStorageService:SetItem(p, "true")
	callback()
end
