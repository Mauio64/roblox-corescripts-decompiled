local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local Dictionary = require(ExpChatParent.llama).Dictionary
local UI = script:FindFirstAncestor("UI")
local TranslatedTextMessage = require(UI.TranslatedTextMessage)
local v7 = require(ExpChatParent.UserProfiles).Stores.VerifiedBadgeDisplayStore.get()
local FFlagEnableVerifiedBadgeStore = require(ExpChatParent.SharedFlags).FFlagEnableVerifiedBadgeStore
local EngineFeature = game:GetEngineFeature("EnableInExpChatRewrite")
local FFlagExpChatRewriteInline = require(ExpChat.Flags.FFlagExpChatRewriteInline)

local function createMessageChildren(t1: {[any]: any}) -- line: 40
	-- upvalues: Dictionary (copy), FFlagEnableVerifiedBadgeStore (copy), v7 (copy), React (copy), TranslatedTextMessage (copy), EngineFeature (copy), FFlagExpChatRewriteInline (copy)
	local messages = t1.messages
	local verifiedUserIds = t1.verifiedUserIds
	local textTransparency = t1.textTransparency
	local transparencyValue = t1.transparencyValue
	local chatWindowSettings = t1.chatWindowSettings
	local showTranslationButton = t1.showTranslationButton
	local isSpatialUIEnabled = t1.isSpatialUIEnabled
	local onTextMessageLabelButtonActivated = t1.onTextMessageLabelButtonActivated
	local v21 = Dictionary.map(messages, function(p1, p2) -- line: 50
		-- upvalues: FFlagEnableVerifiedBadgeStore (copy), v7 (copy), Dictionary (copy), verifiedUserIds (copy), React (copy), TranslatedTextMessage (copy), textTransparency (copy), EngineFeature (copy), transparencyValue (copy), onTextMessageLabelButtonActivated (copy), chatWindowSettings (copy), showTranslationButton (copy), isSpatialUIEnabled (copy), FFlagExpChatRewriteInline (copy)
		if p1.isVisibleInChatWindow then
			local v24 = if not FFlagEnableVerifiedBadgeStore then not not p1.userId and Dictionary.has(verifiedUserIds, p1.userId) else not not p1.userId and v7.isBadgeVisible((tonumber(p1.userId)))

			return React.createElement(TranslatedTextMessage, {
				message = p1,
				LayoutOrder = p2,
				isUserVerified = v24,
				textTransparency = textTransparency,
				transparencyValue = if not EngineFeature then nil else transparencyValue,
				onTextMessageLabelButtonActivated = onTextMessageLabelButtonActivated,
				chatWindowSettings = chatWindowSettings,
				showTranslationButton = showTranslationButton,
				isSpatialUIEnabled = isSpatialUIEnabled,
				onToggle = function() -- line: 70
				end,
				chatWindowTransparencyBindable = if not FFlagExpChatRewriteInline then nil else transparencyValue
			}), p1.messageId
		end

		return nil, nil
	end)

	v21["$layout"] = React.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	return v21
end

return createMessageChildren
