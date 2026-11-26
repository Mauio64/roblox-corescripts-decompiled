local MemStorageService = game:GetService("MemStorageService")

return {
	markUnsuccessfulJoin = function()
		MemStorageService:SetItem("CloudPlayUnsuccessfulJoin", "true")
	end,
	consumeUnsuccessfulJoin = function(): boolean
		if MemStorageService:GetItem("CloudPlayUnsuccessfulJoin") == "" then
			return false
		end

		MemStorageService:RemoveItem("CloudPlayUnsuccessfulJoin")
		return true
	end
}
