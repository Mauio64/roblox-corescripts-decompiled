local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Modules = CoreGui.RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

local function getEpochMs() -- line: 14
	return (math.floor(os.time() * 1000))
end

return function(p1, n1: number, s1: string) -- line: 18
	-- upvalues: Url (copy), HttpService (copy), RbxAnalyticsService (copy)
	return p1(string.format("%suser-heartbeats-api/pulse", Url.APIS_URL), "POST", {
		postBody = HttpService:JSONEncode({
			clientSideTimestampEpochMs = math.floor(os.time() * 1000),
			locationInfo = {
				universalAppLocationInfo = {
					activeState = n1,
					pageName = s1
				}
			},
			sessionInfo = {
				sessionId = RbxAnalyticsService:GetSessionId()
			}
		})
	})
end
