local SquadsCore = script:FindFirstAncestor("SquadsCore")

local AppStorageService = game:GetService("AppStorageService")

local Constants = require(SquadsCore.Common.Constants)
local RoduxSquads = require(SquadsCore.RoduxSquads)

return function()
	AppStorageService:SetItem(Constants.ACTIVE_SQUAD_APP_STORAGE_KEY, "")
	AppStorageService:Flush()

	RoduxSquads.PersistManagers.currentSquadPersistManager.reset()
end
