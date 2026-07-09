local networkRequests = script.networkRequests
local createGetAssetDetails = require(networkRequests.createGetAssetDetails)

local function createRequestThunks(p1) -- line: 8
	-- upvalues: createGetAssetDetails (copy)
	return {
		GetAssetDetails = createGetAssetDetails(p1)
	}
end

return {
	config = createRequestThunks,
	["jest.config"] = script["jest.config"]
}
