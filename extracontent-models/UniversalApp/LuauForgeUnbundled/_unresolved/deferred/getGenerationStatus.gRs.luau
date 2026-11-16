local url = require("@luauforge/deferred/gRm").Url
require("@luauforge/deferred/gRn")

local module = require("@luauforge/deferred/gRo")
local module2 = require("@luauforge/deferred/gRt")
local module3 = require("@luauforge/deferred/gRu")

local function getGenerationStatus(callback, p2)
	return module(callback(`{url.APIS_URL}{module3.GENERATION_STATUS_BASE_URL}/{p2}`, "GET"), module2, {
		modelMismatchCounter = module3.GET_GENERATION_STATUS_MODEL_MISMATCH_COUNTER_NAME,
		latencyCounter = module3.GET_GENERATION_STATUS_LATENCY_COUNTER_NAME
	})
end

return getGenerationStatus
