local ExpChat = script:FindFirstAncestor("ExpChat")
local Analytics = require(ExpChat.Parent.ExpChatShared).Analytics

local function getCounterName(p1) -- line: 5
	if p1.Status == Enum.TextChatMessageStatus.Success then
		local TextChannel = p1.TextChannel

		if TextChannel then
			local TextChannelName = TextChannel.Name

			if string.find(TextChannelName, "^RBX") == nil then
				return "expChatMessageReceivedSuccessCustom"
			end

			if TextChannelName == "RBXGeneral" then
				return "expChatMessageReceivedSuccessGeneral"
			end

			if TextChannelName == "RBXSystem" then
				return "expChatMessageReceivedSuccessSystem"
			end

			if string.find(TextChannelName, "^RBXWhisper") then
				return "expChatMessageReceivedSuccessWhisper"
			end

			if string.find(TextChannelName, "^RBXTeam") then
				return "expChatMessageReceivedSuccessTeam"
			end

			return "expChatMessageReceivedSuccessCustom"
		end
	end

	if p1.Status == Enum.TextChatMessageStatus.Unknown then
		return "expChatMessageReceivedUnknown"
	end

	if p1.Status == Enum.TextChatMessageStatus.InvalidTextChannelPermissions then
		return "expChatMessageReceivedInvalidTextChannelPermissions"
	end

	if p1.Status == Enum.TextChatMessageStatus.InvalidPrivacySettings then
		return "expChatMessageReceivedInvalidPrivacySettings"
	end

	if p1.Status == Enum.TextChatMessageStatus.TextFilterFailed then
		return "expChatMessageReceivedTextFilterFailed"
	end

	if p1.Status == Enum.TextChatMessageStatus.Floodchecked then
		return "expChatMessageReceivedFloodchecked"
	end

	if p1.Status == Enum.TextChatMessageStatus.MessageTooLong then
		return "expChatMessageReceivedMessageTooLong"
	end

	if p1.Status == Enum.TextChatMessageStatus.ModerationTimeout then
		return "expChatMessageReceivedModerationTimeout"
	end

	return nil
end

return function(n1: number, p2) -- line: 47
	-- upvalues: getCounterName (copy), Analytics (copy)
	local TextSource = p2.TextSource

	if TextSource and n1 == TextSource.UserId then
		local v10 = getCounterName(p2)

		if v10 then
			Analytics.reportCounter(v10)
		end
	end
end
