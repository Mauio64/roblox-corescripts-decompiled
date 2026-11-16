local networkRequests = script.networkRequests
local createGetCurrentlyWearing = require(networkRequests.createGetCurrentlyWearing)
local createGetItemDetails = require(networkRequests.createGetItemDetails)

local function createRequestThunks(p)
	return {
		GetCurrentlyWearing = createGetCurrentlyWearing(p),
		GetItemDetails = createGetItemDetails(p)
	}
end

return { config = createRequestThunks }
