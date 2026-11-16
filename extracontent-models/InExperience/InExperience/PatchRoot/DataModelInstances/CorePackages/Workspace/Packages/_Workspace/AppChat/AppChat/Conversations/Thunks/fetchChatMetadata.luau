local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local SetAppLoaded = require(AppChat.Actions.SetAppLoaded)
local GetAppLoadedStore = require(AppChat.Stores.GetAppLoadedStore)
local FFlagAppChatUseSignalsForAppLoaded = require(AppChat.Flags.FFlagAppChatUseSignalsForAppLoaded)
local RoactChatAnalytics = require(AppChat.LegacyAnalytics.RoactChatAnalytics)
local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)

local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Analytics = require(parent.Analytics)
local analytics = Analytics.Analytics.new(RbxAnalyticsService)

local AppChatNetworking = require(parent.AppChatNetworking)

return function()
	v:info("Fetching chat metadata...")

	return function(object)
		local localUserId = object:getState().LocalUserId

		return object:dispatch(AppChatNetworking.rodux.GetMetadata.API()):andThen(function(p)
			local isChatEnabled = p.responseBody.isChatEnabled

			if isChatEnabled then
				v:info("Chat is enabled and privacy settings allow chat")

				if localUserId then
					RoactChatAnalytics.new(analytics, localUserId):userLoadedChat()
				end
			else
				v:info("Chat is disabled or privacy settings do not allow chat")
			end

			if FFlagAppChatUseSignalsForAppLoaded then
				GetAppLoadedStore(false).setAppLoaded(isChatEnabled)
				return isChatEnabled
			end

			object:dispatch(SetAppLoaded(isChatEnabled))

			return isChatEnabled
		end):catch(function(p)
			v:warning("FetchChatData failed with error: {}", (tostring(p)))
		end)
	end
end
