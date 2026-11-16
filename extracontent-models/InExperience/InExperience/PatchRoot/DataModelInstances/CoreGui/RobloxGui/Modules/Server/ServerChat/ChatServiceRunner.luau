local ReplicatedStorage = game:GetService("ReplicatedStorage")
local script = script

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Chat = game:GetService("Chat")

local ChatService = require(script:WaitForChild("ChatService"))

local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))

local v = nil
pcall(function()
	local ChatLocalization = require(Chat.ClientChatModules.ChatLocalization)
	v = ChatLocalization
end)
v = v or {}

local maxChannelNameCheckLength = ChatSettings.MaxChannelNameCheckLength or 50
local MaximumMessageLength = ChatSettings.MaximumMessageLength

if not (v.FormatMessageToSend and v.LocalizeFormattedMessage) then
	function v:FormatMessageToSend(_, p)
		return p
	end
end

local ifDoesntExistsByName = {}

local DefaultChatSystemChatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")

if not DefaultChatSystemChatEvents then
	DefaultChatSystemChatEvents = Instance.new("Folder")
	DefaultChatSystemChatEvents.Name = "DefaultChatSystemChatEvents"
	DefaultChatSystemChatEvents.Archivable = false
	DefaultChatSystemChatEvents.Parent = ReplicatedStorage
end

local function validateMessageLength(value): boolean
	local v2 = value:len()

	if MaximumMessageLength * 6 < v2 then
		return false
	end

	return utf8.len(value) ~= nil and not (MaximumMessageLength < utf8.len(utf8.nfcnormalize(value)))
end

local function validateChannelNameLength(value): boolean
	local v2 = value:len()

	if maxChannelNameCheckLength * 6 < v2 then
		return false
	end

	return utf8.len(value) ~= nil and not (maxChannelNameCheckLength < utf8.len(utf8.nfcnormalize(value)))
end

local function emptyFunction() end

local function GetObjectWithNameAndType(parent, name, className)
	for _, child in pairs(parent:GetChildren()) do
		if child:IsA(className) and child.Name == name then
			return child
		end
	end

	return nil
end

local function CreateIfDoesntExist(parent, name, className) -- 4 equivalent calls inferred from this helper
	local ifDoesntExist = GetObjectWithNameAndType(parent, name, className)

	if not ifDoesntExist then
		ifDoesntExist = Instance.new(className)
		ifDoesntExist.Name = name
		ifDoesntExist.Parent = parent
	end

	ifDoesntExistsByName[name] = ifDoesntExist

	return ifDoesntExist
end

local function CreateEventIfItDoesntExist(defaultChatSystemChatEvents, name) -- 11 equivalent calls inferred from this helper
	local eventIfItDoesntExist = CreateIfDoesntExist(defaultChatSystemChatEvents, name, "RemoteEvent") -- inferred equivalent call
	eventIfItDoesntExist.OnServerEvent:Connect(emptyFunction)
	return eventIfItDoesntExist
end

CreateEventIfItDoesntExist(DefaultChatSystemChatEvents, "OnNewMessage") -- inferred equivalent call
CreateEventIfItDoesntExist(DefaultChatSystemChatEvents, "OnMessageDoneFiltering") -- inferred equivalent call
CreateEventIfItDoesntExist(DefaultChatSystemChatEvents, "OnNewSystemMessage") -- inferred equivalent call
CreateEventIfItDoesntExist(DefaultChatSystemChatEvents, "OnChannelJoined") -- inferred equivalent call
CreateEventIfItDoesntExist(DefaultChatSystemChatEvents, "OnChannelLeft") -- inferred equivalent call
CreateEventIfItDoesntExist(DefaultChatSystemChatEvents, "OnMuted") -- inferred equivalent call
CreateEventIfItDoesntExist(DefaultChatSystemChatEvents, "OnUnmuted") -- inferred equivalent call
CreateEventIfItDoesntExist(DefaultChatSystemChatEvents, "OnMainChannelSet") -- inferred equivalent call
CreateEventIfItDoesntExist(DefaultChatSystemChatEvents, "ChannelNameColorUpdated") -- inferred equivalent call
CreateEventIfItDoesntExist(DefaultChatSystemChatEvents, "SayMessageRequest") -- inferred equivalent call
CreateEventIfItDoesntExist(DefaultChatSystemChatEvents, "SetBlockedUserIdsRequest") -- inferred equivalent call
CreateIfDoesntExist(DefaultChatSystemChatEvents, "GetInitDataRequest", "RemoteFunction") -- inferred equivalent call
CreateIfDoesntExist(DefaultChatSystemChatEvents, "MutePlayerRequest", "RemoteFunction") -- inferred equivalent call
CreateIfDoesntExist(DefaultChatSystemChatEvents, "UnMutePlayerRequest", "RemoteFunction") -- inferred equivalent call
local v2 = ifDoesntExistsByName

local function CreatePlayerSpeakerObject(player)
	if ChatService:GetSpeaker(player.Name) then
		ChatService:RemoveSpeaker(player.Name)
	end

	local internalAddSpeakerWithPlayerObject = ChatService:InternalAddSpeakerWithPlayerObject(
		player.Name,
		player,
		false
	)

	for _, v3 in pairs(ChatService:GetAutoJoinChannelList()) do
		internalAddSpeakerWithPlayerObject:JoinChannel(v3.Name)
	end

	internalAddSpeakerWithPlayerObject:InternalAssignEventFolder(v2)

	internalAddSpeakerWithPlayerObject.ChannelJoined:connect(function(p, p2)
		local channel = ChatService:GetChannel(p)
		local historyLogForSpeaker, channelNameColor

		if channel then
			historyLogForSpeaker = channel:GetHistoryLogForSpeaker(internalAddSpeakerWithPlayerObject)
			channelNameColor = channel.ChannelNameColor
		end

		v2.OnChannelJoined:FireClient(player, p, p2, historyLogForSpeaker, channelNameColor)
	end)

	internalAddSpeakerWithPlayerObject.Muted:connect(function(p, p2, p3)
		v2.OnMuted:FireClient(player, p, p2, p3)
	end)

	internalAddSpeakerWithPlayerObject.Unmuted:connect(function(p)
		v2.OnUnmuted:FireClient(player, p)
	end)

	ChatService:InternalFireSpeakerAdded(internalAddSpeakerWithPlayerObject.Name)
end

v2.SayMessageRequest.OnServerEvent:connect(function(p, value, value2)
	if not (type(value) == "string" and validateMessageLength(value) and type(value2) == "string") then
		return
	end

	if not validateChannelNameLength(value2) then
		return
	end

	local speaker = ChatService:GetSpeaker(p.Name)

	if speaker then
		return speaker:SayMessage(value, value2)
	end

	return nil
end)

v2.MutePlayerRequest.OnServerInvoke = function(p, value)
	if type(value) ~= "string" then
		return
	end

	local speaker = ChatService:GetSpeaker(p.Name)

	local speaker2 = speaker and ChatService:GetSpeaker(value)

	if not speaker2 then
		return false
	end

	speaker:AddMutedSpeaker(speaker2.Name)
	return true
end

v2.UnMutePlayerRequest.OnServerInvoke = function(p, value)
	if type(value) ~= "string" then
		return
	end

	local speaker = ChatService:GetSpeaker(p.Name)

	local speaker2 = speaker and ChatService:GetSpeaker(value)

	if not speaker2 then
		return false
	end

	speaker:RemoveMutedSpeaker(speaker2.Name)
	return true
end

local v3 = {}

Players.PlayerAdded:connect(function(p)
	for k, v4 in pairs(v3) do
		local speaker = ChatService:GetSpeaker(k.Name)

		if not speaker then
			continue
		end

		for i = 1, #v4 do
			if v4[i] == p.UserId then
				speaker:AddMutedSpeaker(p.Name)
			end
		end
	end
end)

Players.PlayerRemoving:connect(function(p)
	v3[p] = nil
end)

v2.SetBlockedUserIdsRequest.OnServerEvent:Connect(function(p, list)
	if type(list) ~= "table" then
		return
	end

	local v4 = {}
	local speaker = ChatService:GetSpeaker(p.Name)

	if speaker then
		for i = 1, math.min(#list, 50) do
			if type(list[i]) ~= "number" then
				continue
			end

			table.insert(v4, list[i])

			local playerByUserId = Players:GetPlayerByUserId(list[i])

			if playerByUserId then
				speaker:AddMutedSpeaker(playerByUserId.Name)
			end
		end

		v3[p] = v4
	end
end)

v2.GetInitDataRequest.OnServerInvoke = function(p)
	local speaker = ChatService:GetSpeaker(p.Name)

	if not (speaker and speaker:GetPlayer()) then
		CreatePlayerSpeakerObject(p)
		speaker = ChatService:GetSpeaker(p.Name)
	end

	local v4 = { Channels = {}, SpeakerExtraData = {} }

	for _, v5 in pairs(speaker:GetChannelList()) do
		local channel = ChatService:GetChannel(v5)

		if not channel then
			continue
		end

		local v6 = {
			v5,
			channel:GetWelcomeMessageForSpeaker(speaker),
			channel:GetHistoryLogForSpeaker(speaker),
			channel.ChannelNameColor
		}

		table.insert(v4.Channels, v6)
	end

	for _, v5 in pairs(ChatService:GetSpeakerList()) do
		local speaker2 = ChatService:GetSpeaker(v5)
		v4.SpeakerExtraData[v5] = speaker2.ExtraData
	end

	return v4
end

local function DoJoinCommand(p, p2, p3)
	local speaker = ChatService:GetSpeaker(p)
	local channel = ChatService:GetChannel(p2)

	if speaker then
		if channel then
			if not channel.Joinable then
				speaker:SendSystemMessage(
					v:FormatMessageToSend(
						"GameChat_ChatServiceRunner_YouCannotJoinChannel",
						"You cannot join channel '" .. p2 .. "'.",
						"RBX_NAME",
						p2
					),
					p3
				)
				return
			end

			if not speaker:IsInChannel(channel.Name) then
				speaker:JoinChannel(channel.Name)
				return
			end

			speaker:SetMainChannel(channel.Name)
			speaker:SendSystemMessage(
				v:FormatMessageToSend(
					"GameChat_SwitchChannel_NowInChannel",
					string.format("You are now chatting in channel: '%s'", channel.Name),
					"RBX_NAME",
					channel.Name
				),
				channel.Name
			)
		else
			speaker:SendSystemMessage(
				v:FormatMessageToSend(
					"GameChat_ChatServiceRunner_ChannelDoesNotExist",
					"Channel '" .. p2 .. "' does not exist.",
					"RBX_NAME",
					p2
				),
				p3
			)
		end
	end
end

local function DoLeaveCommand(p, p2, p3)
	local speaker = ChatService:GetSpeaker(p)
	local channel = ChatService:GetChannel(p2)

	if speaker then
		if speaker:IsInChannel(p2) then
			if not channel.Leavable then
				speaker:SendSystemMessage(
					v:FormatMessageToSend(
						"GameChat_ChatServiceRunner_YouCannotLeaveChannel",
						"You cannot leave channel '" .. p2 .. "'.",
						"RBX_NAME",
						p2
					),
					p3
				)
				return
			end

			speaker:LeaveChannel(channel.Name)
			speaker:SendSystemMessage(
				v:FormatMessageToSend(
					"GameChat_ChatService_YouHaveLeftChannel",
					string.format("You have left channel '%s'", p2),
					"RBX_NAME",
					channel.Name
				),
				"System"
			)
		else
			speaker:SendSystemMessage(
				v:FormatMessageToSend(
					"GameChat_ChatServiceRunner_YouAreNotInChannel",
					"You are not in channel '" .. p2 .. "'.",
					"RBX_NAME",
					p2
				),
				p3
			)
		end
	end
end

ChatService:RegisterProcessCommandsFunction("default_commands", function(p, value, p2): boolean
	if string.sub(value, 1, 6):lower() == "/join " then
		DoJoinCommand(p, string.sub(value, 7), p2)
		return true
	end

	if string.sub(value, 1, 3):lower() == "/j " then
		DoJoinCommand(p, string.sub(value, 4), p2)
		return true
	end

	if string.sub(value, 1, 7):lower() == "/leave " then
		DoLeaveCommand(p, string.sub(value, 8), p2)
		return true
	end

	if string.sub(value, 1, 3):lower() ~= "/l " then
		return false
	end

	DoLeaveCommand(p, string.sub(value, 4), p2)
	return true
end)

if ChatSettings.GeneralChannelName and ChatSettings.GeneralChannelName ~= "" then
	local v4 = ChatService:AddChannel(ChatSettings.GeneralChannelName)

	v4.Leavable = false
	v4.AutoJoin = true

	v4:RegisterGetWelcomeMessageFunction(function(object)
		if RunService:IsStudio() then
			return nil
		end

		local player = object:GetPlayer()

		if player then
			local success, result = pcall(function()
				return Chat:CanUserChatAsync(player.UserId)
			end)

			if success and not result then
				return ""
			end
		end
	end)
end

local v4 = ChatService:AddChannel("System")
v4.Leavable = false
v4.AutoJoin = true
v4.WelcomeMessage = v:FormatMessageToSend(
	"GameChat_ChatServiceRunner_SystemChannelWelcomeMessage",
	"This channel is for system and game notifications."
)

v4.SpeakerJoined:connect(function(p)
	v4:MuteSpeaker(p)
end)

local function TryRunModule(moduleScript)
	if moduleScript:IsA("ModuleScript") then
		local module = require(moduleScript)

		if type(module) == "function" then
			module(ChatService)
		end
	end
end

local ChatModules = Chat:WaitForChild("ChatModules")
ChatModules.ChildAdded:connect(function(p)
	local success, result = pcall(TryRunModule, p)

	if not success and result then
		print("Error running module " .. p.Name .. ": " .. result)
	end
end)

for _, child in pairs(ChatModules:GetChildren()) do
	local success, result = pcall(TryRunModule, child)

	if success or not result then
		continue
	end

	print("Error running module " .. child.Name .. ": " .. result)
end

Players.PlayerRemoving:connect(function(p)
	if ChatService:GetSpeaker(p.Name) then
		ChatService:RemoveSpeaker(p.Name)
	end
end)
