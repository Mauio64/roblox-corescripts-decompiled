local parent = script:FindFirstAncestor("BuildExperience").Parent

local GamePassConfig = require(parent.DataHydration.GamePassConfig)
local HttpClient = require(parent.HttpClient)
local createManageDevProductNetwork = require(script.Parent.createManageDevProductNetwork)

local function createManageGamePassStore()
	return GamePassConfig.createGamePassConfigStore({
		network = createManageDevProductNetwork(HttpClient.createRequestInternalNetwork(), {
			label = "GamePassConfig"
		})
	})
end

return createManageGamePassStore
