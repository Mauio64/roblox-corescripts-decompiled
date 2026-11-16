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

local v2 = {
	ChatColor = ChatSettings.ErrorMessageTextColor or Color3.fromRGB(245, 50, 50)
}

local function Run(object)
	local Players = game:GetService("Players")

	local v3 = object:AddChannel("Team")
	v3.WelcomeMessage = v:FormatMessageToSend(
		"GameChat_TeamChat_WelcomeMessage",
		"This is a private channel between you and your team members."
	)
	v3.Joinable = false
	v3.Leavable = false
	v3.AutoJoin = false
	v3.Private = true

	local function TeamChatReplicationFunction(p, p2, p3): boolean
		local speaker = object:GetSpeaker(p)
		local channel = object:GetChannel(p3)

		local player = speaker and channel and speaker:GetPlayer()

		if not player then
			return true
		end

		for _, v4 in pairs(channel:GetSpeakerList()) do
			local speaker2 = object:GetSpeaker(v4)

			if not speaker2 then
				continue
			end

			local player2 = speaker2:GetPlayer()

			if player2 and player.Team == player2.Team then
				speaker2:SendMessage(p2, p3, p, {
					NameColor = player.TeamColor.Color,
					ChatColor = player.TeamColor.Color,
					ChannelColor = player.TeamColor.Color
				})
			end
		end

		return true
	end

	v3:RegisterProcessCommandsFunction("replication_function", TeamChatReplicationFunction, ChatConstants.LowPriority)

	local function DoTeamCommand(p, p2, p3)
		local v4 = p2 == nil and "" or p2

		local speaker = object:GetSpeaker(p)

		local player = speaker and speaker:GetPlayer()

		if player then
			if player.Team == nil then
				speaker:SendSystemMessage(
					v:FormatMessageToSend(
						"GameChat_TeamChat_CannotTeamChatIfNotInTeam",
						"You cannot team chat if you are not on a team!"
					),
					p3,
					v2
				)
				return
			end

			local channel = object:GetChannel("Team")

			if channel then
				if not speaker:IsInChannel(channel.Name) then
					speaker:JoinChannel(channel.Name)
				end

				if v4 and string.len(v4) > 0 then
					speaker:SayMessage(v4, channel.Name)
				end

				speaker:SetMainChannel(channel.Name)
			end
		end
	end

	local function TeamCommandsFunction(p, value, p2)
		local v4 = false

		if value == nil then
			error("Message is nil")
		end

		if p2 == "Team" then
			return false
		end

		if string.sub(value, 1, 6):lower() == "/team " or value:lower() == "/team" then
			DoTeamCommand(p, string.sub(value, 7), p2)
			return true
		end

		if string.sub(value, 1, 3):lower() == "/t " or value:lower() == "/t" then
			DoTeamCommand(p, string.sub(value, 4), p2)
			return true
		end

		if string.sub(value, 1, 2):lower() == "% " or value:lower() == "%" then
			DoTeamCommand(p, string.sub(value, 3), p2)
			return true
		end

		return v4
	end

	object:RegisterProcessCommandsFunction("team_commands", TeamCommandsFunction, ChatConstants.StandardPriority)

	local function GetDefaultChannelNameColor()
		if ChatSettings.DefaultChannelNameColor then
			return ChatSettings.DefaultChannelNameColor
		end

		return Color3.fromRGB(35, 76, 142)
	end

	local function PutSpeakerInCorrectTeamChatState(speaker, p)
		if p.Neutral or p.Team == nil then
			speaker:UpdateChannelNameColor(v3.Name, GetDefaultChannelNameColor())

			if speaker:IsInChannel(v3.Name) then
				speaker:LeaveChannel(v3.Name)
			end
		elseif not p.Neutral and p.Team then
			speaker:UpdateChannelNameColor(v3.Name, p.Team.TeamColor.Color)

			if not speaker:IsInChannel(v3.Name) then
				speaker:JoinChannel(v3.Name)
			end
		end
	end

	object.SpeakerAdded:connect(function(p)
		local speaker = object:GetSpeaker(p)

		local player = speaker and speaker:GetPlayer()

		if player then
			PutSpeakerInCorrectTeamChatState(speaker, player)
		end
	end)

	local v4 = {}
	Players.PlayerAdded:connect(function(data)
		v4[data] = data.Changed:connect(function(p)
			local speaker = object:GetSpeaker(data.Name)

			if speaker then
				if p == "Neutral" then
					PutSpeakerInCorrectTeamChatState(speaker, data)
				elseif p == "Team" then
					PutSpeakerInCorrectTeamChatState(speaker, data)

					if speaker:IsInChannel(v3.Name) then
						speaker:SendSystemMessage(
							v:FormatMessageToSend(
								"GameChat_TeamChat_NowInTeam",
								string.format("You are now on the '%s' team.", data.Team.Name),
								"RBX_NAME",
								data.Team.Name
							),
							v3.Name
						)
					end
				end
			end
		end)
	end)

	Players.PlayerRemoving:connect(function(p)
		local connection = v4[p]

		if connection then
			connection:Disconnect()
		end

		v4[p] = nil
	end)
end

return Run
