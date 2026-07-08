local networkRequests = script.networkRequests
local createGetCurrentlyWearing = require(networkRequests.createGetCurrentlyWearing)
local createGetItemDetails = require(networkRequests.createGetItemDetails)

local function createRequestThunks(p1) -- line: 9
	-- upvalues: createGetCurrentlyWearing (copy), createGetItemDetails (copy)
	return {
		GetCurrentlyWearing = createGetCurrentlyWearing(p1),
		GetItemDetails = createGetItemDetails(p1)
	}
end

return {
	config = createRequestThunks
}
