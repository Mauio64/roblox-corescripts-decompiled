local Parent = script:FindFirstAncestor("TextChannelWindow").Parent
local SharedFlags = require(Parent.SharedFlags)
local TextChannelWindowAnalytics = require(script.Parent.TextChannelWindowAnalytics)
local TextChannelWindowPerfTracker = require(Parent.ChatUIPrimitives).Telemetry.TextChannelWindowPerfTracker
local TextChatServiceIntegration = require(script.Parent.TextChatServiceIntegration)

require(script.Parent.createChannelMessagesStore)

local isTextSourceMuted = require(script.Parent.isTextSourceMuted)
local getFFlagExpChatProtectedChatInternalAPIs = SharedFlags.getFFlagExpChatProtectedChatInternalAPIs
local getFFlagExpChatUseChatMuteStore = require(script.Parent.getFFlagExpChatUseChatMuteStore)

local function getMessageStatus(p1) -- line: 26
	local Status = p1.Status

	if Status == Enum.TextChatMessageStatus.Success then
		return "success"
	end

	if Status == Enum.TextChatMessageStatus.TextFilterFailed then
		return "filter_failed"
	end

	if Status == Enum.TextChatMessageStatus.Floodchecked then
		return "floodchecked"
	end

	if Status == Enum.TextChatMessageStatus.InvalidPrivacySettings then
		return "invalid_privacy_settings"
	end

	if Status == Enum.TextChatMessageStatus.InvalidTextChannelPermissions then
		return "invalid_permissions"
	end

	if Status == Enum.TextChatMessageStatus.MessageTooLong then
		return "message_too_long"
	end

	if Status == Enum.TextChatMessageStatus.ModerationTimeout then
		return "moderation_timeout"
	end

	return "unknown"
end
local function createTextChatServiceBridge(p2, s1: string, p3) -- line: 47
	-- upvalues: getFFlagExpChatUseChatMuteStore (copy), isTextSourceMuted (copy), TextChatServiceIntegration (copy), TextChannelWindowPerfTracker (copy), TextChannelWindowAnalytics (copy), getMessageStatus (copy), getFFlagExpChatProtectedChatInternalAPIs (copy)
	local function connectChannel(p4) -- line: 52
		-- upvalues: getFFlagExpChatUseChatMuteStore (copy), isTextSourceMuted (copy), TextChatServiceIntegration (copy), s1 (copy), p3 (copy), TextChannelWindowPerfTracker (copy), TextChannelWindowAnalytics (copy), getMessageStatus (copy)
		local v21 = p4.Name == "RBXSystem"

		p4.MessageReceived:Connect(function(p5) -- line: 54
			-- upvalues: v21 (copy), getFFlagExpChatUseChatMuteStore (copy), isTextSourceMuted (copy), TextChatServiceIntegration (copy), s1 (copy), p3 (copy), p4 (copy), TextChannelWindowPerfTracker (copy), TextChannelWindowAnalytics (copy), getMessageStatus (copy)
			if not p5.TextSource and not v21 then
				return
			end

			if getFFlagExpChatUseChatMuteStore() and p5.TextSource and isTextSourceMuted(p5.TextSource) then
				return
			end

			local v30 = TextChatServiceIntegration.mapTextChatMessage(p5, s1)

			if v30.content == "" then
				p3.removeMessage(p4, v30.messageId)
			else
				p3.upsertMessage(p4, v30)
			end

			if p5.TextSource and tostring(p5.TextSource.UserId) ~= s1 then
				TextChannelWindowPerfTracker.startReceiveInterval(p5.MessageId, p4.Name)
			end

			TextChannelWindowAnalytics.emit(TextChannelWindowAnalytics.Counters.MessageReceived, {
				status = getMessageStatus(p5),
				target_text_channel_category = TextChannelWindowAnalytics.getChannelCategory(p4.Name)
			})
		end)
	end

	p2.SendingMessage:Connect(function(message) -- line: 81
		-- upvalues: getFFlagExpChatProtectedChatInternalAPIs (copy), TextChannelWindowPerfTracker (copy), TextChatServiceIntegration (copy), s1 (copy), p3 (copy)
		if not message.TextSource then
			return
		end

		if ((if not getFFlagExpChatProtectedChatInternalAPIs() then message.Text else message.TextInternal)) == "" then
			return
		end

		local TextChannel = message.TextChannel

		if not TextChannel then
			return
		end

		TextChannelWindowPerfTracker.startSendInterval(message.MessageId, TextChannel.Name)

		local v24 = TextChatServiceIntegration.mapSendingMessage(message, s1)

		p3.insertIfAbsent(TextChannel, v24)
	end)

	for _, descendant in p2:GetDescendants() do
		if descendant:IsA("TextChannel") then
			local v19 = descendant.Name == "RBXSystem"

			descendant.MessageReceived:Connect(function(p6) -- line: 54
				-- upvalues: v19 (copy), getFFlagExpChatUseChatMuteStore (copy), isTextSourceMuted (copy), TextChatServiceIntegration (copy), s1 (copy), p3 (copy), descendant (copy), TextChannelWindowPerfTracker (copy), TextChannelWindowAnalytics (copy), getMessageStatus (copy)
				if not p6.TextSource and not v19 then
					return
				end

				if getFFlagExpChatUseChatMuteStore() and p6.TextSource and isTextSourceMuted(p6.TextSource) then
					return
				end

				local v26 = TextChatServiceIntegration.mapTextChatMessage(p6, s1)

				if v26.content == "" then
					p3.removeMessage(descendant, v26.messageId)
				else
					p3.upsertMessage(descendant, v26)
				end

				if p6.TextSource and tostring(p6.TextSource.UserId) ~= s1 then
					TextChannelWindowPerfTracker.startReceiveInterval(p6.MessageId, descendant.Name)
				end

				TextChannelWindowAnalytics.emit(TextChannelWindowAnalytics.Counters.MessageReceived, {
					status = getMessageStatus(p6),
					target_text_channel_category = TextChannelWindowAnalytics.getChannelCategory(descendant.Name)
				})
			end)
		end
	end

	p2.DescendantAdded:Connect(function(descendant) -- line: 106
		-- upvalues: getFFlagExpChatUseChatMuteStore (copy), isTextSourceMuted (copy), TextChatServiceIntegration (copy), s1 (copy), p3 (copy), TextChannelWindowPerfTracker (copy), TextChannelWindowAnalytics (copy), getMessageStatus (copy)
		if descendant:IsA("TextChannel") then
			local v28 = descendant.Name == "RBXSystem"

			descendant.MessageReceived:Connect(function(p7) -- line: 54
				-- upvalues: v28 (copy), getFFlagExpChatUseChatMuteStore (copy), isTextSourceMuted (copy), TextChatServiceIntegration (copy), s1 (copy), p3 (copy), descendant (copy), TextChannelWindowPerfTracker (copy), TextChannelWindowAnalytics (copy), getMessageStatus (copy)
				if not p7.TextSource and not v28 then
					return
				end

				if getFFlagExpChatUseChatMuteStore() and p7.TextSource and isTextSourceMuted(p7.TextSource) then
					return
				end

				local v32 = TextChatServiceIntegration.mapTextChatMessage(p7, s1)

				if v32.content == "" then
					p3.removeMessage(descendant, v32.messageId)
				else
					p3.upsertMessage(descendant, v32)
				end

				if p7.TextSource and tostring(p7.TextSource.UserId) ~= s1 then
					TextChannelWindowPerfTracker.startReceiveInterval(p7.MessageId, descendant.Name)
				end

				TextChannelWindowAnalytics.emit(TextChannelWindowAnalytics.Counters.MessageReceived, {
					status = getMessageStatus(p7),
					target_text_channel_category = TextChannelWindowAnalytics.getChannelCategory(descendant.Name)
				})
			end)
		end
	end)
end

return createTextChatServiceBridge
