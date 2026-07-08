local Players = game:GetService("Players")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Analytics = require(AppChatParent.Analytics).Analytics
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local RoactChatAnalytics = require(AppChat.LegacyAnalytics.RoactChatAnalytics)
local filterForLinksWithPolicy = require(AppChat.Components.ChatConversation.Utils.filterForLinksWithPolicy)
local EnumMessageTypes = require(AppChat.Components.ChatConversation.EnumMessageTypes)

return function(p1, p2, p3) -- line: 13
	-- upvalues: Analytics (copy), RbxAnalyticsService (copy), Players (copy), RoactChatAnalytics (copy), EnumMessageTypes (copy), filterForLinksWithPolicy (copy)
	if p3 then
	else
		local v12 = Analytics.new(RbxAnalyticsService)
		local str = tostring(Players.LocalPlayer.UserId)

		p3 = RoactChatAnalytics.new(v12, str)
	end

	if p1.messageType == EnumMessageTypes.PlainText then
		for _, v in pairs(filterForLinksWithPolicy(p1)) do
			if v.messageType == EnumMessageTypes.Link then
				p3:loadGameLinkCardInChat(p2, v.placeId)
			end
		end

		return
	end

	if p1.messageType == EnumMessageTypes.Link then
		p3:loadGameLinkCardInChat(p2, p1.gameLink.universeId)
	end
end
