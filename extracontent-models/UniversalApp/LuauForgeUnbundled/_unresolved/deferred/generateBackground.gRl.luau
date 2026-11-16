local HttpService = game:GetService("HttpService")

local url = require("@luauforge/deferred/gRm").Url
require("@luauforge/deferred/gRn")

local module = require("@luauforge/deferred/gRo")
local module2 = require("@luauforge/deferred/gRp")
local module3 = require("@luauforge/deferred/gRq")

local function generateBackground(callback, p2)
	return module(
		callback(`{url.APIS_URL}{module3.GENERATE_BACKGROUND_URL}`, "POST", {
			postBody = HttpService:JSONEncode(p2)
		}),
		module2,
		{
			modelMismatchCounter = module3.GENERATE_BACKGROUND_MODEL_MISMATCH_COUNTER_NAME,
			latencyCounter = module3.GENERATE_BACKGROUND_LATENCY_COUNTER_NAME
		}
	)
end

return generateBackground
