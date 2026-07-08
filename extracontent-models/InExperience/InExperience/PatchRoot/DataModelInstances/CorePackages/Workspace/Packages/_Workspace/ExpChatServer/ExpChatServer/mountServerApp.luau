local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local TextChatService = game:GetService("TextChatService")
local ExpChatServer = script:FindFirstAncestor("ExpChatServer")
local ExpChatServerParent = ExpChatServer.Parent
local List = require(ExpChatServerParent.llama).List
local ExpChatShared = require(ExpChatServerParent.ExpChatShared)
local SharedFlags = require(ExpChatServerParent.SharedFlags)
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
local v19 = ExpChatShared.Logger:new("ExpChat/" .. script.Name)
local getFFlagExpChatAlwaysRunTCS = SharedFlags.getFFlagExpChatAlwaysRunTCS
local FFlagExpChatAddUserAsyncNilCheck = ExpChatShared.Flags.FFlagExpChatAddUserAsyncNilCheck
local v22 = game:DefineFastFlag("ExpChatBackfillTeamChannels", false)
local v23 = game:DefineFastFlag("ExpChatBackfillTeamChannelsParentCheck", false)

return function(t1: {[any]: any}) -- line: 54
	-- upvalues: v19 (copy), createStore (copy), createDispatchRemoteFunction (copy), Analytics (copy), watchForErrors (copy), TextChatService (copy), FFlagExpChatAddUserAsyncNilCheck (copy), v22 (copy), v23 (copy), Teams (copy), Config (copy), Players (copy), Commands (copy), List (copy), getFFlagExpChatAlwaysRunTCS (copy), countParticipantsInTextChannel (copy), PlayerAdded (copy), PlayerRemoved (copy)
	v19:trace("mountServerApp started")

	local v25 = createStore()

	createDispatchRemoteFunction()

	if t1 and t1.analytics then
		Analytics.with(t1.analytics)
	end

	watchForErrors(game:GetService("ScriptContext"), t1.script, true)

	local t2 = {}

	if TextChatService.CreateDefaultTextChannels then
		v19:trace("Creating default TextChannels")

		local Folder = Instance.new("Folder")

		Folder.Name = "TextChannels"
		Folder.Parent = TextChatService

		local function findChannel(p1) -- line: 75
			-- upvalues: TextChatService (copy)
			for _, descendant in pairs(TextChatService:GetDescendants()) do
				if descendant:IsA("TextChannel") and p1 == descendant.Name then
					return descendant
				end
			end

			return nil
		end
		local function addChannel(p2) -- line: 85
			-- upvalues: findChannel (copy), Folder (copy)
			local v54 = findChannel(p2)

			if not v54 then
				v54 = Instance.new("TextChannel")
				v54.Name = p2
				v54.Parent = Folder
			end

			return v54
		end
		local function findTextSourceFromChannelWithUserId(p3, p4) -- line: 97
			for _, child in pairs(p3:GetChildren()) do
				if child:IsA("TextSource") and p4 == child.UserId then
					return child
				end
			end

			return nil
		end
		local function createTeamChannel(p5) -- line: 107
			-- upvalues: findChannel (copy), Folder (copy), v19 (copy), FFlagExpChatAddUserAsyncNilCheck (copy), findTextSourceFromChannelWithUserId (copy), v22 (copy), v23 (copy), Teams (copy)
			local v60 = "RBXTeam" .. tostring(p5.TeamColor.Name)
			local v61 = findChannel(v60)

			if not v61 then
				v61 = Instance.new("TextChannel")
				v61.Name = v60
				v61.Parent = Folder
			end

			v19:debug("Creating team TextChannel: {}", v61.Name)
			p5.PlayerAdded:Connect(function(player) -- line: 111
				-- upvalues: p5 (copy), findChannel (copy), Folder (copy), FFlagExpChatAddUserAsyncNilCheck (copy)
				local v83 = "RBXTeam" .. tostring(p5.TeamColor.Name)
				local v84 = findChannel(v83)

				if not v84 then
					v84 = Instance.new("TextChannel")
					v84.Name = v83
					v84.Parent = Folder
				end

				local v85 = v84:AddUserAsync(player.UserId)

				if FFlagExpChatAddUserAsyncNilCheck then
					if v85 ~= nil then
						v85.CanSend = true

						return
					end
				else
					v85.CanSend = true
				end
			end)
			p5.PlayerRemoved:Connect(function(p6) -- line: 124
				-- upvalues: p5 (copy), findChannel (copy), Folder (copy), findTextSourceFromChannelWithUserId (copy)
				local v87 = "RBXTeam" .. tostring(p5.TeamColor.Name)
				local v88 = findChannel(v87)

				if not v88 then
					v88 = Instance.new("TextChannel")
					v88.Name = v87
					v88.Parent = Folder
				end

				local v89 = findTextSourceFromChannelWithUserId(v88, p6.UserId)

				if v89 then
					v89:Destroy()
				end
			end)

			if v22 and (not v23 or p5.Parent == Teams) then
				for _, player in pairs(p5:GetPlayers()) do
					local v64 = "RBXTeam" .. tostring(p5.TeamColor.Name)
					local v65 = findChannel(v64)

					if not v65 then
						v65 = Instance.new("TextChannel")
						v65.Name = v64
						v65.Parent = Folder
					end

					local v66 = v65:AddUserAsync(player.UserId)

					if FFlagExpChatAddUserAsyncNilCheck then
						if v66 ~= nil then
							v66.CanSend = true
						end
					else
						v66.CanSend = true
					end
				end
			end

			p5:GetPropertyChangedSignal("TeamColor"):Connect(function() -- line: 154
				-- upvalues: p5 (copy), findChannel (copy), Folder (copy)
				local v90 = "RBXTeam" .. tostring(p5.TeamColor.Name)
				local v91 = findChannel(v90)

				if not v91 then
					v91 = Instance.new("TextChannel")
					v91.Name = v90
					v91.Parent = Folder
				end

				v91.Name = "RBXTeam" .. tostring(p5.TeamColor.Name)
			end)
		end

		for _, v in pairs(Teams:GetTeams()) do
			if v:IsA("Team") then
				createTeamChannel(v)
			end
		end

		Teams.ChildAdded:Connect(function(child) -- line: 166
			-- upvalues: createTeamChannel (copy)
			if child:IsA("Team") then
				createTeamChannel(child)
			end
		end)
		Teams.ChildRemoved:Connect(function(child) -- line: 172
			-- upvalues: findChannel (copy), v19 (copy)
			if child:IsA("Team") then
				local v69 = findChannel("RBXTeam" .. tostring(child.TeamColor.Name))

				if v69 then
					v19:debug("Destroying team TextChannel: {}", v69.Name)
					v69:Destroy()
				end
			end
		end)

		for k, _ in pairs(Config.DefaultChannelNames) do
			v19:trace("Creating default channel: {}", k)

			local v36 = findChannel(k)

			if not v36 then
				v36 = Instance.new("TextChannel")
				v36.Name = k
				v36.Parent = Folder
			end

			table.insert(t2, v36)
		end

		local function addPlayerTextSourceToDefaultChannels(p7) -- line: 187
			-- upvalues: t2 (copy), v19 (copy), FFlagExpChatAddUserAsyncNilCheck (copy)
			for _, v in ipairs(t2) do
				v19:trace("Adding user {} to TextChannel: {}", tostring(p7.UserId), v.Name)

				local v73 = v:AddUserAsync(p7.UserId)

				if FFlagExpChatAddUserAsyncNilCheck then
					if v73 ~= nil and v.Name == "RBXGeneral" then
						v73.CanSend = true
					elseif v73 ~= nil and v.Name == "RBXSystem" then
						v73.CanSend = false
					end
				elseif v.Name == "RBXGeneral" then
					v73.CanSend = true
				elseif v.Name == "RBXSystem" then
					v73.CanSend = false
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
		v19:trace("Creating default TextChatCommands")

		local Folder = Instance.new("Folder")

		Folder.Name = "TextChatCommands"
		Folder.Parent = TextChatService

		for _, v in ipairs(Commands.enabledCommands) do
			local TextChatCommand = Instance.new("TextChatCommand")

			TextChatCommand.Name = v.name
			TextChatCommand.PrimaryAlias = v.alias[1]
			TextChatCommand.SecondaryAlias = v.alias[2] or ""
			TextChatCommand.Parent = Folder
		end

		Analytics.FireRccAnalyticsWithEventName("DefaultCommandsCreated")
	end

	local v44 = #List.filter(TextChatService:GetDescendants(), function(p8) -- line: 39
		return p8:IsA("TextChannel")
	end)
	local v45 = #List.filter(TextChatService:GetDescendants(), function(p9) -- line: 47
		return p9:IsA("TextChatCommand")
	end)

	Analytics.FireRccAnalyticsWithEventName("ExperienceChatLoaded", {
		loadedChannels = v44,
		loadedCommands = v45
	})

	if getFFlagExpChatAlwaysRunTCS() then
		Analytics.FireRccAnalyticsDeferred("AutomigratedToTCS", {
			universeId = game.GameId
		})
	end

	v19:debug("Start watching for new channels and commands")
	TextChatService.DescendantAdded:Connect(function(descendant) -- line: 252
		-- upvalues: Analytics (copy), List (copy), TextChatService (copy), countParticipantsInTextChannel (copy)
		if descendant:IsA("TextChannel") then
			Analytics.FireRccAnalyticsWithEventName("ChannelCreated", {
				channelName = descendant.Name,
				totalChannels = #List.filter(TextChatService:GetDescendants(), function(p10) -- line: 39
					return p10:IsA("TextChannel")
				end)
			})

			return
		end

		if descendant:IsA("TextChatCommand") then
			Analytics.FireRccAnalyticsWithEventName("CommandCreated", {
				commandName = descendant.Name
			})

			return
		end

		if descendant:IsA("TextSource") then
			local descendantParent = descendant.Parent

			if descendantParent and descendantParent:IsA("TextChannel") then
				Analytics.FireRccAnalyticsWithEventName("ChannelJoined", {
					channelName = descendantParent.Name,
					totalParticipants = countParticipantsInTextChannel(descendantParent)
				})
			end
		end
	end)
	TextChatService.DescendantRemoving:Connect(function(descendant) -- line: 273
		-- upvalues: Analytics (copy), List (copy), TextChatService (copy), countParticipantsInTextChannel (copy)
		if descendant:IsA("TextChannel") then
			Analytics.FireRccAnalyticsWithEventName("ChannelRemoved", {
				channelName = descendant.Name,
				totalChannels = #List.filter(TextChatService:GetDescendants(), function(p11) -- line: 39
					return p11:IsA("TextChannel")
				end) - 1
			})

			return
		end

		if descendant:IsA("TextChatCommand") then
			Analytics.FireRccAnalyticsWithEventName("CommandRemoved", {
				commandName = descendant.Name
			})

			return
		end

		if descendant:IsA("TextSource") then
			local descendantParent = descendant.Parent

			if descendantParent and descendantParent:IsA("TextChannel") then
				Analytics.FireRccAnalyticsWithEventName("ChannelLeft", {
					channelName = descendantParent.Name,
					totalParticipants = countParticipantsInTextChannel(descendantParent)
				})
			end
		end
	end)

	for _, player in pairs(Players:GetPlayers()) do
		v25:dispatch(PlayerAdded(player.UserId, player.Name, player.DisplayName))
	end

	Players.PlayerAdded:Connect(function(player) -- line: 297
		-- upvalues: v25 (copy), PlayerAdded (copy)
		v25:dispatch(PlayerAdded(player.UserId, player.Name, player.DisplayName))
	end)
	Players.PlayerRemoving:Connect(function(player) -- line: 301
		-- upvalues: v25 (copy), PlayerRemoved (copy)
		v25:dispatch(PlayerRemoved(player.UserId))
	end)
end
