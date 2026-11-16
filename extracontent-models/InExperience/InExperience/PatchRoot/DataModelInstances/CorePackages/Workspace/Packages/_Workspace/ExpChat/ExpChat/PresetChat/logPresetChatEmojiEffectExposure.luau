local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local ExpChatShared = require(parent.ExpChatShared)
local FriendsChatTabName = require(parent.FriendsChat.FriendsChatTabName)

local SocialExperiments = require(parent.SocialExperiments)
local ExpChatPresetChatEmojiEffectExperimentation = SocialExperiments.ExpChatPresetChatEmojiEffectExperimentation

local GetChatStatusStore = require(ExpChat.Stores.GetChatStatusStore)
local isUserChatEnabled = require(ExpChat.isUserChatEnabled)
local isMessageForOpenChannel = require(ExpChat.isMessageForOpenChannel)
local selectSelectedTabName = require(ExpChat.selectSelectedTabName)
local getMessageSettings = require(ExpChat.ChatWindow.Helpers.getMessageSettings)
local getMessageText = require(ExpChat.ChatWindow.Helpers.getMessageText)
require(ExpChat.BubbleChat.Helpers.getBubbleChatDisplayText)
local isBorderlessBubbleChatMessage = require(ExpChat.BubbleChat.Helpers.isBorderlessBubbleChatMessage)

local MessageEffect = require(ExpChat.MessageEffects.MessageEffect)
local getMessageEffects = require(ExpChat.MessageEffects.getMessageEffects)

local function isShownInChatWindow(p)
	local store = ExpChatShared.context.store

	if store == nil then
		return false
	end

	local state = store:getState()

	if not (state.ChatVisibility.isChatWindowEnabled.value and selectSelectedTabName(state) ~= FriendsChatTabName) then
		return false
	end

	return isMessageForOpenChannel(state, { TextChannel = p.textChannel }, p.channelNameOverride)
end

local function isChatWindowEnlargeMessage(p): boolean -- 1 equivalent call inferred from this helper
	local messageSettings = getMessageSettings(p)
	local messageText = getMessageText(
		messageSettings.useTranslation,
		messageSettings.translation,
		messageSettings.text
	)
	return table.find(getMessageEffects(messageText), MessageEffect.ChatWindowEnlarge) ~= nil
end

local function logPresetChatEmojiEffectExposure(p)
	if not isUserChatEnabled(GetChatStatusStore(false).getChatStatus(false)) then
		return
	end

	if p.isVisibleInChatWindow and isShownInChatWindow(p) then
		if isChatWindowEnlargeMessage(p) then -- inferred equivalent call
			ExpChatPresetChatEmojiEffectExperimentation.logExposure()
		elseif p.isVisibleInBubbleChat and isBorderlessBubbleChatMessage(p) then
			ExpChatPresetChatEmojiEffectExperimentation.logExposure()
		end
	elseif p.isVisibleInBubbleChat and isBorderlessBubbleChatMessage(p) then
		ExpChatPresetChatEmojiEffectExperimentation.logExposure()
	end
end

return logPresetChatEmojiEffectExposure
