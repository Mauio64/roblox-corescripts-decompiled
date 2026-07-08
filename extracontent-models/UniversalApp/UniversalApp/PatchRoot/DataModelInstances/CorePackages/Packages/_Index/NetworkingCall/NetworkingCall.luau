local createRequestThunks = require(script.createRequestThunks)
local networkingCallTypes = require(script.networkingCallTypes)

return {
	config = createRequestThunks,
	networkingCallTypes = networkingCallTypes
}
