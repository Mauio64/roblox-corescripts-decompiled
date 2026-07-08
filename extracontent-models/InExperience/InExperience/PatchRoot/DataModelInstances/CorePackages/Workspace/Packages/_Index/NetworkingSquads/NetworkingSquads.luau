local createRequestThunks = require(script.createRequestThunks)
local networkingSquadTypes = require(script.networkingSquadTypes)

return {
	["jest.config"] = script["jest.config"],
	config = createRequestThunks,
	networkingSquadTypes = networkingSquadTypes
}
