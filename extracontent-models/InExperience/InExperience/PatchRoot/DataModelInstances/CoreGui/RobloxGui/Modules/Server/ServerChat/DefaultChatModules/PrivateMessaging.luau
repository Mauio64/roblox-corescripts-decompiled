local Chat = game:GetService("Chat")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local ChatModules = Chat:WaitForChild("ChatModules")
local ChatConstants = require(ClientChatModules:WaitForChild("ChatConstants"))
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))
local DisplayNameHelpers = require(ChatModules.Utility.DisplayNameHelpers)
local ChatLocalization = nil

pcall(function() -- line: 17
	-- upvalues: ChatLocalization (ref)
	ChatLocalization = require(game:GetService("Chat").ClientChatModules.ChatLocalization)
end)

if ChatLocalization == nil then
	ChatLocalization = {}
end

if not ChatLocalization.FormatMessageToSend or not ChatLocalization.LocalizeFormattedMessage then
	function ChatLocalization.FormatMessageToSend(_, _, p3) -- line: 20
		return p3
	end
end

local t1 = {
	ChatColor = ChatSettings.ErrorMessageTextColor or Color3.fromRGB(245, 50, 50)
}
local u11 = false
local ok, result = pcall(function() -- line: 27
	return UserSettings():IsUserFeatureEnabled("UserUseNewDirectChatAPI")
end)

if ok then
	u11 = result
end

local function GetWhisperChannelPrefix() -- line: 35
	-- upvalues: ChatConstants (copy)
	if ChatConstants.WhisperChannelPrefix then
		return ChatConstants.WhisperChannelPrefix
	end

	return "To "
end
local function GetWhisperChannelId(p4) -- line: 42
	-- upvalues: ChatConstants (copy)
	return (not ChatConstants.WhisperChannelPrefix and "To " or ChatConstants.WhisperChannelPrefix) .. p4
end
local function Run(p5) -- line: 46
	-- upvalues: RunService (copy), u11 (ref), TextChatService (copy), Chat (copy), ChatSettings (copy), DisplayNameHelpers (copy), ChatLocalization (ref), t1 (copy), ChatConstants (copy)
	local function CanCommunicate(p6, p7) -- line: 48
		-- upvalues: RunService (copy), u11 (ref), TextChatService (copy), Chat (copy)
		if RunService:IsStudio() then
			return true
		end

		local Player = p6:GetPlayer()
		local Player2 = p7:GetPlayer()

		if Player and Player2 then
			if u11 then
				local ok2, result2 = pcall(function() -- line: 56
					-- upvalues: TextChatService (copy), Player (copy), Player2 (copy)
					return TextChatService:CanUsersDirectChatAsync(Player.UserId, { Player2.UserId })
				end)

				return ok2 and #result2 > 0
			end

			local ok3, result3 = pcall(function() -- line: 61
				-- upvalues: Chat (copy), Player (copy), Player2 (copy)
				return Chat:CanUsersChatAsync(Player.UserId, Player2.UserId)
			end)

			return ok3 and result3
		end

		return false
	end
	local function DoWhisperCommand(p8, p9, p10) -- line: 70
		-- upvalues: p5 (copy), ChatSettings (copy), DisplayNameHelpers (copy), ChatLocalization (ref), t1 (copy), ChatConstants (copy), CanCommunicate (copy)
		local Speaker = p5:GetSpeaker(p8)
		local v40 = p9
		local v41 = nil

		if string.sub(p9, 1, 1) == "\"" then
			local v42 = string.find(p9, "\"", 2)

			if v42 then
				v40 = string.sub(p9, 2, v42 - 1)
				v41 = string.sub(p9, v42 + 2)
			end
		else
			local match = string.match(p9, "^[^%s]+")

			if match then
				v40 = match
				v41 = string.sub(p9, string.len(v40) + 2)
			end
		end

		local v44, v45

		if ChatSettings.PlayerDisplayNamesEnabled and ChatSettings.WhisperByDisplayNameEnabled then
			v44, v45 = DisplayNameHelpers.getUserNameFromChattedName(v40, p8, Speaker:GetNameForDisplay())
		else
			v44, v45 = DisplayNameHelpers.getUserNameFromChattedName(v40, p8, nil)
		end

		local Speaker2 = p5:GetSpeaker(v44)

		if v45 == DisplayNameHelpers.CommandErrorCodes.ChattingToSelf then
			Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_PrivateMessaging_CannotWhisperToSelf", "You cannot whisper to yourself."), p10, t1)

			return
		end

		if v45 == DisplayNameHelpers.CommandErrorCodes.NoMatches then
			Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_MuteSpeaker_SpeakerDoesNotExist", string.format("Speaker '%s' does not exist.", (tostring(v40))), "RBX_NAME", (tostring(v44))), p10, t1)

			return
		end

		if v45 == DisplayNameHelpers.CommandErrorCodes.MultipleMatches then
			local v47 = DisplayNameHelpers.getUsersWithDisplayNameString(v40, p8)

			Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("InGame.Chat.Response.DisplayNameMultipleMatches", "Warning: The following users have this display name: "), p10, t1)
			Speaker:SendSystemMessage(v47, p10, t1)

			return
		end

		if Speaker2 then
			local Channel = p5:GetChannel((not ChatConstants.WhisperChannelPrefix and "To " or ChatConstants.WhisperChannelPrefix) .. v44)

			if Channel then
				if not CanCommunicate(Speaker, Speaker2) then
					Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_PrivateMessaging_CannotChat", "You are not able to chat with this player."), p10, t1)

					return
				end

				if not Speaker:IsInChannel(Channel.Name) then
					Speaker:JoinChannel(Channel.Name)
				end

				if v41 and string.len(v41) > 0 then
					Speaker:SayMessage(v41, Channel.Name)
				end

				Speaker:SetMainChannel(Channel.Name)

				return
			end

			Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_MuteSpeaker_SpeakerDoesNotExist", string.format("Speaker '%s' does not exist.", (tostring(v40))), "RBX_NAME", (tostring(v44))), p10, t1)
		end
	end
	local function WhisperCommandsFunction(p11, p12, p13) -- line: 147
		-- upvalues: DoWhisperCommand (copy)
		local v52 = false

		if string.sub(p12, 1, 3):lower() == "/w " then
			DoWhisperCommand(p11, string.sub(p12, 4), p13)

			return true
		end

		if string.sub(p12, 1, 9):lower() == "/whisper " then
			DoWhisperCommand(p11, string.sub(p12, 10), p13)
			v52 = true
		end

		return v52
	end
	local function PrivateMessageReplicationFunction(p14, p15, p16) -- line: 163
		-- upvalues: p5 (copy), ChatConstants (copy)
		local Speaker = p5:GetSpeaker(p14)
		local ExtraData = Speaker.ExtraData

		Speaker:SendMessage(p15, p16, p14, ExtraData)

		local Speaker3 = p5:GetSpeaker((string.sub(p16, 4)))
		local v59 = (not ChatConstants.WhisperChannelPrefix and "To " or ChatConstants.WhisperChannelPrefix) .. p14

		if Speaker3 then
			if not Speaker3:IsInChannel(v59) then
				Speaker3:JoinChannel(v59)
			end

			Speaker3:SendMessage(p15, v59, p14, ExtraData)
		end

		return true
	end
	local function PrivateMessageAddTypeFunction(_, p18, _) -- line: 181
		-- upvalues: ChatConstants (copy)
		if ChatConstants.MessageTypeWhisper then
			p18.MessageType = ChatConstants.MessageTypeWhisper
		end
	end

	p5:RegisterProcessCommandsFunction("whisper_commands", WhisperCommandsFunction, ChatConstants.StandardPriority)

	local function GetWhisperChanneNameColor() -- line: 189
		-- upvalues: ChatSettings (copy)
		if ChatSettings.WhisperChannelNameColor then
			return ChatSettings.WhisperChannelNameColor
		end

		return Color3.fromRGB(102, 14, 102)
	end

	p5.SpeakerAdded:connect(function(p20) -- line: 196
		-- upvalues: p5 (copy), ChatSettings (copy), ChatConstants (copy), ChatLocalization (ref), PrivateMessageReplicationFunction (copy), PrivateMessageAddTypeFunction (copy)
		local Speaker = p5:GetSpeaker(p20)
		local v65 = if not ChatSettings.PlayerDisplayNamesEnabled or not Speaker:GetPlayer() then p20 else Speaker:GetNameForDisplay() .. "(@" .. p20 .. ")"
		local v66 = (not ChatConstants.WhisperChannelPrefix and "To " or ChatConstants.WhisperChannelPrefix) .. p20

		if p5:GetChannel(v66) then
			p5:RemoveChannel(v66)
		end

		local v67 = p5:AddChannel(v66)

		v67.Joinable = false
		v67.Leavable = true
		v67.AutoJoin = false
		v67.Private = true
		v67.WelcomeMessage = ChatLocalization:FormatMessageToSend("GameChat_PrivateMessaging_NowChattingWith", "You are now privately chatting with " .. v65 .. ".", "RBX_NAME", (tostring(v65)))
		v67.ChannelNameColor = if not ChatSettings.WhisperChannelNameColor then Color3.fromRGB(102, 14, 102) else ChatSettings.WhisperChannelNameColor
		v67:RegisterProcessCommandsFunction("replication_function", PrivateMessageReplicationFunction, ChatConstants.LowPriority)
		v67:RegisterFilterMessageFunction("message_type_function", PrivateMessageAddTypeFunction)
	end)
	p5.SpeakerRemoved:connect(function(p21) -- line: 228
		-- upvalues: ChatConstants (copy), p5 (copy)
		local v69 = (not ChatConstants.WhisperChannelPrefix and "To " or ChatConstants.WhisperChannelPrefix) .. p21

		if p5:GetChannel(v69) then
			p5:RemoveChannel(v69)
		end
	end)
end

return Run
