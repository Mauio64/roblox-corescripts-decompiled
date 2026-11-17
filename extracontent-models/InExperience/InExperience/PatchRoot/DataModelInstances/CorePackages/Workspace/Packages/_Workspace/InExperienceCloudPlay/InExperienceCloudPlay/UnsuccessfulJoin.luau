local MemStorageService = game:GetService("MemStorageService")
local UnsuccessfulJoin = {}

function UnsuccessfulJoin.markUnsuccessfulJoin()
	MemStorageService:SetItem("CloudPlayUnsuccessfulJoin", "true")
end

function UnsuccessfulJoin.consumeUnsuccessfulJoin(): boolean
	if MemStorageService:GetItem("CloudPlayUnsuccessfulJoin") == "" then
		return false
	end

	MemStorageService:RemoveItem("CloudPlayUnsuccessfulJoin")
	return true
end

return UnsuccessfulJoin
