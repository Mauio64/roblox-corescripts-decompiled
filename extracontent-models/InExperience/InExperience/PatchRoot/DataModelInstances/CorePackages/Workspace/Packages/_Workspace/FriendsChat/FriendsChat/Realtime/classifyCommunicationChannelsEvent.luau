local parent = script:FindFirstAncestor("FriendsChat").Parent

local CommunicationChannelsTypes = require(parent.AppChat.CommunicationChannelsTypes)

local v = { kind = "ignore", channelId = nil }

local v2 = {
	MessageCreated = "fetchMessage",
	SystemMessageCreated = "fetchMessage",
	ChannelDeleted = "removeConversation",
	RemovedFromChannel = "removeConversation",
	ChannelArchived = "removeConversation",
	ChannelUpdated = "fetchConversationDetails",
	ParticipantsAdded = "fetchConversationDetails",
	ParticipantsRemoved = "fetchConversationDetails",
	ChannelMetadataUpdated = "fetchConversationDetails",
	AddedToChannel = "fetchConversationDetails",
	ChannelCreated = "fetchConversationDetails",
	ChannelUnarchived = "fetchConversationDetails",
	ChannelMarkedRead = "fetchConversationDetails"
}

local function classifyCommunicationChannelsEvent(data)
	if not (data ~= nil and data.ChannelVertical == "PlatformChat" and table.find(
		CommunicationChannelsTypes.ChannelTypeAllowlist,
		data.ChannelType
	) ~= nil) then
		return v
	end

	local kind = v2[data.Type]

	if kind == nil then
		return v
	end

	local channelId = data.ChannelId

	if channelId == nil or channelId == "" then
		return v
	end

	return { kind = kind, channelId = channelId }
end

return classifyCommunicationChannelsEvent
