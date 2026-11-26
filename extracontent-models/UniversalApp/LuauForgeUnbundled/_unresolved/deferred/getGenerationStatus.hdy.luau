local url = require("@luauforge/deferred/hds").Url
require("@luauforge/deferred/hdt")

local module = require("@luauforge/deferred/hdu")
local module2 = require("@luauforge/deferred/hdz")
local module3 = require("@luauforge/deferred/hdA")

local function getGenerationStatus(callback, p2)
	return module(callback(`{url.APIS_URL}{module3.GENERATION_STATUS_BASE_URL}/{p2}`, "GET"), module2, {
		modelMismatchCounter = module3.GET_GENERATION_STATUS_MODEL_MISMATCH_COUNTER_NAME,
		latencyCounter = module3.GET_GENERATION_STATUS_LATENCY_COUNTER_NAME
	})
end

return getGenerationStatus
