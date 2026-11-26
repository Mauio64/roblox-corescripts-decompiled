local AppStorageService = game:GetService("AppStorageService")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants")
local RoduxSquads = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/RoduxSquads")

return function()
	AppStorageService:SetItem(Constants.ACTIVE_SQUAD_APP_STORAGE_KEY, "")
	AppStorageService:Flush()

	RoduxSquads.PersistManagers.currentSquadPersistManager.reset()
end
