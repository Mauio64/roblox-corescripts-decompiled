local Players = game:GetService("Players")

local analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Analytics").Analytics
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local RoactChatAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/LegacyAnalytics/RoactChatAnalytics")
local filterForLinksWithPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Utils/filterForLinksWithPolicy")
local EnumMessageTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/EnumMessageTypes")

return function(p2, p3, object)
	if not object then
		local v5 = analytics.new(RbxAnalyticsService)
		local userId = tostring(Players.LocalPlayer.UserId)
		object = RoactChatAnalytics.new(v5, userId)
	end

	if p2.messageType == EnumMessageTypes.PlainText then
		for k, v5 in pairs(filterForLinksWithPolicy(p2)) do
			if v5.messageType == EnumMessageTypes.Link then
				object:loadGameLinkCardInChat(p3, v5.placeId)
			end
		end
	elseif p2.messageType == EnumMessageTypes.Link then
		object:loadGameLinkCardInChat(p3, p2.gameLink.universeId)
	end
end
