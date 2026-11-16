local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatShared = require(ExpChat.Parent.ExpChatShared)
local Analytics = ExpChatShared.Analytics

local function getCounterName(p): nil | string
	local textChannel = p.Status == Enum.TextChatMessageStatus.Success and p.TextChannel

	if textChannel then
		local name = textChannel.Name

		if string.find(name, "^RBX") == nil then
			return "expChatMessageReceivedSuccessCustom"
		end

		if name == "RBXGeneral" then
			return "expChatMessageReceivedSuccessGeneral"
		elseif name == "RBXSystem" then
			return "expChatMessageReceivedSuccessSystem"
		end

		if string.find(name, "^RBXWhisper") then
			return "expChatMessageReceivedSuccessWhisper"
		end

		if string.find(name, "^RBXTeam") then
			return "expChatMessageReceivedSuccessTeam"
		end

		return "expChatMessageReceivedSuccessCustom"
	end

	if p.Status == Enum.TextChatMessageStatus.Unknown then
		return "expChatMessageReceivedUnknown"
	end

	if p.Status == Enum.TextChatMessageStatus.InvalidTextChannelPermissions then
		return "expChatMessageReceivedInvalidTextChannelPermissions"
	end

	if p.Status == Enum.TextChatMessageStatus.InvalidPrivacySettings then
		return "expChatMessageReceivedInvalidPrivacySettings"
	end

	if p.Status == Enum.TextChatMessageStatus.TextFilterFailed then
		return "expChatMessageReceivedTextFilterFailed"
	end

	if p.Status == Enum.TextChatMessageStatus.Floodchecked then
		return "expChatMessageReceivedFloodchecked"
	end

	if p.Status == Enum.TextChatMessageStatus.MessageTooLong then
		return "expChatMessageReceivedMessageTooLong"
	end

	if p.Status == Enum.TextChatMessageStatus.ModerationTimeout then
		return "expChatMessageReceivedModerationTimeout"
	end

	return nil
end

return function(p: number, p2)
	local textSource = p2.TextSource

	local v = textSource and p == textSource.UserId and getCounterName(p2)

	if v then
		Analytics.reportCounter(v)
	end
end
