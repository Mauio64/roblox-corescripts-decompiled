local GamePassConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/GamePassConfig")
local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/HttpClient")
local createManageDevProductNetwork = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/createManageDevProductNetwork")

local function createManageGamePassStore()
	return GamePassConfig.createGamePassConfigStore({
		network = createManageDevProductNetwork(HttpClient.createRequestInternalNetwork(), {
			label = "GamePassConfig"
		})
	})
end

return createManageGamePassStore
