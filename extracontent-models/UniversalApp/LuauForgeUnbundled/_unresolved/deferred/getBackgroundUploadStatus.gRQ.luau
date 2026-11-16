local url = require("@luauforge/deferred/gRm").Url
require("@luauforge/deferred/gRn")

local module = require("@luauforge/deferred/gRo")
local module2 = require("@luauforge/deferred/gRR")
local module3 = require("@luauforge/deferred/gRS")

local function getBackgroundUploadStatus(callback, p2, p3)
	local v5, v6 = callback(
		`{url.APIS_URL}{module3.GET_BACKGROUND_UPLOAD_STATUS_BASE_URL}/{p2}/uploads/{p3}`,
		"GET"
	)

	return
		module(v5, module2, {
			modelMismatchCounter = module3.GET_BACKGROUND_UPLOAD_STATUS_MODEL_MISMATCH_COUNTER_NAME,
			latencyCounter = module3.GET_BACKGROUND_UPLOAD_STATUS_LATENCY_COUNTER_NAME
		}),
		v6
end

return getBackgroundUploadStatus
