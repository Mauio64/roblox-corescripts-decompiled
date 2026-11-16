local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local TextChatService = game:GetService("TextChatService")
local ExpChatServer = script:FindFirstAncestor("ExpChatServer")
local parent = ExpChatServer.Parent

local llama = require(parent.llama)
local list = llama.List
local ExpChatShared = require(parent.ExpChatShared)
local SharedFlags = require(parent.SharedFlags)

local createDispatchRemoteFunction = require(ExpChatServer.createDispatchRemoteFunction)
local createStore = require(script.createStore)
local watchForErrors = ExpChatShared.watchForErrors

local countParticipantsInTextChannel = ExpChatShared.countParticipantsInTextChannel

local Actions = ExpChatShared.Actions
local PlayerAdded = Actions.PlayerAdded
local PlayerRemoved = Actions.PlayerRemoved

local Commands = ExpChatShared.Commands
local Config = ExpChatShared.Config

local Analytics = ExpChatShared.Analytics
local v = ExpChatShared.Logger:new("ExpChat/" .. script.Name)

local getFFlagExpChatAlwaysRunTCS = SharedFlags.getFFlagExpChatAlwaysRunTCS
local FFlagExpChatAddUserAsyncNilCheck = ExpChatShared.Flags.FFlagExpChatAddUserAsyncNilCheck
local markTextChannelAsDefault = ExpChatShared.markTextChannelAsDefault
local defineFastFlag = game:DefineFastFlag("ExpChatBackfillTeamChannels", false)
local defineFastFlag2 = game:DefineFastFlag("ExpChatBackfillTeamChannelsParentCheck", false)

return function(p)
	v:trace("mountServerApp started")

	local store = createStore()
	createDispatchRemoteFunction()

	if p and p.analytics then
		Analytics.with(p.analytics)
	end

	local ScriptContext = game:GetService("ScriptContext")
	watchForErrors(ScriptContext, p.script, true)

	local v2 = {}

	if TextChatService.CreateDefaultTextChannels then
		v:trace("Creating default TextChannels")

		local textChannels = Instance.new("Folder")
		textChannels.Name = "TextChannels"
		textChannels.Parent = TextChatService

		local function findChannel(p2)
			for _, textChannel in pairs(TextChatService:GetDescendants()) do
				if textChannel:IsA("TextChannel") and textChannel.Name == p2 then
					return textChannel
				end
			end

			return nil
		end

		local function addChannel(name) -- 6 equivalent calls inferred from this helper
			local v3 = findChannel(name)

			if v3 then
				return v3
			end

			v3 = Instance.new("TextChannel")
			v3.Name = name
			markTextChannelAsDefault(v3)
			v3.Parent = textChannels

			return v3
		end

		local function findTextSourceFromChannelWithUserId(instance, userId)
			for _, textSource in pairs(instance:GetChildren()) do
				if textSource:IsA("TextSource") and textSource.UserId == userId then
					return textSource
				end
			end

			return nil
		end

		local function createTeamChannel(team)
			v:debug("Creating team TextChannel: {}", addChannel("RBXTeam" .. tostring(team.TeamColor.Name)).Name) -- inferred equivalent call

			team.PlayerAdded:Connect(function(player)
				local v3 = addChannel("RBXTeam" .. tostring(team.TeamColor.Name)):AddUserAsync(player.UserId) -- inferred equivalent call

				if FFlagExpChatAddUserAsyncNilCheck then
					if v3 ~= nil then
						v3.CanSend = true
					end
				else
					v3.CanSend = true
				end
			end)

			team.PlayerRemoved:Connect(function(p2)
				local textSourceFromChannelWithUserId = findTextSourceFromChannelWithUserId(
					addChannel("RBXTeam" .. tostring(team.TeamColor.Name)), -- inferred equivalent call
					p2.UserId
				)

				if textSourceFromChannelWithUserId then
					textSourceFromChannelWithUserId:Destroy()
				end
			end)

			local v3 = defineFastFlag

			if v3 and defineFastFlag2 then
				v3 = team.Parent == Teams
			end

			if v3 then
				for _, v4 in pairs(team:GetPlayers()) do
					local v5 = addChannel("RBXTeam" .. tostring(team.TeamColor.Name)):AddUserAsync(v4.UserId) -- inferred equivalent call

					if FFlagExpChatAddUserAsyncNilCheck then
						if v5 ~= nil then
							v5.CanSend = true
						end
					else
						v5.CanSend = true
					end
				end
			end

			team:GetPropertyChangedSignal("TeamColor"):Connect(function()
				local v4 = addChannel("RBXTeam" .. tostring(team.TeamColor.Name)) -- inferred equivalent call
				v4.Name = "RBXTeam" .. tostring(team.TeamColor.Name)
			end)
		end

		for _, team in pairs(Teams:GetTeams()) do
			if team:IsA("Team") then
				createTeamChannel(team)
			end
		end

		Teams.ChildAdded:Connect(function(team)
			if team:IsA("Team") then
				createTeamChannel(team)
			end
		end)

		Teams.ChildRemoved:Connect(function(team)
			local v3 = team:IsA("Team") and findChannel("RBXTeam" .. tostring(team.TeamColor.Name))

			if v3 then
				v:debug("Destroying team TextChannel: {}", v3.Name)
				v3:Destroy()
			end
		end)

		for k, _ in pairs(Config.DefaultChannelNames) do
			v:trace("Creating default channel: {}", k)
			table.insert(v2, addChannel(k)) -- inferred equivalent call
		end

		local function addPlayerTextSourceToDefaultChannels(player)
			for _, v3 in ipairs(v2) do
				v:trace("Adding user {} to TextChannel: {}", tostring(player.UserId), v3.Name)
				local v4 = v3:AddUserAsync(player.UserId)

				if FFlagExpChatAddUserAsyncNilCheck then
					if v4 == nil or v3.Name ~= "RBXGeneral" then
						if v4 ~= nil and v3.Name == "RBXSystem" then
							v4.CanSend = false
						end
					else
						v4.CanSend = true
					end
				elseif v3.Name == "RBXGeneral" then
					v4.CanSend = true
				elseif v3.Name == "RBXSystem" then
					v4.CanSend = false
				end
			end
		end

		for _, player in pairs(Players:GetPlayers()) do
			if player:IsA("Player") then
				addPlayerTextSourceToDefaultChannels(player)
			end
		end

		Players.PlayerAdded:Connect(addPlayerTextSourceToDefaultChannels)

		Analytics.FireRccAnalyticsWithEventName("DefaultChannelsCreated")
	end

	if TextChatService.CreateDefaultCommands then
		v:trace("Creating default TextChatCommands")
		local textChatCommands = Instance.new("Folder")
		textChatCommands.Name = "TextChatCommands"
		textChatCommands.Parent = TextChatService

		for _, enabledCommand in ipairs(Commands.enabledCommands) do
			local textChatCommand = Instance.new("TextChatCommand")
			textChatCommand.Name = enabledCommand.name
			textChatCommand.PrimaryAlias = enabledCommand.alias[1]
			textChatCommand.SecondaryAlias = enabledCommand.alias[2] or ""
			textChatCommand.Parent = textChatCommands
		end

		Analytics.FireRccAnalyticsWithEventName("DefaultCommandsCreated")
	end

	local loadedChannels = #list.filter(TextChatService:GetDescendants(), function(textChannel)
		return textChannel:IsA("TextChannel")
	end)

	local loadedCommands = #list.filter(TextChatService:GetDescendants(), function(textChatCommand)
		return textChatCommand:IsA("TextChatCommand")
	end)

	Analytics.FireRccAnalyticsWithEventName("ExperienceChatLoaded", {
		loadedChannels = loadedChannels,
		loadedCommands = loadedCommands
	})

	if getFFlagExpChatAlwaysRunTCS() then
		Analytics.FireRccAnalyticsDeferred("AutomigratedToTCS", { universeId = game.GameId })
	end

	v:debug("Start watching for new channels and commands")

	TextChatService.DescendantAdded:Connect(function(descendant)
		if descendant:IsA("TextChannel") then
			Analytics.FireRccAnalyticsWithEventName("ChannelCreated", {
				channelName = descendant.Name,
				totalChannels = #list.filter(TextChatService:GetDescendants(), function(textChannel)
					return textChannel:IsA("TextChannel")
				end)
			})
		elseif descendant:IsA("TextChatCommand") then
			Analytics.FireRccAnalyticsWithEventName("CommandCreated", {
				commandName = descendant.Name
			})
		elseif descendant:IsA("TextSource") then
			local parent2 = descendant.Parent

			if parent2 and parent2:IsA("TextChannel") then
				Analytics.FireRccAnalyticsWithEventName("ChannelJoined", {
					channelName = parent2.Name,
					totalParticipants = countParticipantsInTextChannel(parent2)
				})
			end
		end
	end)

	TextChatService.DescendantRemoving:Connect(function(descendant)
		if descendant:IsA("TextChannel") then
			Analytics.FireRccAnalyticsWithEventName("ChannelRemoved", {
				channelName = descendant.Name,
				totalChannels = #list.filter(TextChatService:GetDescendants(), function(textChannel)
					return textChannel:IsA("TextChannel")
				end) - 1
			})
		elseif descendant:IsA("TextChatCommand") then
			Analytics.FireRccAnalyticsWithEventName("CommandRemoved", {
				commandName = descendant.Name
			})
		elseif descendant:IsA("TextSource") then
			local parent2 = descendant.Parent

			if parent2 and parent2:IsA("TextChannel") then
				Analytics.FireRccAnalyticsWithEventName("ChannelLeft", {
					channelName = parent2.Name,
					totalParticipants = countParticipantsInTextChannel(parent2)
				})
			end
		end
	end)

	for _, v3 in pairs(Players:GetPlayers()) do
		store:dispatch(PlayerAdded(v3.UserId, v3.Name, v3.DisplayName))
	end

	Players.PlayerAdded:Connect(function(player)
		store:dispatch(PlayerAdded(player.UserId, player.Name, player.DisplayName))
	end)

	Players.PlayerRemoving:Connect(function(player)
		store:dispatch(PlayerRemoved(player.UserId))
	end)
end
