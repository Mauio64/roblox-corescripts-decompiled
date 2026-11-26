local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/dVn")

local function getEpochMs()
	return (math.floor(os.time() * 1000))
end

return function(callback, p2, p3)
	return callback(string.format("%suser-heartbeats-api/pulse", module.APIS_URL), "POST", {
		postBody = HttpService:JSONEncode({
			clientSideTimestampEpochMs = math.floor(os.time() * 1000),
			locationInfo = {
				universalAppLocationInfo = { activeState = p2, pageName = p3 }
			},
			sessionInfo = {
				sessionId = RbxAnalyticsService:GetSessionId()
			}
		})
	})
end
