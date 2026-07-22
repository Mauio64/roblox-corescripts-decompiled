local Parent = script:FindFirstAncestor("FriendsChat").Parent
local CommunicationChannelsTypes = require(Parent.AppChat.CommunicationChannelsTypes)
local t1 = {
	kind = "ignore",
	channelId = nil
}
local t2 = {
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

local function classifyCommunicationChannelsEvent(p1) -- line: 66
	-- upvalues: t1 (copy), CommunicationChannelsTypes (copy), t2 (copy)
	if p1 == nil then
		return t1
	end

	if p1.ChannelVertical ~= "PlatformChat" then
		return t1
	end

	if table.find(CommunicationChannelsTypes.ChannelTypeAllowlist, p1.ChannelType) == nil then
		return t1
	end

	local v7 = t2[p1.Type]

	if v7 == nil then
		return t1
	end

	local ChannelId = p1.ChannelId

	if ChannelId == nil or ChannelId == "" then
		return t1
	end

	return {
		kind = v7,
		channelId = ChannelId
	}
end

return classifyCommunicationChannelsEvent
