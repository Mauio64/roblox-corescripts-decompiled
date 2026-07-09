local createRequestThunks = require(script.createRequestThunks)
local networkingShareLinkTypes = require(script.networkingShareLinkTypes)

return {
	["jest.config"] = script["jest.config"],
	config = createRequestThunks,
	networkingShareLinkTypes = networkingShareLinkTypes
}
