local HttpService = game:GetService("HttpService")

local url = require("@luauforge/deferred/hds").Url
require("@luauforge/deferred/hdt")

local module = require("@luauforge/deferred/hdu")
local module2 = require("@luauforge/deferred/hdv")
local module3 = require("@luauforge/deferred/hdw")

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
