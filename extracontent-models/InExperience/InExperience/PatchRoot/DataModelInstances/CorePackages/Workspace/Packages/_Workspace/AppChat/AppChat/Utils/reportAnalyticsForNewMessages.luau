local Players = game:GetService("Players")
local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Analytics = require(parent.Analytics)
local analytics = Analytics.Analytics
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local RoactChatAnalytics = require(AppChat.LegacyAnalytics.RoactChatAnalytics)
local filterForLinksWithPolicy = require(AppChat.Components.ChatConversation.Utils.filterForLinksWithPolicy)
local EnumMessageTypes = require(AppChat.Components.ChatConversation.EnumMessageTypes)

return function(p, p2, object)
	if not object then
		local v = analytics.new(RbxAnalyticsService)
		local userId = tostring(Players.LocalPlayer.UserId)
		object = RoactChatAnalytics.new(v, userId)
	end

	if p.messageType == EnumMessageTypes.PlainText then
		for _, v in pairs(filterForLinksWithPolicy(p)) do
			if v.messageType == EnumMessageTypes.Link then
				object:loadGameLinkCardInChat(p2, v.placeId)
			end
		end
	elseif p.messageType == EnumMessageTypes.Link then
		object:loadGameLinkCardInChat(p2, p.gameLink.universeId)
	end
end
