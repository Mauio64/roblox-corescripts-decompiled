local ClientChatModules = game:GetService("Chat"):WaitForChild("ClientChatModules")
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))
local ChatConstants = require(ClientChatModules:WaitForChild("ChatConstants"))
local ChatLocalization = nil

pcall(function() -- line: 13
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

local function Run(p4) -- line: 20
	-- upvalues: ChatSettings (copy), ChatLocalization (ref), ChatConstants (copy)
	local function ShowJoinAndLeaveCommands() -- line: 22
		-- upvalues: ChatSettings (copy)
		if ChatSettings.ShowJoinAndLeaveHelpText ~= nil then
			return ChatSettings.ShowJoinAndLeaveHelpText
		end

		return false
	end
	local function ProcessCommandsFunction(p5, p6, p7) -- line: 29
		-- upvalues: p4 (copy), ChatLocalization (ref), ChatSettings (copy)
		if p6:lower() == "/?" or p6:lower() == "/help" then
			local Speaker = p4:GetSpeaker(p5)

			Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_ChatCommandsTeller_Desc", "These are the basic chat commands."), p7)

			if ChatSettings.AllowMeCommand then
				Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_ChatCommandsTeller_MeCommand", "/me <text> : roleplaying command for doing actions."), p7)
			end

			Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_ChatCommandsTeller_SwitchChannelCommand", "/c <channel> : switch channel menu tabs."), p7)

			if ChatSettings.ShowJoinAndLeaveHelpText ~= nil and ChatSettings.ShowJoinAndLeaveHelpText then
				Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_ChatCommandsTeller_JoinChannelCommand", "/join <channel> or /j <channel> : join channel."), p7)
				Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_ChatCommandsTeller_LeaveChannelCommand", "/leave <channel> or /l <channel> : leave channel. (leaves current if none specified)"), p7)
			end

			Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_ChatCommandsTeller_WhisperCommand", "/whisper <speaker> or /w <speaker> : open private message channel with speaker."), p7)
			Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_ChatCommandsTeller_MuteCommand", "/mute <speaker> : mute a speaker."), p7)
			Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_ChatCommandsTeller_UnMuteCommand", "/unmute <speaker> : unmute a speaker."), p7)

			local Player = Speaker:GetPlayer()

			if Player and Player.Team then
				Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_ChatCommandsTeller_TeamCommand", "/team <message> or /t <message> : send a team chat to players on your team."), p7)
			end

			return true
		end

		return false
	end

	p4:RegisterProcessCommandsFunction("chat_commands_inquiry", ProcessCommandsFunction, ChatConstants.StandardPriority)

	if ChatSettings.GeneralChannelName then
		local Channel = p4:GetChannel(ChatSettings.GeneralChannelName)

		if Channel then
			Channel.WelcomeMessage = ChatLocalization:FormatMessageToSend("GameChat_ChatCommandsTeller_AllChannelWelcomeMessage", "Chat '/?' or '/help' for a list of chat commands.")
		end
	end
end

return Run
