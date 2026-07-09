local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local SetAppLoaded = require(AppChat.Actions.SetAppLoaded)
local RoactChatAnalytics = require(AppChat.LegacyAnalytics.RoactChatAnalytics)
local v5 = require(AppChat.Logger):new(script.Name)
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local v7 = require(AppChatParent.Analytics).Analytics.new(RbxAnalyticsService)
local AppChatNetworking = require(AppChatParent.AppChatNetworking)

return function() -- line: 13
	-- upvalues: v5 (copy), AppChatNetworking (copy), RoactChatAnalytics (copy), v7 (copy), SetAppLoaded (copy)
	v5:info("Fetching chat metadata...")

	return function(p1) -- line: 16
		-- upvalues: AppChatNetworking (copy), v5 (copy), RoactChatAnalytics (copy), v7 (copy), SetAppLoaded (copy)
		local LocalUserId = p1:getState().LocalUserId

		return p1:dispatch(AppChatNetworking.rodux.GetMetadata.API()):andThen(function(p2) -- line: 20
			-- upvalues: v5 (copy), LocalUserId (copy), RoactChatAnalytics (copy), v7 (copy), p1 (copy), SetAppLoaded (copy)
			local isChatEnabled = p2.responseBody.isChatEnabled

			if isChatEnabled then
				v5:info("Chat is enabled and privacy settings allow chat")

				if LocalUserId then
					RoactChatAnalytics.new(v7, LocalUserId):userLoadedChat()
				end
			else
				v5:info("Chat is disabled or privacy settings do not allow chat")
			end

			p1:dispatch(SetAppLoaded(isChatEnabled))

			return isChatEnabled
		end):catch(function(p3) -- line: 37
			-- upvalues: v5 (copy)
			v5:warning("FetchChatData failed with error: {}", (tostring(p3)))
		end)
	end
end
