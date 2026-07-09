local SquadsCore = script:FindFirstAncestor("SquadsCore")
local AppStorageService = game:GetService("AppStorageService")
local Constants = require(SquadsCore.Common.Constants)
local RoduxSquads = require(SquadsCore.RoduxSquads)

return function() -- line: 8
	-- upvalues: AppStorageService (copy), Constants (copy), RoduxSquads (copy)
	AppStorageService:SetItem(Constants.ACTIVE_SQUAD_APP_STORAGE_KEY, "")
	AppStorageService:Flush()
	RoduxSquads.PersistManagers.currentSquadPersistManager.reset()
end
