local module = require("@luauforge/bundled/hvk")
local rodux = module.Rodux
local appChatNetworking = module.AppChatNetworking
local module2 = require("@luauforge/bundled/hvy")

return rodux.createReducer(0, {
	[module2.Succeeded.name] = function(p2, p3)
		if p3.responseBody and p3.responseBody.count then
			return p3.responseBody.count
		end

		return p2
	end,
	[appChatNetworking.rodux.GetConversationMetadata.Succeeded.name] = function(p2, p3)
		if p3.responseBody and p3.responseBody.global_unread_count then
			return p3.responseBody.global_unread_count
		end

		return p2
	end,
	[appChatNetworking.rodux.ClearGlobalUnreadCount.Succeeded.name] = function(p2, p3)
		if p3.responseBody and p3.responseBody.status == "success" then
			return 0
		end

		return p2
	end
})
