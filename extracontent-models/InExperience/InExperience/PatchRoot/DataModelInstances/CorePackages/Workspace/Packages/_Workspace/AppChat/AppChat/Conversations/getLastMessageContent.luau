local LocalizationService = game:GetService("LocalizationService")

local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local getDeepValue = require(AppChat.Utils.getDeepValue)
local SharedFlags = require(parent.SharedFlags)
local Http = require(parent.Http)
local Url = Http.Url
local RobloxAppLocales = require(parent.RobloxAppLocales)
local Localization = RobloxAppLocales.Localization

local EnumMessageTypes = require(AppChat.Components.ChatConversation.EnumMessageTypes)
local MessageModel = require(AppChat.Models.MessageModel)

local GetFFlagEnableSocialCards = SharedFlags.GetFFlagEnableSocialCards

local function getMessageContent(data)
	if data.previewContent then
		return data.previewContent
	end

	if data.visibility == MessageModel.VisibilityTypes.Hidden then
		return Localization.new(LocalizationService.RobloxLocaleId):Format("Feature.Chat.Label.MessageNotAvailable")
	end

	if data.messageType == EnumMessageTypes.Link then
		return Url.WWW_URL .. "games/" .. data.gameLink.universeId
	end

	if GetFFlagEnableSocialCards() and data.messageType == EnumMessageTypes.System and data.cards then
		return data.cards[1] and data.cards[1].alt_text
	end

	return (tostring(data.content))
end

return function(p)
	local deepValue = getDeepValue(p, "messages.values")
	local previewMessageId = p.previewMessageId

	if previewMessageId and deepValue and deepValue[previewMessageId] then
		return getMessageContent(deepValue[previewMessageId])
	end

	return if p.previewContent then p.previewContent else nil
end
