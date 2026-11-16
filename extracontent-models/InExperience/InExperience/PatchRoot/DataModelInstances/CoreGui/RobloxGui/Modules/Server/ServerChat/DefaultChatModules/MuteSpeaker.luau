local Chat = game:GetService("Chat")
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

local function Run(object)
	local function GetSpeakerNameFromMessage(value)
		if string.sub(value, 1, 1) ~= "\"" then
			value = string.match(value, "^[^%s]+") or value

			return value
		end

		local v3 = string.find(value, "\"", 2)

		if v3 then
			return (string.sub(value, 2, v3 - 1))
		end

		return value
	end

	local function DoMuteCommand(p, value, p2)
		if string.sub(value, 1, 1) == "\"" then
			local v3 = string.find(value, "\"", 2)

			if v3 then
				value = string.sub(value, 2, v3 - 1)
			end
		else
			value = string.match(value, "^[^%s]+") or value
		end

		local speaker = object:GetSpeaker(p)

		if speaker then
			local v3, v4

			if ChatSettings.PlayerDisplayNamesEnabled then
				v3, v4 = DisplayNameHelpers.getUserNameFromChattedName(value, p, speaker:GetNameForDisplay())
			else
				v3, v4 = DisplayNameHelpers.getUserNameFromChattedName(value, p, nil)
			end

			local speaker2 = object:GetSpeaker(v3)

			if v4 == DisplayNameHelpers.CommandErrorCodes.ChattingToSelf then
				speaker:SendSystemMessage(
					v:FormatMessageToSend("GameChat_DoMuteCommand_CannotMuteSelf", "You cannot mute yourself."),
					p2,
					v2
				)
			elseif v4 == DisplayNameHelpers.CommandErrorCodes.NoMatches then
				speaker:SendSystemMessage(
					v:FormatMessageToSend(
						"GameChat_MuteSpeaker_SpeakerDoesNotExist",
						string.format("Speaker '%s' does not exist.", (tostring(value))),
						"RBX_NAME",
						(tostring(v3))
					),
					p2,
					v2
				)
			elseif v4 == DisplayNameHelpers.CommandErrorCodes.MultipleMatches then
				local usersWithDisplayNameString = DisplayNameHelpers.getUsersWithDisplayNameString(value, p)
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
				speaker:AddMutedSpeaker(speaker2.Name)

				if ChatSettings.PlayerDisplayNamesEnabled then
					v3 = speaker2:GetNameForDisplay()
				end

				speaker:SendSystemMessage(
					v:FormatMessageToSend(
						"GameChat_ChatMain_SpeakerHasBeenMuted",
						string.format("Speaker '%s' has been muted.", v3),
						"RBX_NAME",
						v3
					),
					p2
				)
			end
		end
	end

	local function DoUnmuteCommand(p, value, p2)
		if string.sub(value, 1, 1) == "\"" then
			local v3 = string.find(value, "\"", 2)

			if v3 then
				value = string.sub(value, 2, v3 - 1)
			end
		else
			value = string.match(value, "^[^%s]+") or value
		end

		local speaker = object:GetSpeaker(p)

		if speaker then
			local v3, v4

			if ChatSettings.PlayerDisplayNamesEnabled then
				v3, v4 = DisplayNameHelpers.getUserNameFromChattedName(value, p, speaker:GetNameForDisplay())
			else
				v3, v4 = DisplayNameHelpers.getUserNameFromChattedName(value, p, nil)
			end

			local speaker2 = object:GetSpeaker(v3)

			if v4 == DisplayNameHelpers.CommandErrorCodes.ChattingToSelf then
				speaker:SendSystemMessage(
					v:FormatMessageToSend("GameChat_DoMuteCommand_CannotMuteSelf", "You cannot mute yourself."),
					p2,
					v2
				)
			elseif v4 == DisplayNameHelpers.CommandErrorCodes.NoMatches then
				speaker:SendSystemMessage(
					v:FormatMessageToSend(
						"GameChat_MuteSpeaker_SpeakerDoesNotExist",
						string.format("Speaker '%s' does not exist.", (tostring(v3))),
						"RBX_NAME",
						(tostring(v3))
					),
					p2,
					v2
				)
			elseif v4 == DisplayNameHelpers.CommandErrorCodes.MultipleMatches then
				local usersWithDisplayNameString = DisplayNameHelpers.getUsersWithDisplayNameString(value, p)
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
				speaker:RemoveMutedSpeaker(speaker2.Name)

				if ChatSettings.PlayerDisplayNamesEnabled then
					v3 = speaker2:GetNameForDisplay()
				end

				speaker:SendSystemMessage(
					v:FormatMessageToSend(
						"GameChat_ChatMain_SpeakerHasBeenUnMuted",
						string.format("Speaker '%s' has been unmuted.", v3),
						"RBX_NAME",
						v3
					),
					p2
				)
			end
		end
	end

	local function MuteCommandsFunction(p, value, p2)
		local v3 = false

		if string.sub(value, 1, 6):lower() == "/mute " then
			DoMuteCommand(p, string.sub(value, 7), p2)
			return true
		end

		if string.sub(value, 1, 8):lower() == "/unmute " then
			DoUnmuteCommand(p, string.sub(value, 9), p2)
			return true
		end

		return v3
	end

	object:RegisterProcessCommandsFunction("mute_commands", MuteCommandsFunction, ChatConstants.StandardPriority)
end

return Run
