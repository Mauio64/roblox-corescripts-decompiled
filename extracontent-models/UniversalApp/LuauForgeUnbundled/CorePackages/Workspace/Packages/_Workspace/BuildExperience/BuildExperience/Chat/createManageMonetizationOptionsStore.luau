local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/HttpClient")
local MonetizationOptions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/MonetizationOptions")
local createManageDevProductNetwork = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/createManageDevProductNetwork")

local function createManageMonetizationOptionsStore()
	return MonetizationOptions.createMonetizationOptionsStore({
		network = createManageDevProductNetwork(HttpClient.createRequestInternalNetwork(), {
			label = "MonetizationOptions"
		})
	})
end

return createManageMonetizationOptionsStore
