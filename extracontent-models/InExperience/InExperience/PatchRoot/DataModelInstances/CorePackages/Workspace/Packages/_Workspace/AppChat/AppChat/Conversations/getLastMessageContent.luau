local LocalizationService = game:GetService("LocalizationService")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local getDeepValue = require(AppChat.Utils.getDeepValue)
local SharedFlags = require(AppChatParent.SharedFlags)
local Url = require(AppChatParent.Http).Url
local Localization = require(AppChatParent.RobloxAppLocales).Localization
local EnumMessageTypes = require(AppChat.Components.ChatConversation.EnumMessageTypes)
local MessageModel = require(AppChat.Models.MessageModel)
local GetFFlagEnableSocialCards = SharedFlags.GetFFlagEnableSocialCards

local function getMessageContent(p1) -- line: 18
	-- upvalues: MessageModel (copy), Localization (copy), LocalizationService (copy), EnumMessageTypes (copy), Url (copy), GetFFlagEnableSocialCards (copy)
	if p1.previewContent then
		return p1.previewContent
	end

	if p1.visibility == MessageModel.VisibilityTypes.Hidden then
		return Localization.new(LocalizationService.RobloxLocaleId):Format("Feature.Chat.Label.MessageNotAvailable")
	end

	if p1.messageType == EnumMessageTypes.Link then
		return Url.WWW_URL .. "games/" .. p1.gameLink.universeId
	end

	if GetFFlagEnableSocialCards() and p1.messageType == EnumMessageTypes.System and p1.cards then
		return p1.cards[1] and p1.cards[1].alt_text
	end

	return (tostring(p1.content))
end

return function(p2) -- line: 48
	-- upvalues: getDeepValue (copy), getMessageContent (copy)
	local v14 = getDeepValue(p2, "messages.values")
	local previewMessageId = p2.previewMessageId

	if previewMessageId and (v14 and v14[previewMessageId]) then
		return getMessageContent(v14[previewMessageId])
	end

	if p2.previewContent then
		return p2.previewContent
	end

	return nil
end
