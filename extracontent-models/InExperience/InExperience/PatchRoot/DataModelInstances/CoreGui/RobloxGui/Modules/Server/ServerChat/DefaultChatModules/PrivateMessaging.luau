local Chat = game:GetService("Chat")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local ChatModules = Chat:WaitForChild("ChatModules")
local ChatConstants = require(ClientChatModules:WaitForChild("ChatConstants"))
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))
local DisplayNameHelpers = require(ChatModules.Utility.DisplayNameHelpers)

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

local v2 = {
	ChatColor = ChatSettings.ErrorMessageTextColor or Color3.fromRGB(245, 50, 50)
}

local success, result = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserUseNewDirectChatAPI")
end)

if not success then
	result = false
end

local function GetWhisperChannelPrefix() -- 1 equivalent call inferred from this helper
	if ChatConstants.WhisperChannelPrefix then
		return ChatConstants.WhisperChannelPrefix
	end

	return "To "
end

local function GetWhisperChannelId(p) -- 4 equivalent calls inferred from this helper
	return GetWhisperChannelPrefix() .. p -- inferred equivalent call
end

local function Run(object)
	local function CanCommunicate(speaker, speaker2)
		if RunService:IsStudio() then
			return true
		end

		local player = speaker:GetPlayer()
		local player2 = speaker2:GetPlayer()

		if not (player and player2) then
			return false
		end

		if result then
			local success2, result2 = pcall(function()
				return TextChatService:CanUsersDirectChatAsync(player.UserId, { player2.UserId })
			end)

			return success2 and #result2 > 0
		end

		local success2, result2 = pcall(function()
			return Chat:CanUsersChatAsync(player.UserId, player2.UserId)
		end)

		return success2 and result2
	end

	local function DoWhisperCommand(p, value, p2)
		local speaker = object:GetSpeaker(p)

		local v3 = nil
		local v4

		if string.sub(value, 1, 1) == "\"" then
			local v5 = string.find(value, "\"", 2)

			if v5 then
				v4 = string.sub(value, 2, v5 - 1)
				v3 = string.sub(value, v5 + 2)
			else
				v4 = value
			end
		else
			v4 = string.match(value, "^[^%s]+")

			if v4 then
				v3 = string.sub(value, string.len(v4) + 2)
			else
				v4 = value
			end
		end

		local v5, v6

		if ChatSettings.PlayerDisplayNamesEnabled and ChatSettings.WhisperByDisplayNameEnabled then
			v5, v6 = DisplayNameHelpers.getUserNameFromChattedName(v4, p, speaker:GetNameForDisplay())
		else
			v5, v6 = DisplayNameHelpers.getUserNameFromChattedName(v4, p, nil)
		end

		local speaker2 = object:GetSpeaker(v5)

		if v6 == DisplayNameHelpers.CommandErrorCodes.ChattingToSelf then
			speaker:SendSystemMessage(
				v:FormatMessageToSend(
					"GameChat_PrivateMessaging_CannotWhisperToSelf",
					"You cannot whisper to yourself."
				),
				p2,
				v2
			)
		elseif v6 == DisplayNameHelpers.CommandErrorCodes.NoMatches then
			speaker:SendSystemMessage(
				v:FormatMessageToSend(
					"GameChat_MuteSpeaker_SpeakerDoesNotExist",
					string.format("Speaker '%s' does not exist.", (tostring(v4))),
					"RBX_NAME",
					(tostring(v5))
				),
				p2,
				v2
			)
		elseif v6 == DisplayNameHelpers.CommandErrorCodes.MultipleMatches then
			local usersWithDisplayNameString = DisplayNameHelpers.getUsersWithDisplayNameString(v4, p)
			speaker:SendSystemMessage(
				v:FormatMessageToSend(
					"InGame.Chat.Response.DisplayNameMultipleMatches",
					"Warning: The following users have this display name: "
				),
				p2,
				v2
			)

			speaker:SendSystemMessage(usersWithDisplayNameString, p2, v2)
		elseif speaker2 then
			local channel = object:GetChannel(GetWhisperChannelId(v5)) -- inferred equivalent call

			if channel then
				if not CanCommunicate(speaker, speaker2) then
					speaker:SendSystemMessage(
						v:FormatMessageToSend(
							"GameChat_PrivateMessaging_CannotChat",
							"You are not able to chat with this player."
						),
						p2,
						v2
					)
					return
				end

				if not speaker:IsInChannel(channel.Name) then
					speaker:JoinChannel(channel.Name)
				end

				if v3 and string.len(v3) > 0 then
					speaker:SayMessage(v3, channel.Name)
				end

				speaker:SetMainChannel(channel.Name)
			else
				speaker:SendSystemMessage(
					v:FormatMessageToSend(
						"GameChat_MuteSpeaker_SpeakerDoesNotExist",
						string.format("Speaker '%s' does not exist.", (tostring(v4))),
						"RBX_NAME",
						(tostring(v5))
					),
					p2,
					v2
				)
			end
		end
	end

	local function WhisperCommandsFunction(p, value, p2)
		local v3 = false

		if string.sub(value, 1, 3):lower() == "/w " then
			DoWhisperCommand(p, string.sub(value, 4), p2)
			return true
		end

		if string.sub(value, 1, 9):lower() == "/whisper " then
			DoWhisperCommand(p, string.sub(value, 10), p2)
			return true
		end

		return v3
	end

	local function PrivateMessageReplicationFunction(p, p2, value): boolean
		local speaker = object:GetSpeaker(p)
		local extraData = speaker.ExtraData
		speaker:SendMessage(p2, value, p, extraData)

		local speaker2 = object:GetSpeaker((string.sub(value, 4)))
		local whisperChannelId = GetWhisperChannelId(p) -- inferred equivalent call

		if speaker2 then
			if not speaker2:IsInChannel(whisperChannelId) then
				speaker2:JoinChannel(whisperChannelId)
			end

			speaker2:SendMessage(p2, whisperChannelId, p, extraData)
		end

		return true
	end

	local function PrivateMessageAddTypeFunction(_, p, _)
		if ChatConstants.MessageTypeWhisper then
			p.MessageType = ChatConstants.MessageTypeWhisper
		end
	end

	object:RegisterProcessCommandsFunction("whisper_commands", WhisperCommandsFunction, ChatConstants.StandardPriority)

	local function GetWhisperChanneNameColor() -- 1 equivalent call inferred from this helper
		if ChatSettings.WhisperChannelNameColor then
			return ChatSettings.WhisperChannelNameColor
		end

		return Color3.fromRGB(102, 14, 102)
	end

	object.SpeakerAdded:connect(function(p)
		local speaker = object:GetSpeaker(p)
		local v3

		if ChatSettings.PlayerDisplayNamesEnabled and speaker:GetPlayer() then
			v3 = speaker:GetNameForDisplay() .. "(@" .. p .. ")"
		else
			v3 = p
		end

		local whisperChannelId = GetWhisperChannelId(p) -- inferred equivalent call

		if object:GetChannel(whisperChannelId) then
			object:RemoveChannel(whisperChannelId)
		end

		local v4 = object:AddChannel(whisperChannelId)
		v4.Joinable = false
		v4.Leavable = true
		v4.AutoJoin = false
		v4.Private = true

		v4.WelcomeMessage = v:FormatMessageToSend(
			"GameChat_PrivateMessaging_NowChattingWith",
			"You are now privately chatting with " .. v3 .. ".",
			"RBX_NAME",
			(tostring(v3))
		)
		v4.ChannelNameColor = GetWhisperChanneNameColor() -- inferred equivalent call
		v4:RegisterProcessCommandsFunction(
			"replication_function",
			PrivateMessageReplicationFunction,
			ChatConstants.LowPriority
		)
		v4:RegisterFilterMessageFunction("message_type_function", PrivateMessageAddTypeFunction)
	end)

	object.SpeakerRemoved:connect(function(p)
		local whisperChannelId = GetWhisperChannelId(p) -- inferred equivalent call

		if object:GetChannel(whisperChannelId) then
			object:RemoveChannel(whisperChannelId)
		end
	end)
end

return Run
