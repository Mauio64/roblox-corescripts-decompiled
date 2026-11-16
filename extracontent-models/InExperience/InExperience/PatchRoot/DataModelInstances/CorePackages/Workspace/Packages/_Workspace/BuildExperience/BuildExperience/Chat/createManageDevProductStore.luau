local parent = script:FindFirstAncestor("BuildExperience").Parent

local DeveloperProduct = require(parent.DataHydration.DeveloperProduct)
local HttpClient = require(parent.HttpClient)
local createManageDevProductNetwork = require(script.Parent.createManageDevProductNetwork)

local function createManageDevProductStore()
	return DeveloperProduct.createDeveloperProductStore({
		network = createManageDevProductNetwork(HttpClient.createRequestInternalNetwork())
	})
end

return createManageDevProductStore
