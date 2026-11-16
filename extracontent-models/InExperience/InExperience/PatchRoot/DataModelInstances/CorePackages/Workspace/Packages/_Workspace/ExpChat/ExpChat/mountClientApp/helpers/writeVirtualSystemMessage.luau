local ExpChat = script:FindFirstAncestor("ExpChat")

local Actions = ExpChat.Actions
local MarkChannelUnreadForSystemMessage = require(Actions.MarkChannelUnreadForSystemMessage)
local shouldSuppressUnreadForTabMetadata = require(ExpChat.shouldSuppressUnreadForTabMetadata)

local FFlagExpChatUnreadTabIndicatorV2Window = require(ExpChat.Flags.FFlagExpChatUnreadTabIndicatorV2Window)

local function writeVirtualSystemMessage(data, data2)
	data.messagesStore.addSystemMessage(
		data2.text,
		data2.channelName,
		data2.metadata,
		data2.postProcessMessage,
		data2.isError,
		data2.textChannel
	)

	data.resetTextTransparency(data2.channelName)

	if data.suppressWelcomeMessageTabUnread and shouldSuppressUnreadForTabMetadata(data2.metadata) then
		return
	end

	if data.channelTabsStore then
		data.channelTabsStore.markChannelUnread(data2.channelName)
	elseif FFlagExpChatUnreadTabIndicatorV2Window then
		data.store:dispatch(MarkChannelUnreadForSystemMessage(data2.text, data2.channelName, data2.metadata))
	end
end

return writeVirtualSystemMessage
