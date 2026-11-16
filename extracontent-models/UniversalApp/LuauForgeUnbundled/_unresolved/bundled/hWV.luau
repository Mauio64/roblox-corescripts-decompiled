local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local HttpService = game:GetService("HttpService")

local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

local function getEpochMs()
	return (math.floor(os.time() * 1000))
end

return function(callback, p2)
	local v5 = string.format("%suser-heartbeats-api/action-report", Url.APIS_URL)
	local jsonEncode = HttpService:JSONEncode({
		actionInfo = p2,
		clientSideTimestampEpochMs = math.floor(os.time() * 1000),
		sessionInfo = {
			sessionId = RbxAnalyticsService:GetSessionId()
		}
	})

	local v6 = string.gsub(jsonEncode, "\"loginActionInfo\":%[%]", "\"loginActionInfo\":{}")
	return callback(v5, "POST", {
		postBody = string.gsub(v6, "\"logoutActionInfo\":%[%]", "\"logoutActionInfo\":{}")
	})
end
