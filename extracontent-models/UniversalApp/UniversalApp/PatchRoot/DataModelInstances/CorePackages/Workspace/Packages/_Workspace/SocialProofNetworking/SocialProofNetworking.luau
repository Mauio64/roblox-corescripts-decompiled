local networkRequests = script.networkRequests
local createGetConnectionsByEntityId = require(networkRequests.createGetConnectionsByEntityId)
local types = require(script.types)

local function createRequestThunks(p1) -- line: 9
	-- upvalues: createGetConnectionsByEntityId (copy)
	return {
		GetConnectionsByEntityId = createGetConnectionsByEntityId(p1)
	}
end

return {
	config = createRequestThunks,
	Types = types,
	["jest.config"] = script["jest.config"]
}
