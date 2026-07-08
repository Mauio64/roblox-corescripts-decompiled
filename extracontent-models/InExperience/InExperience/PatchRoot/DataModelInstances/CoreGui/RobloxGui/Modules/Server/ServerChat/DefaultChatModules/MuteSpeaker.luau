local Chat = game:GetService("Chat")
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local ChatModules = Chat:WaitForChild("ChatModules")
local ChatConstants = require(ClientChatModules:WaitForChild("ChatConstants"))
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))
local DisplayNameHelpers = require(ChatModules.Utility.DisplayNameHelpers)
local ChatLocalization = nil

pcall(function() -- line: 15
	-- upvalues: ChatLocalization (ref)
	ChatLocalization = require(game:GetService("Chat").ClientChatModules.ChatLocalization)
end)

if ChatLocalization == nil then
	ChatLocalization = {}
end

if not ChatLocalization.FormatMessageToSend or not ChatLocalization.LocalizeFormattedMessage then
	function ChatLocalization.FormatMessageToSend(_, _, p3) -- line: 18
		return p3
	end
end

local t1 = {
	ChatColor = ChatSettings.ErrorMessageTextColor or Color3.fromRGB(245, 50, 50)
}

local function Run(p4) -- line: 24
	-- upvalues: ChatSettings (copy), DisplayNameHelpers (copy), ChatLocalization (ref), t1 (copy), ChatConstants (copy)
	local function GetSpeakerNameFromMessage(p5) -- line: 26
		if string.sub(p5, 1, 1) == "\"" then
			local v19 = string.find(p5, "\"", 2)

			if v19 then
				return (string.sub(p5, 2, v19 - 1))
			end
		else
			local match = string.match(p5, "^[^%s]+")

			if match then
				p5 = match
			end
		end

		return p5
	end
	local function DoMuteCommand(p6, p7, p8) -- line: 42
		-- upvalues: p4 (copy), ChatSettings (copy), DisplayNameHelpers (copy), ChatLocalization (ref), t1 (copy)
		if string.sub(p7, 1, 1) == "\"" then
			local v24 = string.find(p7, "\"", 2)

			if v24 then
				p7 = string.sub(p7, 2, v24 - 1)
			end
		else
			local match = string.match(p7, "^[^%s]+")

			if match then
				p7 = match
			end
		end

		local Speaker = p4:GetSpeaker(p6)

		if Speaker then
			local v27, v28

			if ChatSettings.PlayerDisplayNamesEnabled then
				v27, v28 = DisplayNameHelpers.getUserNameFromChattedName(p7, p6, Speaker:GetNameForDisplay())
			else
				v27, v28 = DisplayNameHelpers.getUserNameFromChattedName(p7, p6, nil)
			end

			local Speaker2 = p4:GetSpeaker(v27)

			if v28 == DisplayNameHelpers.CommandErrorCodes.ChattingToSelf then
				Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_DoMuteCommand_CannotMuteSelf", "You cannot mute yourself."), p8, t1)

				return
			end

			if v28 == DisplayNameHelpers.CommandErrorCodes.NoMatches then
				Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_MuteSpeaker_SpeakerDoesNotExist", string.format("Speaker '%s' does not exist.", (tostring(p7))), "RBX_NAME", (tostring(v27))), p8, t1)

				return
			end

			if v28 == DisplayNameHelpers.CommandErrorCodes.MultipleMatches then
				local v30 = DisplayNameHelpers.getUsersWithDisplayNameString(p7, p6)

				Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("InGame.Chat.Response.DisplayNameMultipleMatches", "Warning: The following users have this display name: "), p8, t1)
				Speaker:SendSystemMessage(v30, p8, t1)

				return
			end

			if Speaker2 then
				Speaker:AddMutedSpeaker(Speaker2.Name)

				if ChatSettings.PlayerDisplayNamesEnabled then
					v27 = Speaker2:GetNameForDisplay()
				end

				Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_ChatMain_SpeakerHasBeenMuted", string.format("Speaker '%s' has been muted.", v27), "RBX_NAME", v27), p8)
			end
		end
	end
	local function DoUnmuteCommand(p9, p10, p11) -- line: 94
		-- upvalues: p4 (copy), ChatSettings (copy), DisplayNameHelpers (copy), ChatLocalization (ref), t1 (copy)
		if string.sub(p10, 1, 1) == "\"" then
			local v34 = string.find(p10, "\"", 2)

			if v34 then
				p10 = string.sub(p10, 2, v34 - 1)
			end
		else
			local match = string.match(p10, "^[^%s]+")

			if match then
				p10 = match
			end
		end

		local Speaker = p4:GetSpeaker(p9)

		if Speaker then
			local v37, v38

			if ChatSettings.PlayerDisplayNamesEnabled then
				v37, v38 = DisplayNameHelpers.getUserNameFromChattedName(p10, p9, Speaker:GetNameForDisplay())
			else
				v37, v38 = DisplayNameHelpers.getUserNameFromChattedName(p10, p9, nil)
			end

			local Speaker3 = p4:GetSpeaker(v37)

			if v38 == DisplayNameHelpers.CommandErrorCodes.ChattingToSelf then
				Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_DoMuteCommand_CannotMuteSelf", "You cannot mute yourself."), p11, t1)

				return
			end

			if v38 == DisplayNameHelpers.CommandErrorCodes.NoMatches then
				Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_MuteSpeaker_SpeakerDoesNotExist", string.format("Speaker '%s' does not exist.", (tostring(v37))), "RBX_NAME", (tostring(v37))), p11, t1)

				return
			end

			if v38 == DisplayNameHelpers.CommandErrorCodes.MultipleMatches then
				local v40 = DisplayNameHelpers.getUsersWithDisplayNameString(p10, p9)

				Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("InGame.Chat.Response.DisplayNameMultipleMatches", "Warning: The following users have this display name: "), p11, t1)
				Speaker:SendSystemMessage(v40, p11, t1)

				return
			end

			if Speaker3 then
				Speaker:RemoveMutedSpeaker(Speaker3.Name)

				if ChatSettings.PlayerDisplayNamesEnabled then
					v37 = Speaker3:GetNameForDisplay()
				end

				Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_ChatMain_SpeakerHasBeenUnMuted", string.format("Speaker '%s' has been unmuted.", v37), "RBX_NAME", v37), p11)

				return
			end
		end
	end
	local function MuteCommandsFunction(p12, p13, p14) -- line: 149
		-- upvalues: DoMuteCommand (copy), DoUnmuteCommand (copy)
		local v44 = false

		if string.sub(p13, 1, 6):lower() == "/mute " then
			DoMuteCommand(p12, string.sub(p13, 7), p14)

			return true
		end

		if string.sub(p13, 1, 8):lower() == "/unmute " then
			DoUnmuteCommand(p12, string.sub(p13, 9), p14)
			v44 = true
		end

		return v44
	end

	p4:RegisterProcessCommandsFunction("mute_commands", MuteCommandsFunction, ChatConstants.StandardPriority)
end

return Run
