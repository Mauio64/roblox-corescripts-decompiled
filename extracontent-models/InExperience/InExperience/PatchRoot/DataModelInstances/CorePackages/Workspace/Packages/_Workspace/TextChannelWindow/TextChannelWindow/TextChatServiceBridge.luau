local parent = script:FindFirstAncestor("TextChannelWindow").Parent

local SharedFlags = require(parent.SharedFlags)
local TextChannelWindowAnalytics = require(script.Parent.TextChannelWindowAnalytics)
local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local TextChannelWindowPerfTracker = ChatUIPrimitives.Telemetry.TextChannelWindowPerfTracker
local TextChatServiceIntegration = require(script.Parent.TextChatServiceIntegration)
require(script.Parent.createChannelMessagesStore)
local isTextSourceMuted = require(script.Parent.isTextSourceMuted)

local getFFlagExpChatProtectedChatInternalAPIs = SharedFlags.getFFlagExpChatProtectedChatInternalAPIs
local getFFlagExpChatUseChatMuteStore = require(script.Parent.getFFlagExpChatUseChatMuteStore)

local function getMessageStatus(p): string
	local status = p.Status

	if status == Enum.TextChatMessageStatus.Success then
		return "success"
	end

	if status == Enum.TextChatMessageStatus.TextFilterFailed then
		return "filter_failed"
	end

	if status == Enum.TextChatMessageStatus.Floodchecked then
		return "floodchecked"
	end

	if status == Enum.TextChatMessageStatus.InvalidPrivacySettings then
		return "invalid_privacy_settings"
	end

	if status == Enum.TextChatMessageStatus.InvalidTextChannelPermissions then
		return "invalid_permissions"
	end

	if status == Enum.TextChatMessageStatus.MessageTooLong then
		return "message_too_long"
	end

	if status == Enum.TextChatMessageStatus.ModerationTimeout then
		return "moderation_timeout"
	end

	return "unknown"
end

local function createTextChatServiceBridge(folder, p: string, data)
	local v = {}

	local function connectChannel(textChannel)
		if v[textChannel] then
			return
		end

		local v2 = textChannel.Name == "RBXSystem"
		local connections = { (textChannel.MessageReceived:Connect(function(p2)
				if
					not (p2.TextSource or v2)
					or getFFlagExpChatUseChatMuteStore() and p2.TextSource and isTextSourceMuted(p2.TextSource)
				then
					return
				end

				local mapTextChatMessage = TextChatServiceIntegration.mapTextChatMessage(p2, p)

				if mapTextChatMessage.content == "" then
					data.removeMessage(textChannel, mapTextChatMessage.messageId)
				else
					data.upsertMessage(textChannel, mapTextChatMessage)
				end

				if p2.TextSource and tostring(p2.TextSource.UserId) ~= p then
					TextChannelWindowPerfTracker.startReceiveInterval(p2.MessageId, textChannel.Name)
				end

				TextChannelWindowAnalytics.emit(TextChannelWindowAnalytics.Counters.MessageReceived, {
					status = getMessageStatus(p2),
					target_text_channel_category = TextChannelWindowAnalytics.getChannelCategory(textChannel.Name)
				})
			end)) }
		v[textChannel] = connections
		table.insert(connections, textChannel.Destroying:Connect(function()
			for _, connection in connections do
				connection:Disconnect()
			end

			v[textChannel] = nil
		end))

		textChannel.ChildRemoved:Connect(function(textSource)
			if textSource:IsA("TextSource") and tostring(textSource.UserId) == p then
				data.clearChannel(textChannel)
			end
		end)
	end

	folder.SendingMessage:Connect(function(data2)
		if not data2.TextSource then
			return
		end

		local v2

		if getFFlagExpChatProtectedChatInternalAPIs() then
			v2 = data2.TextInternal
		else
			v2 = data2.Text
		end

		if v2 == "" then
			return
		end

		local textChannel = data2.TextChannel

		if not textChannel then
			return
		end

		TextChannelWindowPerfTracker.startSendInterval(data2.MessageId, textChannel.Name)
		local mapSendingMessage = TextChatServiceIntegration.mapSendingMessage(data2, p)
		data.insertIfAbsent(textChannel, mapSendingMessage)
	end)

	for _, textChannel in folder:GetDescendants() do
		if textChannel:IsA("TextChannel") then
			connectChannel(textChannel)
		end
	end

	folder.DescendantAdded:Connect(function(textChannel)
		if textChannel:IsA("TextChannel") then
			connectChannel(textChannel)
		end
	end)
	folder.DescendantRemoving:Connect(function(textChannel)
		if textChannel:IsA("TextChannel") then
			data.removeChannelEntry(textChannel)
		end
	end)
end

return createTextChatServiceBridge
