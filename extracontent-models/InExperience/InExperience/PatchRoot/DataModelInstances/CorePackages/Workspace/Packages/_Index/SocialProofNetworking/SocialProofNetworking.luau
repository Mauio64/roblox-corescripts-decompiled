local networkRequests = script.networkRequests
local createGetConnectionsByEntityId = require(networkRequests.createGetConnectionsByEntityId)

local function createRequestThunks(p)
	return {
		GetConnectionsByEntityId = createGetConnectionsByEntityId(p)
	}
end

return {
	config = createRequestThunks,
	Types = require(script.types),
	["jest.config"] = script["jest.config"]
}
