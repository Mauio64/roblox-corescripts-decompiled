local TextChatService = game:GetService("TextChatService")

local TextChannelWindow = script:FindFirstAncestor("TextChannelWindow")
local isDirectChatChannel = require(TextChannelWindow.isDirectChatChannel)
local FFlagExpChatUniverseChatPresetEnabled = require(TextChannelWindow.Flags.FFlagExpChatUniverseChatPresetEnabled)

local FFlagExpChatTextChannelWindowQuickWordsNonDirect = require(TextChannelWindow.Flags.FFlagExpChatTextChannelWindowQuickWordsNonDirect)
local Logger = require(TextChannelWindow.Logger)

local function getRBXGeneralChannel()
	local rbxGeneral = TextChatService:FindFirstChild("RBXGeneral", true)

	if rbxGeneral and rbxGeneral:IsA("TextChannel") then
		return rbxGeneral
	end

	return nil
end

local function sendPreset(p: string, textChannel): string
	if FFlagExpChatTextChannelWindowQuickWordsNonDirect then
		if textChannel ~= nil and isDirectChatChannel(textChannel) then
			return "DirectChat"
		end
	elseif textChannel ~= nil and textChannel.Name ~= "RBXGeneral" then
		textChannel = TextChatService:FindFirstChild("RBXGeneral", true)

		if not (textChannel and textChannel:IsA("TextChannel")) then
			textChannel = nil
		end
	end

	if textChannel then
		local success, result = pcall(function()
			textChannel:SendPresetAsync(p)
		end)

		if success then
			return "Sent"
		end

		Logger:warning("SendPresetAsync failed: {}", (tostring(result)))
		return "SendFailed"
	else
		if not FFlagExpChatUniverseChatPresetEnabled then
			return "NoChannel"
		end

		local success, result = pcall(function()
			TextChatService:SendUniverseChatPresetAsync(p)
		end)

		if success then
			return "Sent"
		end

		Logger:warning("SendUniverseChatPresetAsync failed: {}", (tostring(result)))
		return "SendFailed"
	end
end

return sendPreset
