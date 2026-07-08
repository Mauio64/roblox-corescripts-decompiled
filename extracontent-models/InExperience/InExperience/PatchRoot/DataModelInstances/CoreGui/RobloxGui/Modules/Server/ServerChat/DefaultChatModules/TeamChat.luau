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
	function ChatLocalization.FormatMessageToSend(_, _, p3) -- line: 16
		return p3
	end
end

local t1 = {
	ChatColor = ChatSettings.ErrorMessageTextColor or Color3.fromRGB(245, 50, 50)
}

local function Run(p4) -- line: 22
	-- upvalues: ChatLocalization (ref), ChatConstants (copy), t1 (copy), ChatSettings (copy)
	local Players = game:GetService("Players")
	local v12 = p4:AddChannel("Team")

	v12.WelcomeMessage = ChatLocalization:FormatMessageToSend("GameChat_TeamChat_WelcomeMessage", "This is a private channel between you and your team members.")
	v12.Joinable = false
	v12.Leavable = false
	v12.AutoJoin = false
	v12.Private = true

	local function TeamChatReplicationFunction(p5, p6, p7) -- line: 33
		-- upvalues: p4 (copy)
		local Speaker = p4:GetSpeaker(p5)
		local Channel = p4:GetChannel(p7)

		if Speaker and Channel then
			local Player = Speaker:GetPlayer()

			if Player then
				for _, v in pairs(Channel:GetSpeakerList()) do
					local Speaker2 = p4:GetSpeaker(v)

					if Speaker2 then
						local Player2 = Speaker2:GetPlayer()

						if Player2 and Player.Team == Player2.Team then
							Speaker2:SendMessage(p6, p7, p5, {
								NameColor = Player.TeamColor.Color,
								ChatColor = Player.TeamColor.Color,
								ChannelColor = Player.TeamColor.Color
							})
						end
					end
				end
			end
		end

		return true
	end

	v12:RegisterProcessCommandsFunction("replication_function", TeamChatReplicationFunction, ChatConstants.LowPriority)

	local function DoTeamCommand(p8, p9, p10) -- line: 70
		-- upvalues: p4 (copy), ChatLocalization (ref), t1 (copy)
		if p9 == nil then
			p9 = ""
		end

		local Speaker = p4:GetSpeaker(p8)

		if Speaker then
			local Player = Speaker:GetPlayer()

			if Player then
				if Player.Team == nil then
					Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_TeamChat_CannotTeamChatIfNotInTeam", "You cannot team chat if you are not on a team!"), p10, t1)

					return
				end

				local Channel = p4:GetChannel("Team")

				if Channel then
					if not Speaker:IsInChannel(Channel.Name) then
						Speaker:JoinChannel(Channel.Name)
					end

					if p9 and string.len(p9) > 0 then
						Speaker:SayMessage(p9, Channel.Name)
					end

					Speaker:SetMainChannel(Channel.Name)
				end
			end
		end
	end
	local function TeamCommandsFunction(p11, p12, p13) -- line: 99
		-- upvalues: DoTeamCommand (copy)
		local v38 = false

		if p12 == nil then
			error("Message is nil")
		end

		if p13 == "Team" then
			return false
		end

		if string.sub(p12, 1, 6):lower() == "/team " or p12:lower() == "/team" then
			DoTeamCommand(p11, string.sub(p12, 7), p13)

			return true
		end

		if string.sub(p12, 1, 3):lower() == "/t " or p12:lower() == "/t" then
			DoTeamCommand(p11, string.sub(p12, 4), p13)

			return true
		end

		if string.sub(p12, 1, 2):lower() == "% " or p12:lower() == "%" then
			DoTeamCommand(p11, string.sub(p12, 3), p13)
			v38 = true
		end

		return v38
	end

	p4:RegisterProcessCommandsFunction("team_commands", TeamCommandsFunction, ChatConstants.StandardPriority)

	local function GetDefaultChannelNameColor() -- line: 126
		-- upvalues: ChatSettings (copy)
		if ChatSettings.DefaultChannelNameColor then
			return ChatSettings.DefaultChannelNameColor
		end

		return Color3.fromRGB(35, 76, 142)
	end
	local function PutSpeakerInCorrectTeamChatState(p14, p15) -- line: 133
		-- upvalues: v12 (copy), GetDefaultChannelNameColor (copy)
		if p15.Neutral or p15.Team == nil then
			p14:UpdateChannelNameColor(v12.Name, GetDefaultChannelNameColor())

			if p14:IsInChannel(v12.Name) then
				p14:LeaveChannel(v12.Name)

				return
			end
		elseif not p15.Neutral and p15.Team then
			p14:UpdateChannelNameColor(v12.Name, p15.Team.TeamColor.Color)

			if not p14:IsInChannel(v12.Name) then
				p14:JoinChannel(v12.Name)
			end
		end
	end

	p4.SpeakerAdded:connect(function(p16) -- line: 149
		-- upvalues: p4 (copy), PutSpeakerInCorrectTeamChatState (copy)
		local Speaker = p4:GetSpeaker(p16)

		if Speaker then
			local Player = Speaker:GetPlayer()

			if Player then
				PutSpeakerInCorrectTeamChatState(Speaker, Player)
			end
		end
	end)

	local t2 = {}

	Players.PlayerAdded:connect(function(p17) -- line: 160
		-- upvalues: p4 (copy), PutSpeakerInCorrectTeamChatState (copy), v12 (copy), ChatLocalization (ref), t2 (copy)
		t2[p17] = p17.Changed:connect(function(p18) -- line: 161
			-- upvalues: p4 (copy), p17 (copy), PutSpeakerInCorrectTeamChatState (copy), v12 (copy), ChatLocalization (ref)
			local Speaker = p4:GetSpeaker(p17.Name)

			if Speaker then
				if p18 == "Neutral" then
					PutSpeakerInCorrectTeamChatState(Speaker, p17)

					return
				end

				if p18 == "Team" then
					PutSpeakerInCorrectTeamChatState(Speaker, p17)

					if Speaker:IsInChannel(v12.Name) then
						Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_TeamChat_NowInTeam", string.format("You are now on the '%s' team.", p17.Team.Name), "RBX_NAME", p17.Team.Name), v12.Name)
					end
				end
			end
		end)
	end)
	Players.PlayerRemoving:connect(function(p19) -- line: 182
		-- upvalues: t2 (copy)
		local v46 = t2[p19]

		if v46 then
			v46:Disconnect()
		end

		t2[p19] = nil
	end)
end

return Run
