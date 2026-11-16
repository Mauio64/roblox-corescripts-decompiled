local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local HttpService = game:GetService("HttpService")

local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

local function getEpochMs()
	return (math.floor(os.time() * 1000))
end

return function(callback, p2, p3)
	return callback(string.format("%suser-heartbeats-api/pulse", Url.APIS_URL), "POST", {
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
