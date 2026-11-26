local HttpService = game:GetService("HttpService")
local module = require("@luauforge/bundled/dVn")

return function(callback, p2, p3)
	return callback(string.format("%sabuse-reporting/v1/safety-event", module.APIS_URL), "POST", {
		postBody = HttpService:JSONEncode({
			safetyEvent = {
				eventTime = DateTime.now().UnixTimestampMillis,
				idempotencyKey = "subscriptions/" .. p2 .. "/" .. p3,
				tags = {
					SUBMITTER_USER_ID = {
						valueList = {
							{ data = p3 }
						}
					},
					ENTRY_POINT = {
						valueList = {
							{ data = "luaApp" }
						}
					},
					REPORTED_ABUSE_CATEGORY = {
						valueList = {
							{ data = "ABUSE_CATEGORY_OTHER" }
						}
					},
					REPORTED_ABUSE_VECTOR = {
						valueList = {
							{ data = "subscriptions" }
						}
					},
					REPORTER_COMMENT = {
						valueList = {
							{ data = "" }
						}
					},
					REPORT_TARGET_ASSET_ID = {
						valueList = {
							{ data = "0" }
						}
					},
					REPORT_TARGET_SUBSCRIPTION_TARGET_KEY = {
						valueList = {
							{ data = p2 }
						}
					}
				}
			}
		})
	})
end
