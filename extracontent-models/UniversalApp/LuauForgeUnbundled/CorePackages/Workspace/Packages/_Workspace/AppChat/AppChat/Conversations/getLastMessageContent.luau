local LocalizationService = game:GetService("LocalizationService")

local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getDeepValue")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Http").Url
local localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppLocales").Localization

local EnumMessageTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/EnumMessageTypes")
local MessageModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/MessageModel")

local getFFlagEnableSocialCards = SharedFlags.GetFFlagEnableSocialCards

local function getMessageContent(data)
	if data.previewContent then
		return data.previewContent
	end

	if data.visibility == MessageModel.VisibilityTypes.Hidden then
		return localization.new(LocalizationService.RobloxLocaleId):Format("Feature.Chat.Label.MessageNotAvailable")
	end

	if data.messageType == EnumMessageTypes.Link then
		return url.WWW_URL .. "games/" .. data.gameLink.universeId
	end

	if getFFlagEnableSocialCards() and data.messageType == EnumMessageTypes.System and data.cards then
		return data.cards[1] and data.cards[1].alt_text
	end

	return (tostring(data.content))
end

return function(p2)
	local v5 = getDeepValue(p2, "messages.values")
	local previewMessageId = p2.previewMessageId

	if previewMessageId and v5 and v5[previewMessageId] then
		return getMessageContent(v5[previewMessageId])
	end

	if p2.previewContent then
		return p2.previewContent
	end

	return nil
end
