local createRequestThunks = require(script.createRequestThunks)

return {
	["jest.config"] = script["jest.config"],
	config = createRequestThunks
}
