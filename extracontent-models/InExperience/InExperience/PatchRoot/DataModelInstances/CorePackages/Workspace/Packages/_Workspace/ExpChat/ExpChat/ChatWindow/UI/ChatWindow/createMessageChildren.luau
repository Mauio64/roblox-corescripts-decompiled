local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local React = require(parent.React)
local llama = require(parent.llama)
local dictionary = llama.Dictionary

local ui = script:FindFirstAncestor("UI")
local TranslatedTextMessage = require(ui.TranslatedTextMessage)

local UserProfiles = require(parent.UserProfiles)
local v = UserProfiles.Stores.VerifiedBadgeDisplayStore.get()

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableVerifiedBadgeStore = SharedFlags.FFlagEnableVerifiedBadgeStore
local engineFeature = game:GetEngineFeature("EnableInExpChatRewrite")
local FFlagExpChatRewriteInline = require(ExpChat.Flags.FFlagExpChatRewriteInline)

local function createMessageChildren(props)
	local messages = props.messages
	local verifiedUserIds = props.verifiedUserIds
	local textTransparency = props.textTransparency
	local transparencyValue = props.transparencyValue
	local chatWindowSettings = props.chatWindowSettings
	local showTranslationButton = props.showTranslationButton
	local isSpatialUIEnabled = props.isSpatialUIEnabled
	local onTextMessageLabelButtonActivated = props.onTextMessageLabelButtonActivated

	local mapped = dictionary.map(messages, function(props2, layoutOrder)
		if not props2.isVisibleInChatWindow then
			return nil, nil
		end

		local isUserVerified

		if FFlagEnableVerifiedBadgeStore then
			if props2.userId then
				isUserVerified = v.isBadgeVisible((tonumber(props2.userId)))
			else
				isUserVerified = false
			end
		elseif props2.userId then
			isUserVerified = dictionary.has(verifiedUserIds, props2.userId)
		else
			isUserVerified = false
		end

		local createElement = React.createElement
		local v2 = {
			message = props2,
			LayoutOrder = layoutOrder,
			isUserVerified = isUserVerified,
			textTransparency = textTransparency,
			transparencyValue = nil,
			onTextMessageLabelButtonActivated = nil,
			chatWindowSettings = nil,
			showTranslationButton = nil,
			isSpatialUIEnabled = nil,
			onToggle = 0,
			chatWindowTransparencyBindable = 0
		}
		local transparencyValue2

		if engineFeature then
			transparencyValue2 = transparencyValue
		end

		v2.transparencyValue = transparencyValue2
		v2.onTextMessageLabelButtonActivated = onTextMessageLabelButtonActivated
		v2.chatWindowSettings = chatWindowSettings
		v2.showTranslationButton = showTranslationButton
		v2.isSpatialUIEnabled = isSpatialUIEnabled
		function v2.onToggle() end

		local chatWindowTransparencyBindable

		if FFlagExpChatRewriteInline then
			chatWindowTransparencyBindable = transparencyValue
		end

		v2.chatWindowTransparencyBindable = chatWindowTransparencyBindable
		return createElement(TranslatedTextMessage, v2), props2.messageId
	end)

	mapped["$layout"] = React.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	return mapped
end

return createMessageChildren
