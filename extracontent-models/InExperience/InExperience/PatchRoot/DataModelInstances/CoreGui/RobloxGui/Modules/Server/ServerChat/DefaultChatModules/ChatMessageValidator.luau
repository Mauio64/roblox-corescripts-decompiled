local Chat = game:GetService("Chat")
local RunService = game:GetService("RunService")
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))
local ChatConstants = require(ClientChatModules:WaitForChild("ChatConstants"))
local ChatLocalization = nil

pcall(function() -- line: 14
	-- upvalues: ChatLocalization (ref)
	ChatLocalization = require(game:GetService("Chat").ClientChatModules.ChatLocalization)
end)

if ChatLocalization == nil then
	ChatLocalization = {}
end

if not ChatLocalization.FormatMessageToSend or not ChatLocalization.LocalizeFormattedMessage then
	function ChatLocalization.FormatMessageToSend(_, _, p3) -- line: 17
		return p3
	end
end

local t1 = {
	"\n",
	"\r",
	"\t",
	"\v",
	"\f"
}

if ChatSettings.DisallowedWhiteSpace then
	t1 = ChatSettings.DisallowedWhiteSpace
end

local function isMessageValidServer(p4) -- line: 27
	-- upvalues: ChatSettings (copy)
	if p4:len() > ChatSettings.MaximumMessageLength * 6 then
		return false
	end

	if utf8.len(p4) == nil then
		return false
	end

	if utf8.len(utf8.nfcnormalize(p4)) > ChatSettings.MaximumMessageLength then
		return false
	end

	return true
end
local function CanUserChat(p5) -- line: 47
	-- upvalues: RunService (copy), Chat (copy)
	if RunService:IsStudio() then
		return true
	end

	local ok, result = pcall(function() -- line: 51
		-- upvalues: Chat (copy), p5 (copy)
		return Chat:CanUserChatAsync(p5.UserId)
	end)

	return ok and result
end
local function Run(p6) -- line: 57
	-- upvalues: RunService (copy), Chat (copy), ChatLocalization (ref), isMessageValidServer (copy), t1 (ref), ChatConstants (copy)
	local function ValidateChatFunction(p7, p8, p9) -- line: 58
		-- upvalues: p6 (copy), RunService (copy), Chat (copy), ChatLocalization (ref), isMessageValidServer (copy), t1 (ref)
		local Speaker = p6:GetSpeaker(p7)
		local Player = Speaker:GetPlayer()

		if not Speaker then
			return false
		end

		if not Player then
			return false
		end

		if not RunService:IsStudio() and Player.UserId < 1 then
			return true
		end

		local v25

		if RunService:IsStudio() then
			v25 = true
		else
			local ok, result = pcall(function() -- line: 51
				-- upvalues: Chat (copy), Player (copy)
				return Chat:CanUserChatAsync(Player.UserId)
			end)

			v25 = ok and result
		end

		if not v25 then
			Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_ChatMessageValidator_SettingsError", "Your chat settings prevent you from sending messages."), p9)

			return true
		end

		if not isMessageValidServer(p8) then
			Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_ChatMessageValidator_MaxLengthError", "Your message exceeds the maximum message length."), p9)

			return true
		end

		for _, v in pairs(t1) do
			if p8:find(v) then
				Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_ChatMessageValidator_WhitespaceError", "Your message contains whitespace that is not allowed."), p9)

				return true
			end
		end

		return false
	end

	p6:RegisterProcessCommandsFunction("message_validation", ValidateChatFunction, ChatConstants.VeryHighPriority)
end

return Run
