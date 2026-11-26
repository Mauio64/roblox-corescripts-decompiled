local MemStorageService = game:GetService("MemStorageService")

return function(p2, callback)
	if callback == nil or MemStorageService:HasItem(p2) then
		return
	end

	MemStorageService:SetItem(p2, "true")
	callback()
end
