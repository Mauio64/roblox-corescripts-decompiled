local SetAppLoaded = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Actions/SetAppLoaded")
local GetAppLoadedStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetAppLoadedStore")
local FFlagAppChatUseSignalsForAppLoaded = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseSignalsForAppLoaded")
local RoactChatAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/LegacyAnalytics/RoactChatAnalytics")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("fetchChatMetadata")

local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Analytics").Analytics.new(RbxAnalyticsService)

local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")

return function()
	v5:info("Fetching chat metadata...")

	return function(object)
		local localUserId = object:getState().LocalUserId

		return object:dispatch(AppChatNetworking.rodux.GetMetadata.API()):andThen(function(p2)
			local isChatEnabled = p2.responseBody.isChatEnabled

			if isChatEnabled then
				v5:info("Chat is enabled and privacy settings allow chat")

				if localUserId then
					RoactChatAnalytics.new(analytics, localUserId):userLoadedChat()
				end
			else
				v5:info("Chat is disabled or privacy settings do not allow chat")
			end

			if FFlagAppChatUseSignalsForAppLoaded then
				GetAppLoadedStore(false).setAppLoaded(isChatEnabled)
				return isChatEnabled
			end

			object:dispatch(SetAppLoaded(isChatEnabled))

			return isChatEnabled
		end):catch(function(p2)
			v5:warning("FetchChatData failed with error: {}", (tostring(p2)))
		end)
	end
end
