local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _script = script
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Chat = game:GetService("Chat")
local ChatService = require(_script:WaitForChild("ChatService"))
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))
local ChatLocalization = nil

pcall(function() -- line: 20
	-- upvalues: ChatLocalization (ref), Chat (copy)
	ChatLocalization = require(Chat.ClientChatModules.ChatLocalization)
end)
ChatLocalization = ChatLocalization or {}

local v10 = ChatSettings.MaxChannelNameCheckLength or 50
local MaximumMessageLength = ChatSettings.MaximumMessageLength

if not ChatLocalization.FormatMessageToSend or not ChatLocalization.LocalizeFormattedMessage then
	function ChatLocalization.FormatMessageToSend(_, _, p3) -- line: 28
		return p3
	end
end

local t1 = {}
local DefaultChatSystemChatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")

if not DefaultChatSystemChatEvents then
	DefaultChatSystemChatEvents = Instance.new("Folder")
	DefaultChatSystemChatEvents.Name = "DefaultChatSystemChatEvents"
	DefaultChatSystemChatEvents.Archivable = false
	DefaultChatSystemChatEvents.Parent = ReplicatedStorage
end

local function validateMessageLength(p4) -- line: 43
	-- upvalues: MaximumMessageLength (copy)
	if p4:len() > MaximumMessageLength * 6 then
		return false
	end

	if utf8.len(p4) == nil then
		return false
	end

	if utf8.len(utf8.nfcnormalize(p4)) > MaximumMessageLength then
		return false
	end

	return true
end
local function validateChannelNameLength(p5) -- line: 59
	-- upvalues: v10 (copy)
	if p5:len() > v10 * 6 then
		return false
	end

	if utf8.len(p5) == nil then
		return false
	end

	if utf8.len(utf8.nfcnormalize(p5)) > v10 then
		return false
	end

	return true
end
local function emptyFunction() -- line: 77
end
local function GetObjectWithNameAndType(p6, p7, p8) -- line: 81
	for _, child in pairs(p6:GetChildren()) do
		if child:IsA(p8) and p7 == child.Name then
			return child
		end
	end

	return nil
end
local function CreateIfDoesntExist(p9, p10, p11) -- line: 91
	-- upvalues: GetObjectWithNameAndType (copy), t1 (copy)
	local v60 = GetObjectWithNameAndType(p9, p10, p11)

	if not v60 then
		v60 = Instance.new(p11)
		v60.Name = p10
		v60.Parent = p9
	end

	t1[p10] = v60

	return v60
end
local function CreateEventIfItDoesntExist(p12, p13) -- line: 104
	-- upvalues: GetObjectWithNameAndType (copy), t1 (copy), emptyFunction (copy)
	local v63 = GetObjectWithNameAndType(p12, p13, "RemoteEvent")

	if not v63 then
		v63 = Instance.new("RemoteEvent")
		v63.Name = p13
		v63.Parent = p12
	end

	t1[p13] = v63
	v63.OnServerEvent:Connect(emptyFunction)

	return v63
end

local v20 = GetObjectWithNameAndType(DefaultChatSystemChatEvents, "OnNewMessage", "RemoteEvent")

if not v20 then
	v20 = Instance.new("RemoteEvent")
	v20.Name = "OnNewMessage"
	v20.Parent = DefaultChatSystemChatEvents
end

t1.OnNewMessage = v20
v20.OnServerEvent:Connect(emptyFunction)

local v21 = GetObjectWithNameAndType(DefaultChatSystemChatEvents, "OnMessageDoneFiltering", "RemoteEvent")

if not v21 then
	v21 = Instance.new("RemoteEvent")
	v21.Name = "OnMessageDoneFiltering"
	v21.Parent = DefaultChatSystemChatEvents
end

t1.OnMessageDoneFiltering = v21
v21.OnServerEvent:Connect(emptyFunction)

local v22 = GetObjectWithNameAndType(DefaultChatSystemChatEvents, "OnNewSystemMessage", "RemoteEvent")

if not v22 then
	v22 = Instance.new("RemoteEvent")
	v22.Name = "OnNewSystemMessage"
	v22.Parent = DefaultChatSystemChatEvents
end

t1.OnNewSystemMessage = v22
v22.OnServerEvent:Connect(emptyFunction)

local v23 = GetObjectWithNameAndType(DefaultChatSystemChatEvents, "OnChannelJoined", "RemoteEvent")

if not v23 then
	v23 = Instance.new("RemoteEvent")
	v23.Name = "OnChannelJoined"
	v23.Parent = DefaultChatSystemChatEvents
end

t1.OnChannelJoined = v23
v23.OnServerEvent:Connect(emptyFunction)

local v24 = GetObjectWithNameAndType(DefaultChatSystemChatEvents, "OnChannelLeft", "RemoteEvent")

if not v24 then
	v24 = Instance.new("RemoteEvent")
	v24.Name = "OnChannelLeft"
	v24.Parent = DefaultChatSystemChatEvents
end

t1.OnChannelLeft = v24
v24.OnServerEvent:Connect(emptyFunction)

local v25 = GetObjectWithNameAndType(DefaultChatSystemChatEvents, "OnMuted", "RemoteEvent")

if not v25 then
	v25 = Instance.new("RemoteEvent")
	v25.Name = "OnMuted"
	v25.Parent = DefaultChatSystemChatEvents
end

t1.OnMuted = v25
v25.OnServerEvent:Connect(emptyFunction)

local v26 = GetObjectWithNameAndType(DefaultChatSystemChatEvents, "OnUnmuted", "RemoteEvent")

if not v26 then
	v26 = Instance.new("RemoteEvent")
	v26.Name = "OnUnmuted"
	v26.Parent = DefaultChatSystemChatEvents
end

t1.OnUnmuted = v26
v26.OnServerEvent:Connect(emptyFunction)

local v27 = GetObjectWithNameAndType(DefaultChatSystemChatEvents, "OnMainChannelSet", "RemoteEvent")

if not v27 then
	v27 = Instance.new("RemoteEvent")
	v27.Name = "OnMainChannelSet"
	v27.Parent = DefaultChatSystemChatEvents
end

t1.OnMainChannelSet = v27
v27.OnServerEvent:Connect(emptyFunction)

local v28 = GetObjectWithNameAndType(DefaultChatSystemChatEvents, "ChannelNameColorUpdated", "RemoteEvent")

if not v28 then
	v28 = Instance.new("RemoteEvent")
	v28.Name = "ChannelNameColorUpdated"
	v28.Parent = DefaultChatSystemChatEvents
end

t1.ChannelNameColorUpdated = v28
v28.OnServerEvent:Connect(emptyFunction)

local v29 = GetObjectWithNameAndType(DefaultChatSystemChatEvents, "SayMessageRequest", "RemoteEvent")

if not v29 then
	v29 = Instance.new("RemoteEvent")
	v29.Name = "SayMessageRequest"
	v29.Parent = DefaultChatSystemChatEvents
end

t1.SayMessageRequest = v29
v29.OnServerEvent:Connect(emptyFunction)

local v30 = GetObjectWithNameAndType(DefaultChatSystemChatEvents, "SetBlockedUserIdsRequest", "RemoteEvent")

if not v30 then
	v30 = Instance.new("RemoteEvent")
	v30.Name = "SetBlockedUserIdsRequest"
	v30.Parent = DefaultChatSystemChatEvents
end

t1.SetBlockedUserIdsRequest = v30
v30.OnServerEvent:Connect(emptyFunction)

local v31 = GetObjectWithNameAndType(DefaultChatSystemChatEvents, "GetInitDataRequest", "RemoteFunction")

if not v31 then
	v31 = Instance.new("RemoteFunction")
	v31.Name = "GetInitDataRequest"
	v31.Parent = DefaultChatSystemChatEvents
end

t1.GetInitDataRequest = v31

local v32 = GetObjectWithNameAndType(DefaultChatSystemChatEvents, "MutePlayerRequest", "RemoteFunction")

if not v32 then
	v32 = Instance.new("RemoteFunction")
	v32.Name = "MutePlayerRequest"
	v32.Parent = DefaultChatSystemChatEvents
end

t1.MutePlayerRequest = v32

local v33 = GetObjectWithNameAndType(DefaultChatSystemChatEvents, "UnMutePlayerRequest", "RemoteFunction")

if not v33 then
	v33 = Instance.new("RemoteFunction")
	v33.Name = "UnMutePlayerRequest"
	v33.Parent = DefaultChatSystemChatEvents
end

t1.UnMutePlayerRequest = v33

local u34 = t1

local function CreatePlayerSpeakerObject(p14) -- line: 128
	-- upvalues: ChatService (copy), u34 (ref)
	if ChatService:GetSpeaker(p14.Name) then
		ChatService:RemoveSpeaker(p14.Name)
	end

	local u65 = ChatService:InternalAddSpeakerWithPlayerObject(p14.Name, p14, false)

	for _, v in pairs(ChatService:GetAutoJoinChannelList()) do
		u65:JoinChannel(v.Name)
	end

	u65:InternalAssignEventFolder(u34)
	u65.ChannelJoined:connect(function(p15, p16) -- line: 145
		-- upvalues: ChatService (copy), u65 (ref), u34 (ref), p14 (copy)
		local HistoryLogForSpeaker = nil
		local ChannelNameColor = nil
		local Channel = ChatService:GetChannel(p15)

		if Channel then
			HistoryLogForSpeaker = Channel:GetHistoryLogForSpeaker(u65)
			ChannelNameColor = Channel.ChannelNameColor
		end

		u34.OnChannelJoined:FireClient(p14, p15, p16, HistoryLogForSpeaker, ChannelNameColor)
	end)
	u65.Muted:connect(function(p17, p18, p19) -- line: 157
		-- upvalues: u34 (ref), p14 (copy)
		u34.OnMuted:FireClient(p14, p17, p18, p19)
	end)
	u65.Unmuted:connect(function(p20) -- line: 161
		-- upvalues: u34 (ref), p14 (copy)
		u34.OnUnmuted:FireClient(p14, p20)
	end)
	ChatService:InternalFireSpeakerAdded(u65.Name)
end

u34.SayMessageRequest.OnServerEvent:connect(function(p21, p22, p23) -- line: 168
	-- upvalues: validateMessageLength (copy), validateChannelNameLength (copy), ChatService (copy)
	if type(p22) ~= "string" then
		return
	end

	if not validateMessageLength(p22) then
		return
	end

	if type(p23) ~= "string" then
		return
	end

	if not validateChannelNameLength(p23) then
		return
	end

	local Speaker = ChatService:GetSpeaker(p21.Name)

	if Speaker then
		return Speaker:SayMessage(p22, p23)
	end

	return nil
end)

function u34.MutePlayerRequest.OnServerInvoke(player, p24) -- line: 189
	-- upvalues: ChatService (copy)
	if type(p24) ~= "string" then
		return
	end

	local Speaker = ChatService:GetSpeaker(player.Name)

	if Speaker then
		local Speaker2 = ChatService:GetSpeaker(p24)

		if Speaker2 then
			Speaker:AddMutedSpeaker(Speaker2.Name)

			return true
		end
	end

	return false
end
function u34.UnMutePlayerRequest.OnServerInvoke(player, p25) -- line: 205
	-- upvalues: ChatService (copy)
	if type(p25) ~= "string" then
		return
	end

	local Speaker = ChatService:GetSpeaker(player.Name)

	if Speaker then
		local Speaker3 = ChatService:GetSpeaker(p25)

		if Speaker3 then
			Speaker:RemoveMutedSpeaker(Speaker3.Name)

			return true
		end
	end

	return false
end

local t2 = {}

Players.PlayerAdded:connect(function(p26) -- line: 224
	-- upvalues: t2 (copy), ChatService (copy)
	for k, v in pairs(t2) do
		local Speaker = ChatService:GetSpeaker(k.Name)

		if Speaker then
			for i = 1, #v do
				if v[i] == p26.UserId then
					Speaker:AddMutedSpeaker(p26.Name)
				end
			end
		end
	end
end)
Players.PlayerRemoving:connect(function(p27) -- line: 238
	-- upvalues: t2 (copy)
	t2[p27] = nil
end)
u34.SetBlockedUserIdsRequest.OnServerEvent:Connect(function(player, p28) -- line: 242
	-- upvalues: ChatService (copy), Players (copy), t2 (copy)
	if type(p28) ~= "table" then
		return
	end

	local t3 = {}
	local Speaker = ChatService:GetSpeaker(player.Name)

	if Speaker then
		for i = 1, math.min(#p28, 50) do
			if type(p28[i]) == "number" then
				table.insert(t3, p28[i])

				local PlayerByUserId = Players:GetPlayerByUserId(p28[i])

				if PlayerByUserId then
					Speaker:AddMutedSpeaker(PlayerByUserId.Name)
				end
			end
		end

		t2[player] = t3
	end
end)

function u34.GetInitDataRequest.OnServerInvoke(player) -- line: 268
	-- upvalues: ChatService (copy), CreatePlayerSpeakerObject (copy)
	local Speaker = ChatService:GetSpeaker(player.Name)

	if not Speaker or not Speaker:GetPlayer() then
		CreatePlayerSpeakerObject(player)
		Speaker = ChatService:GetSpeaker(player.Name)
	end

	local t4 = {
		Channels = {},
		SpeakerExtraData = {}
	}

	for _, v in pairs(Speaker:GetChannelList()) do
		local Channel = ChatService:GetChannel(v)

		if Channel then
			local t5 = {
				v,
				Channel:GetWelcomeMessageForSpeaker(Speaker),
				Channel:GetHistoryLogForSpeaker(Speaker),
				Channel.ChannelNameColor
			}

			table.insert(t4.Channels, t5)
		end
	end

	for _, v in pairs(ChatService:GetSpeakerList()) do
		local Speaker4 = ChatService:GetSpeaker(v)

		t4.SpeakerExtraData[v] = Speaker4.ExtraData
	end

	return t4
end

local function DoJoinCommand(p29, p30, p31) -- line: 302
	-- upvalues: ChatService (copy), ChatLocalization (ref)
	local Speaker = ChatService:GetSpeaker(p29)
	local Channel = ChatService:GetChannel(p30)

	if Speaker then
		if Channel then
			if Channel.Joinable then
				if not Speaker:IsInChannel(Channel.Name) then
					Speaker:JoinChannel(Channel.Name)

					return
				end

				Speaker:SetMainChannel(Channel.Name)
				Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_SwitchChannel_NowInChannel", string.format("You are now chatting in channel: '%s'", Channel.Name), "RBX_NAME", Channel.Name), Channel.Name)

				return
			end

			Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_ChatServiceRunner_YouCannotJoinChannel", "You cannot join channel '" .. p30 .. "'.", "RBX_NAME", p30), p31)

			return
		end

		Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_ChatServiceRunner_ChannelDoesNotExist", "Channel '" .. p30 .. "' does not exist.", "RBX_NAME", p30), p31)
	end
end
local function DoLeaveCommand(p32, p33, p34) -- line: 339
	-- upvalues: ChatService (copy), ChatLocalization (ref)
	local Speaker = ChatService:GetSpeaker(p32)
	local Channel = ChatService:GetChannel(p33)

	if Speaker then
		if Speaker:IsInChannel(p33) then
			if Channel.Leavable then
				Speaker:LeaveChannel(Channel.Name)
				Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_ChatService_YouHaveLeftChannel", string.format("You have left channel '%s'", p33), "RBX_NAME", Channel.Name), "System")

				return
			end

			Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_ChatServiceRunner_YouCannotLeaveChannel", "You cannot leave channel '" .. p33 .. "'.", "RBX_NAME", p33), p34)

			return
		end

		Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_ChatServiceRunner_YouAreNotInChannel", "You are not in channel '" .. p33 .. "'.", "RBX_NAME", p33), p34)
	end
end

ChatService:RegisterProcessCommandsFunction("default_commands", function(p35, p36, p37) -- line: 372
	-- upvalues: DoJoinCommand (copy), DoLeaveCommand (copy)
	if string.sub(p36, 1, 6):lower() == "/join " then
		DoJoinCommand(p35, string.sub(p36, 7), p37)

		return true
	end

	if string.sub(p36, 1, 3):lower() == "/j " then
		DoJoinCommand(p35, string.sub(p36, 4), p37)

		return true
	end

	if string.sub(p36, 1, 7):lower() == "/leave " then
		DoLeaveCommand(p35, string.sub(p36, 8), p37)

		return true
	end

	if string.sub(p36, 1, 3):lower() == "/l " then
		DoLeaveCommand(p35, string.sub(p36, 4), p37)

		return true
	end

	return false
end)

if ChatSettings.GeneralChannelName and ChatSettings.GeneralChannelName ~= "" then
	local v39 = ChatService:AddChannel(ChatSettings.GeneralChannelName)

	v39.Leavable = false
	v39.AutoJoin = true
	v39:RegisterGetWelcomeMessageFunction(function(p38) -- line: 396
		-- upvalues: RunService (copy), Chat (copy)
		if RunService:IsStudio() then
			return nil
		end

		local Player = p38:GetPlayer()

		if Player then
			local ok, result = pcall(function() -- line: 402
				-- upvalues: Chat (copy), Player (copy)
				return Chat:CanUserChatAsync(Player.UserId)
			end)

			if ok and not result then
				return ""
			end
		end
	end)
end

local v40 = ChatService:AddChannel("System")

v40.Leavable = false
v40.AutoJoin = true
v40.WelcomeMessage = ChatLocalization:FormatMessageToSend("GameChat_ChatServiceRunner_SystemChannelWelcomeMessage", "This channel is for system and game notifications.")
v40.SpeakerJoined:connect(function(p39) -- line: 419
	-- upvalues: v40 (copy)
	v40:MuteSpeaker(p39)
end)

local function TryRunModule(p40) -- line: 424
	-- upvalues: ChatService (copy)
	if p40:IsA("ModuleScript") then
		local lib = require(p40)

		if type(lib) == "function" then
			lib(ChatService)
		end
	end
end

local ChatModules = Chat:WaitForChild("ChatModules")

ChatModules.ChildAdded:connect(function(p41) -- line: 434
	-- upvalues: TryRunModule (copy)
	local ok, result = pcall(TryRunModule, p41)

	if not ok and result then
		print("Error running module " .. p41.Name .. ": " .. result)
	end
end)

for _, child in pairs(ChatModules:GetChildren()) do
	local ok, result = pcall(TryRunModule, child)

	if not ok and result then
		print("Error running module " .. child.Name .. ": " .. result)
	end
end

Players.PlayerRemoving:connect(function(p42) -- line: 448
	-- upvalues: ChatService (copy)
	if ChatService:GetSpeaker(p42.Name) then
		ChatService:RemoveSpeaker(p42.Name)
	end
end)
