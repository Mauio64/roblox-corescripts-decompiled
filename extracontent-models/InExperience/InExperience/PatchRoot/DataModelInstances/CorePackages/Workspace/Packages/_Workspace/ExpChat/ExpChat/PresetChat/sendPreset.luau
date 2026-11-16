local TextChatService = game:GetService("TextChatService")

local ExpChat = script:FindFirstAncestor("ExpChat")
local FFlagExpChatUniverseChatPresetEnabled = require(ExpChat.Flags.FFlagExpChatUniverseChatPresetEnabled)

local function getRBXGeneralChannel()
	local rbxGeneral = TextChatService:FindFirstChild("RBXGeneral", true)

	if rbxGeneral and rbxGeneral:IsA("TextChannel") then
		return rbxGeneral
	end

	return nil
end

local function sendPreset(p: string, textChannel)
	if textChannel ~= nil and textChannel.Name ~= "RBXGeneral" then
		textChannel = TextChatService:FindFirstChild("RBXGeneral", true)

		if not (textChannel and textChannel:IsA("TextChannel")) then
			textChannel = nil
		end
	end

	if textChannel then
		return pcall(function()
			textChannel:SendPresetAsync(p)
		end) and "Sent" or "SendFailed"
	end

	if FFlagExpChatUniverseChatPresetEnabled then
		return pcall(function()
			TextChatService:SendUniverseChatPresetAsync(p)
		end) and "Sent" or "SendFailed"
	end

	return "NoChannel"
end

return sendPreset
