local createRequestThunks = require(script.createRequestThunks)
local networkingShareLinkTypes = require(script.networkingShareLinkTypes)

return {
	config = createRequestThunks,
	networkingShareLinkTypes = networkingShareLinkTypes
}
