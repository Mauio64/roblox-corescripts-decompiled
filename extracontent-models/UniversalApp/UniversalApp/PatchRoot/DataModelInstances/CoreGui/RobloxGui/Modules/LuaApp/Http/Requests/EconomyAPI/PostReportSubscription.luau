local Modules = game:GetService("CoreGui").RobloxGui.Modules
local HttpService = game:GetService("HttpService")
local Url = require(Modules.LuaApp.Http.Url)

return function(p1, s1: string, s2: string) -- line: 5
	-- upvalues: Url (copy), HttpService (copy)
	return p1(string.format("%sabuse-reporting/v1/safety-event", Url.APIS_URL), "POST", {
		postBody = HttpService:JSONEncode({
			safetyEvent = {
				eventTime = DateTime.now().UnixTimestampMillis,
				idempotencyKey = "subscriptions/" .. s1 .. "/" .. s2,
				tags = {
					SUBMITTER_USER_ID = {
						valueList = {{
							data = s2
						}}
					},
					ENTRY_POINT = {
						valueList = {{
							data = "luaApp"
						}}
					},
					REPORTED_ABUSE_CATEGORY = {
						valueList = {{
							data = "ABUSE_CATEGORY_OTHER"
						}}
					},
					REPORTED_ABUSE_VECTOR = {
						valueList = {{
							data = "subscriptions"
						}}
					},
					REPORTER_COMMENT = {
						valueList = {{
							data = ""
						}}
					},
					REPORT_TARGET_ASSET_ID = {
						valueList = {{
							data = "0"
						}}
					},
					REPORT_TARGET_SUBSCRIPTION_TARGET_KEY = {
						valueList = {{
							data = s1
						}}
					}
				}
			}
		})
	})
end
