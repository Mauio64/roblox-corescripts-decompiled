local DeveloperProduct = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/DeveloperProduct")
local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/HttpClient")
local createManageDevProductNetwork = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/createManageDevProductNetwork")

local function createManageDevProductStore()
	return DeveloperProduct.createDeveloperProductStore({
		network = createManageDevProductNetwork(HttpClient.createRequestInternalNetwork())
	})
end

return createManageDevProductStore
