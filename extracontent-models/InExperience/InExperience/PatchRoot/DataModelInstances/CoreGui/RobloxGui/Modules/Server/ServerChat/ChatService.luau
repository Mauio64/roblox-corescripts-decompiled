local v = { 0.05, 0.1, 0.2 }

local v2 = {}

local RunService = game:GetService("RunService")
local Chat = game:GetService("Chat")
Chat:WaitForChild("ClientChatModules")

local parent = script.Parent
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))

local v3 = {
	ChatColor = ChatSettings.ErrorMessageTextColor or Color3.fromRGB(245, 50, 50)
}

local ChatConstants = require(ClientChatModules:WaitForChild("ChatConstants"))

local ChatChannel = require(parent:WaitForChild("ChatChannel"))
local Speaker = require(parent:WaitForChild("Speaker"))
local Util = require(parent:WaitForChild("Util"))

local v4 = nil

pcall(function()
	local Chat2 = game:GetService("Chat")
	v4 = require(Chat2.ClientChatModules.ChatLocalization)
end)
v4 = v4 or {}

if not (v4.FormatMessageToSend and v4.LocalizeFormattedMessage) then
	function v4:FormatMessageToSend(_, p)
		return p
	end
end

local function allSpaces(value): boolean -- 3 equivalent calls inferred from this helper
	return string.len((string.gsub(value, " ", ""))) == 0
end

local class = {}
class.__index = class

function class:AddChannel(value, autoJoin)
	if self.ChatChannels[value:lower()] then
		error(string.format("Channel %q alrady exists.", value))
	end

	local function DefaultChannelCommands(p, value2): boolean
		if value2:lower() ~= "/leave" then
			return false
		end

		local channel = self:GetChannel(value)
		local speaker = self:GetSpeaker(p)

		if channel and speaker then
			if channel.Leavable then
				speaker:LeaveChannel(value)
				speaker:SendSystemMessage(
					v4:FormatMessageToSend(
						"GameChat_ChatService_YouHaveLeftChannel",
						string.format("You have left channel '%s'", value),
						"RBX_NAME",
						value
					),
					"System"
				)
			else
				speaker:SendSystemMessage(
					v4:FormatMessageToSend("GameChat_ChatService_CannotLeaveChannel", "You cannot leave this channel."),
					value
				)
			end
		end

		return true
	end

	local v5 = ChatChannel.new(self, value)
	self.ChatChannels[value:lower()] = v5

	v5:RegisterProcessCommandsFunction("default_commands", DefaultChannelCommands, ChatConstants.HighPriority)

	local success, result = pcall(function()
		self.eChannelAdded:Fire(value)
	end)

	if not success and result then
		print("Error addding channel: " .. result)
	end

	if autoJoin == nil then
		return v5
	end

	v5.AutoJoin = autoJoin

	if autoJoin then
		for _, speaker in pairs(self.Speakers) do
			speaker:JoinChannel(value)
		end
	end

	return v5
end

function class.RemoveChannel(p, value)
	if p.ChatChannels[value:lower()] then
		local name = p.ChatChannels[value:lower()].Name

		p.ChatChannels[value:lower()]:InternalDestroy()
		p.ChatChannels[value:lower()] = nil

		local success, result = pcall(function()
			p.eChannelRemoved:Fire(name)
		end)

		if not success and result then
			print("Error removing channel: " .. result)
		end
	else
		warn(string.format("Channel %q does not exist.", value))
	end
end

function class:GetChannel(value)
	return self.ChatChannels[value:lower()]
end

function class.AddSpeaker(p, value)
	if p.Speakers[value:lower()] then
		error("Speaker \"" .. value .. "\" already exists!")
	end

	local v5 = Speaker.new(p, value)
	p.Speakers[value:lower()] = v5

	local success, result = pcall(function()
		p.eSpeakerAdded:Fire(value)
	end)

	if not success and result then
		print("Error adding speaker: " .. result)
	end

	return v5
end

function class:InternalUnmuteSpeaker(p)
	for _, chatChannel in pairs(self.ChatChannels) do
		if chatChannel:IsSpeakerMuted(p) then
			chatChannel:UnmuteSpeaker(p)
		end
	end
end

function class:RemoveSpeaker(value)
	if self.Speakers[value:lower()] then
		local name = self.Speakers[value:lower()].Name

		self:InternalUnmuteSpeaker(name)

		self.Speakers[value:lower()]:InternalDestroy()
		self.Speakers[value:lower()] = nil

		local success, result = pcall(function()
			self.eSpeakerRemoved:Fire(name)
		end)

		if not success and result then
			print("Error removing speaker: " .. result)
		end
	else
		warn("Speaker \"" .. value .. "\" does not exist!")
	end
end

function class:GetSpeaker(value)
	return self.Speakers[value:lower()]
end

function class.GetSpeakerByUserOrDisplayName(p, value)
	local speaker = p.Speakers[value:lower()]

	if speaker then
		return speaker
	end

	for _, speaker2 in pairs(p.Speakers) do
		local player = speaker2:GetPlayer()

		if player and player.DisplayName:lower() == value:lower() then
			return speaker2
		end
	end
end

function class.GetChannelList(p)
	local names = {}

	for _, chatChannel in pairs(p.ChatChannels) do
		if not chatChannel.Private then
			table.insert(names, chatChannel.Name)
		end
	end

	return names
end

function class.GetAutoJoinChannelList(p)
	local chatChannels = {}

	for _, chatChannel in pairs(p.ChatChannels) do
		if chatChannel.AutoJoin then
			table.insert(chatChannels, chatChannel)
		end
	end

	return chatChannels
end

function class.GetSpeakerList(p)
	local names = {}

	for _, speaker in pairs(p.Speakers) do
		table.insert(names, speaker.Name)
	end

	return names
end

function class.SendGlobalSystemMessage(p, p2)
	for _, speaker in pairs(p.Speakers) do
		speaker:SendSystemMessage(p2, nil)
	end
end

function class.RegisterFilterMessageFunction(p, p2, p3, p4)
	if p.FilterMessageFunctions:HasFunction(p2) then
		error(string.format("FilterMessageFunction '%s' already exists", p2))
	end

	p.FilterMessageFunctions:AddFunction(p2, p3, p4)
end

function class.FilterMessageFunctionExists(p, p2)
	return p.FilterMessageFunctions:HasFunction(p2)
end

function class.UnregisterFilterMessageFunction(p, p2)
	if not p.FilterMessageFunctions:HasFunction(p2) then
		error(string.format("FilterMessageFunction '%s' does not exists", p2))
	end

	p.FilterMessageFunctions:RemoveFunction(p2)
end

function class:RegisterProcessCommandsFunction(p, p2, p3)
	if self.ProcessCommandsFunctions:HasFunction(p) then
		error(string.format("ProcessCommandsFunction '%s' already exists", p))
	end

	self.ProcessCommandsFunctions:AddFunction(p, p2, p3)
end

function class.ProcessCommandsFunctionExists(p, p2)
	return p.ProcessCommandsFunctions:HasFunction(p2)
end

function class.UnregisterProcessCommandsFunction(p, p2)
	if not p.ProcessCommandsFunctions:HasFunction(p2) then
		error(string.format("ProcessCommandsFunction '%s' does not exist", p2))
	end

	p.ProcessCommandsFunctions:RemoveFunction(p2)
end

local lastTime = 0
local lastTime2 = 0
local count = 0
function class:InternalNotifyFilterIssue()
	if tick() - lastTime2 > 60 then
		count = 0
	end

	count += 1
	lastTime2 = tick()

	if count >= 3 and tick() - lastTime > 60 then
		lastTime = tick()
		local channel = self:GetChannel("System")

		if channel then
			channel:SendSystemMessage(
				v4:FormatMessageToSend(
					"GameChat_ChatService_ChatFilterIssues",
					"The chat filter is currently experiencing issues and messages may be slow to appear."
				),
				v3
			)
		end
	end
end

local set = {}

function class:InternalApplyRobloxFilter(p, value, p2)
	if RunService:IsServer() and not RunService:IsStudio() then
		local speaker = self:GetSpeaker(p)
		local speaker2 = p2 and self:GetSpeaker(p2)

		if speaker == nil then
			return nil
		end

		local player = speaker:GetPlayer()
		local player2 = speaker2 and speaker2:GetPlayer()

		if player == nil or allSpaces(value) then -- inferred equivalent call
			return value
		end

		local lastTime3 = tick()
		local count2 = 0

		while true do
			local success, result = pcall(function()
				if player2 then
					return Chat:FilterStringAsync(value, player, player2)
				end

				return Chat:FilterStringForBroadcast(value, player)
			end)

			if success then
				return result
			end

			warn("Error filtering message:", result)

			count2 += 1

			if count2 > 3 or tick() - lastTime3 > 60 then
				self:InternalNotifyFilterIssue()
				return nil
			end

			local v5 = v[math.min(#v, count2)]

			local v6 = v5 + (math.random() * 2 - 1) * v5
			wait(v6)
		end
	else
		if not set[value] then
			set[value] = true
			wait()
		end

		return value
	end
end

function class:InternalApplyRobloxFilterAndTranslate(p, p2, value, p3)
	if not RunService:IsServer() or RunService:IsStudio() then
		wait()
		return true, false, value
	end

	local speaker = self:GetSpeaker(p)

	if speaker == nil then
		return false, nil, nil
	end

	local player = speaker:GetPlayer()

	if player == nil or allSpaces(value) then -- inferred equivalent call
		return true, false, value
	end

	local success, result = pcall(function()
		local TextService = game:GetService("TextService")
		return (TextService:FilterAndTranslateStringAsync(value, player.UserId, p2, p3))
	end)

	if success then
		return true, true, result
	end

	warn("Error filtering and translating message", value, result)
	self:InternalNotifyFilterIssue()
	return false, nil, nil
end

function class:InternalApplyRobloxFilterNewAPI(p, value, p2)
	if not RunService:IsServer() or RunService:IsStudio() then
		wait()
		return true, false, value
	end

	local speaker = self:GetSpeaker(p)

	if speaker == nil then
		return false, nil, nil
	end

	local player = speaker:GetPlayer()

	if player == nil or allSpaces(value) then -- inferred equivalent call
		return true, false, value
	end

	local success, result = pcall(function()
		local TextService = game:GetService("TextService")
		return (TextService:FilterStringAsync(value, player.UserId, p2))
	end)

	if success then
		return true, true, result
	end

	warn("Error filtering message:", value, result)
	self:InternalNotifyFilterIssue()
	return false, nil, nil
end

function class.InternalDoMessageFilter(p, p2, p3, p4)
	local iterator = p.FilterMessageFunctions:GetIterator()

	for k, v5, _ in iterator do
		local success, result = pcall(function()
			v5(p2, p3, p4)
		end)

		if not success then
			warn(string.format("DoMessageFilter Function '%s' failed for reason: %s", k, result))
		end
	end
end

function class.InternalDoProcessCommands(p, p2, p3, p4): boolean
	local iterator = p.ProcessCommandsFunctions:GetIterator()

	for k, v5, _ in iterator do
		local success, result = pcall(function()
			local v6 = v5(p2, p3, p4)

			if type(v6) ~= "boolean" then
				error("Process command functions must return a bool")
			end

			return v6
		end)

		if success then
			if result then
				return true
			end
		else
			warn(string.format("DoProcessCommands Function '%s' failed for reason: %s", k, result))
		end
	end

	return false
end

function class:InternalGetUniqueMessageId()
	local messageIdCounter = self.MessageIdCounter
	self.MessageIdCounter = messageIdCounter + 1
	return messageIdCounter
end

function class.InternalAddSpeakerWithPlayerObject(p, value, p2, p3)
	if p.Speakers[value:lower()] then
		error("Speaker \"" .. value .. "\" already exists!")
	end

	local v5 = Speaker.new(p, value)
	v5:InternalAssignPlayerObject(p2)
	p.Speakers[value:lower()] = v5

	if p3 then
		local success, result = pcall(function()
			p.eSpeakerAdded:Fire(value)
		end)

		if not success and result then
			print("Error adding speaker: " .. result)
		end
	end

	return v5
end

function class.InternalFireSpeakerAdded(p, p2)
	local success, result = pcall(function()
		p.eSpeakerAdded:Fire(p2)
	end)

	if not success and result then
		print("Error firing speaker added: " .. result)
	end
end

function v2.new()
	local self = setmetatable({}, class)

	self.MessageIdCounter = 0

	self.ChatChannels = {}
	self.Speakers = {}

	self.FilterMessageFunctions = Util:NewSortedFunctionContainer()
	self.ProcessCommandsFunctions = Util:NewSortedFunctionContainer()

	self.eChannelAdded = Instance.new("BindableEvent")
	self.eChannelRemoved = Instance.new("BindableEvent")
	self.eSpeakerAdded = Instance.new("BindableEvent")
	self.eSpeakerRemoved = Instance.new("BindableEvent")

	self.ChannelAdded = self.eChannelAdded.Event
	self.ChannelRemoved = self.eChannelRemoved.Event
	self.SpeakerAdded = self.eSpeakerAdded.Event
	self.SpeakerRemoved = self.eSpeakerRemoved.Event

	self.ChatServiceMajorVersion = 0
	self.ChatServiceMinorVersion = 5

	return self
end

return v2.new()
