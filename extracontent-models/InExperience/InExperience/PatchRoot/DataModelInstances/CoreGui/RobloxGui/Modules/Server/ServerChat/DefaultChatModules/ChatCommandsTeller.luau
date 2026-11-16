local Chat = game:GetService("Chat")
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))
local ChatConstants = require(ClientChatModules:WaitForChild("ChatConstants"))

local v = nil

pcall(function()
	local Chat2 = game:GetService("Chat")
	v = require(Chat2.ClientChatModules.ChatLocalization)
end)

if v == nil then
	v = {}
end

if not (v.FormatMessageToSend and v.LocalizeFormattedMessage) then
	function v:FormatMessageToSend(_, p)
		return p
	end
end

local function Run(object)
	local function ShowJoinAndLeaveCommands() -- 1 equivalent call inferred from this helper
		return ChatSettings.ShowJoinAndLeaveHelpText ~= nil and ChatSettings.ShowJoinAndLeaveHelpText
	end

	local function ProcessCommandsFunction(p, value, p2): boolean
		if value:lower() ~= "/?" and value:lower() ~= "/help" then
			return false
		end

		local speaker = object:GetSpeaker(p)
		speaker:SendSystemMessage(
			v:FormatMessageToSend("GameChat_ChatCommandsTeller_Desc", "These are the basic chat commands."),
			p2
		)

		if ChatSettings.AllowMeCommand then
			speaker:SendSystemMessage(
				v:FormatMessageToSend(
					"GameChat_ChatCommandsTeller_MeCommand",
					"/me <text> : roleplaying command for doing actions."
				),
				p2
			)
		end

		speaker:SendSystemMessage(
			v:FormatMessageToSend(
				"GameChat_ChatCommandsTeller_SwitchChannelCommand",
				"/c <channel> : switch channel menu tabs."
			),
			p2
		)

		if ShowJoinAndLeaveCommands() then -- inferred equivalent call
			speaker:SendSystemMessage(
				v:FormatMessageToSend(
					"GameChat_ChatCommandsTeller_JoinChannelCommand",
					"/join <channel> or /j <channel> : join channel."
				),
				p2
			)
			speaker:SendSystemMessage(
				v:FormatMessageToSend(
					"GameChat_ChatCommandsTeller_LeaveChannelCommand",
					"/leave <channel> or /l <channel> : leave channel. (leaves current if none specified)"
				),
				p2
			)
		end

		speaker:SendSystemMessage(
			v:FormatMessageToSend(
				"GameChat_ChatCommandsTeller_WhisperCommand",
				"/whisper <speaker> or /w <speaker> : open private message channel with speaker."
			),
			p2
		)
		speaker:SendSystemMessage(
			v:FormatMessageToSend("GameChat_ChatCommandsTeller_MuteCommand", "/mute <speaker> : mute a speaker."),
			p2
		)
		speaker:SendSystemMessage(
			v:FormatMessageToSend("GameChat_ChatCommandsTeller_UnMuteCommand", "/unmute <speaker> : unmute a speaker."),
			p2
		)

		local player = speaker:GetPlayer()

		if player and player.Team then
			speaker:SendSystemMessage(
				v:FormatMessageToSend(
					"GameChat_ChatCommandsTeller_TeamCommand",
					"/team <message> or /t <message> : send a team chat to players on your team."
				),
				p2
			)
		end

		return true
	end

	object:RegisterProcessCommandsFunction(
		"chat_commands_inquiry",
		ProcessCommandsFunction,
		ChatConstants.StandardPriority
	)

	local channel = ChatSettings.GeneralChannelName and object:GetChannel(ChatSettings.GeneralChannelName)

	if channel then
		channel.WelcomeMessage = v:FormatMessageToSend(
			"GameChat_ChatCommandsTeller_AllChannelWelcomeMessage",
			"Chat '/?' or '/help' for a list of chat commands."
		)
	end
end

return Run
