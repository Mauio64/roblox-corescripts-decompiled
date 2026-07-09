local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Modules = CoreGui.RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

local function getEpochMs() -- line: 14
	return (math.floor(os.time() * 1000))
end

return function(p1, p2) -- line: 34
	-- upvalues: Url (copy), HttpService (copy), RbxAnalyticsService (copy)
	local v9 = string.format("%suser-heartbeats-api/action-report", Url.APIS_URL)
	local json = HttpService:JSONEncode({
		actionInfo = p2,
		clientSideTimestampEpochMs = math.floor(os.time() * 1000),
		sessionInfo = {
			sessionId = RbxAnalyticsService:GetSessionId()
		}
	})
	local v11 = string.gsub(json, "\"loginActionInfo\":%[%]", "\"loginActionInfo\":{}")

	return p1(v9, "POST", {
		postBody = string.gsub(v11, "\"logoutActionInfo\":%[%]", "\"logoutActionInfo\":{}")
	})
end
