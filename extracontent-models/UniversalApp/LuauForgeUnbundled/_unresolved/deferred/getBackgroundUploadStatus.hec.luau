local url = require("@luauforge/deferred/hds").Url
require("@luauforge/deferred/hdt")

local module = require("@luauforge/deferred/hdu")
local module2 = require("@luauforge/deferred/hed")
local module3 = require("@luauforge/deferred/hee")

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
