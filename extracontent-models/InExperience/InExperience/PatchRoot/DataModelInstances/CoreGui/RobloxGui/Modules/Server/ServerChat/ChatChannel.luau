local success, result = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserShouldMuteUnfilteredMessage")
end)
local v = success and result

local success2, result2 = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserRemoveMessageOnTextFilterFailures")
end)

local v2 = success2 and result2

local success3, result3 = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserIsChatTranslationEnabled2")
end)

local v3 = success3 and result3

local ChatChannel = {}

local parent = script.Parent
local Chat = game:GetService("Chat")
local RunService = game:GetService("RunService")
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))

local ChatConstants = require(ClientChatModules:WaitForChild("ChatConstants"))
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

local class = {}
class.__index = class

function class:SendSystemMessage(p, p2)
	local internalCreateMessageObject = self:InternalCreateMessageObject(p, nil, true, p2)

	local success4, result4 = pcall(function()
		self.eMessagePosted:Fire(internalCreateMessageObject)
	end)

	if not success4 and result4 then
		print("Error posting message: " .. result4)
	end

	self:InternalAddMessageToHistoryLog(internalCreateMessageObject)

	for _, speaker in pairs(self.Speakers) do
		speaker:InternalSendSystemMessage(internalCreateMessageObject, self.Name)
	end

	return internalCreateMessageObject
end

function class:SendSystemMessageToSpeaker(p, p2, p3)
	local speaker = self.Speakers[p2]

	if speaker then
		speaker:InternalSendSystemMessage(self:InternalCreateMessageObject(p, nil, true, p3), self.Name)
	elseif RunService:IsStudio() then
		warn(string.format("Speaker '%s' is not in channel '%s' and cannot be sent a system message", p2, self.Name))
	end
end

function class:SendMessageObjToFilters(message, p, p2)
	local message2 = p.Message
	p.Message = message
	self:InternalDoMessageFilter(p2.Name, p, self.Name)
	self.ChatService:InternalDoMessageFilter(p2.Name, p, self.Name)
	local message3 = p.Message
	p.Message = message2
	return message3
end

function class:CanCommunicateByUserId(p, p2)
	if RunService:IsStudio() or (p == 0 or p2 == 0) then
		return true
	end

	local success4, result4 = pcall(function()
		return Chat:CanUsersChatAsync(p, p2)
	end)

	return success4 and result4
end

function class:CanCommunicate(object, object2)
	local player = object:GetPlayer()
	local player2 = object2:GetPlayer()

	if player and player2 then
		return self:CanCommunicateByUserId(player.UserId, player2.UserId)
	end

	return true
end

function class:SendMessageToSpeaker(p, p2, p3, p4)
	local speaker = self.Speakers[p2]
	local speaker2 = self.ChatService:GetSpeaker(p3)

	if speaker and speaker2 then
		if speaker:IsSpeakerMuted(p3) or not self:CanCommunicate(speaker, speaker2) then
			return
		end

		local internalCreateMessageObject = self:InternalCreateMessageObject(p, p3, p2 == p3, p4)
		local v5 = self:SendMessageObjToFilters(p, internalCreateMessageObject, p3)
		speaker:InternalSendMessage(internalCreateMessageObject, self.Name)

		local privateChat = self.Private and Enum.TextFilterContext.PrivateChat or Enum.TextFilterContext.PublicChat
		local internalApplyRobloxFilterNewAPI, isFilterResult, filterResult = self.ChatService:InternalApplyRobloxFilterNewAPI(
			internalCreateMessageObject.FromSpeaker,
			v5,
			privateChat
		)

		if internalApplyRobloxFilterNewAPI then
			internalCreateMessageObject.FilterResult = filterResult
			internalCreateMessageObject.IsFilterResult = isFilterResult
			internalCreateMessageObject.IsFiltered = true
			speaker:InternalSendFilteredMessageWithFilterResult(internalCreateMessageObject, self.Name)
		end
	elseif RunService:IsStudio() then
		warn(string.format("Speaker '%s' is not in channel '%s' and cannot be sent a message", p2, self.Name))
	end
end

function class:KickSpeaker(p, p2)
	local speaker = self.ChatService:GetSpeaker(p)

	if not speaker then
		error("Speaker \"" .. p .. "\" does not exist!")
	end

	local nameForDisplay = speaker:GetNameForDisplay()
	local v5, v6

	if p2 then
		v5 = string.format("You were kicked from '%s' for the following reason(s): %s", self.Name, p2)
		v6 = string.format("%s was kicked for the following reason(s): %s", nameForDisplay, p2)
	else
		v5 = string.format("You were kicked from '%s'", self.Name)
		v6 = string.format("%s was kicked", nameForDisplay)
	end

	self:SendSystemMessageToSpeaker(v5, p)
	speaker:LeaveChannel(self.Name)
	self:SendSystemMessage(v6)
end

function class:MuteSpeaker(value, p, p2)
	local speaker = self.ChatService:GetSpeaker(value)

	if not speaker then
		error("Speaker \"" .. value .. "\" does not exist!")
	end

	self.Mutes[value:lower()] = (p2 == 0 or p2 == nil) and 0 or os.time() + p2

	if p then
		local nameForDisplay = speaker:GetNameForDisplay()

		self:SendSystemMessage(string.format("%s was muted for the following reason(s): %s", nameForDisplay, p))
	end

	local success4, result4 = pcall(function()
		self.eSpeakerMuted:Fire(value, p, p2)
	end)

	if not success4 and result4 then
		print("Error mutting speaker: " .. result4)
	end

	local speaker2 = self.ChatService:GetSpeaker(value)

	if speaker2 then
		local success5, result5 = pcall(function()
			speaker2.eMuted:Fire(self.Name, p, p2)
		end)

		if not success5 and result5 then
			print("Error mutting speaker: " .. result5)
		end
	end
end

function class:UnmuteSpeaker(value)
	if not self.ChatService:GetSpeaker(value) then
		error("Speaker \"" .. value .. "\" does not exist!")
	end

	self.Mutes[value:lower()] = nil

	local success4, result4 = pcall(function()
		self.eSpeakerUnmuted:Fire(value)
	end)

	if not success4 and result4 then
		print("Error unmuting speaker: " .. result4)
	end

	local speaker = self.ChatService:GetSpeaker(value)

	if speaker then
		local success5, result5 = pcall(function()
			speaker.eUnmuted:Fire(self.Name)
		end)

		if not success5 and result5 then
			print("Error unmuting speaker: " .. result5)
		end
	end
end

function class:IsSpeakerMuted(value): boolean
	return self.Mutes[value:lower()] ~= nil
end

function class.GetSpeakerList(p)
	local names = {}

	for _, speaker in pairs(p.Speakers) do
		table.insert(names, speaker.Name)
	end

	return names
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

function class.RegisterProcessCommandsFunction(p, p2, p3, p4)
	if p.ProcessCommandsFunctions:HasFunction(p2) then
		error(string.format("ProcessCommandsFunction '%s' already exists", p2))
	end

	p.ProcessCommandsFunctions:AddFunction(p2, p3, p4)
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

local function ShallowCopy(items) -- 3 equivalent calls inferred from this helper
	local result4 = {}

	for k, item in pairs(items) do
		result4[k] = item
	end

	return result4
end

function class.GetHistoryLog(p)
	return ShallowCopy(p.ChatHistory) -- inferred equivalent call
end

function class:GetHistoryLogForSpeaker(object)
	local player = object:GetPlayer()

	local v5 = not player and -1 or player.UserId

	local historyLogForSpeaker = {}

	for i = 1, #self.ChatHistory do
		if not self:CanCommunicateByUserId(v5, self.ChatHistory[i].SpeakerUserId) then
			continue
		end

		local shallowCopy = ShallowCopy(self.ChatHistory[i]) -- inferred equivalent call

		if
			shallowCopy.MessageType == ChatConstants.MessageTypeDefault
			or shallowCopy.MessageType == ChatConstants.MessageTypeMeCommand
		then
			local filterResult = shallowCopy.FilterResult

			if shallowCopy.IsFilterResult then
				if player then
					shallowCopy.Message = filterResult:GetChatForUserAsync(player.UserId)
				else
					shallowCopy.Message = filterResult:GetNonChatStringForBroadcastAsync()
				end
			else
				shallowCopy.Message = filterResult
			end
		end

		table.insert(historyLogForSpeaker, shallowCopy)
	end

	return historyLogForSpeaker
end

function class.InternalDestroy(data)
	for _, speaker in pairs(data.Speakers) do
		speaker:LeaveChannel(data.Name)
	end

	data.eDestroyed:Fire()

	data.eDestroyed:Destroy()
	data.eMessagePosted:Destroy()
	data.eSpeakerJoined:Destroy()
	data.eSpeakerLeft:Destroy()
	data.eSpeakerMuted:Destroy()
	data.eSpeakerUnmuted:Destroy()
end

function class:InternalDoMessageFilter(p, p2, p3)
	local iterator = self.FilterMessageFunctions:GetIterator()

	for k, v5, _ in iterator do
		local success4, result4 = pcall(function()
			v5(p, p2, p3)
		end)

		if not success4 then
			warn(string.format("DoMessageFilter Function '%s' failed for reason: %s", k, result4))
		end
	end
end

function class:InternalDoProcessCommands(p, p2, p3): boolean
	local iterator = self.ProcessCommandsFunctions:GetIterator()

	for k, v5, _ in iterator do
		local success4, result4 = pcall(function()
			local v6 = v5(p, p2, p3)

			if type(v6) ~= "boolean" then
				error("Process command functions must return a bool")
			end

			return v6
		end)

		if success4 then
			if result4 then
				return true
			end
		else
			warn(string.format("DoProcessCommands Function '%s' failed for reason: %s", k, result4))
		end
	end

	return false
end

function getLanguageCodeFromLocale(value)
	return string.gmatch(value, "[^-]+")() or "en"
end

function class:InternalPostMessage(object, message, p)
	if self:InternalDoProcessCommands(object.Name, message, self.Name) then
		return false
	end

	if self.Mutes[object.Name:lower()] ~= nil then
		local mute = self.Mutes[object.Name:lower()]

		if mute > 0 and mute < os.time() then
			self:UnmuteSpeaker(object.Name)
		else
			self:SendSystemMessageToSpeaker(
				v4:FormatMessageToSend(
					"GameChat_ChatChannel_MutedInChannel",
					"You are muted and cannot talk in this channel"
				),
				object.Name
			)
			return false
		end
	end

	local v5 = self:InternalCreateMessageObject(message, object.Name, false, p)

	v5.Message = message
	local v6 = nil
	pcall(function()
		v6 = Chat:InvokeChatCallback(Enum.ChatCallbackType.OnServerReceivingMessage, v5)
	end)
	v5.Message = nil

	if v6 then
		if v6.ShouldDeliver == false then
			return false
		end

		v5 = v6
	end

	local message2 = self:SendMessageObjToFilters(message, v5, object)

	local names = {}

	for _, speaker in pairs(self.Speakers) do
		if speaker:IsSpeakerMuted(object.Name) or not self:CanCommunicate(object, speaker) then
			continue
		end

		table.insert(names, speaker.Name)

		if speaker.Name == object.Name then
			local shallowCopy = ShallowCopy(v5) -- inferred equivalent call

			if v then
				local messageLengthUtf8 = v5.MessageLengthUtf8 or v5.MessageLength
				shallowCopy.Message = string.rep("_", messageLengthUtf8)
			else
				shallowCopy.Message = message2
			end

			shallowCopy.IsFiltered = true

			speaker:InternalSendMessage(shallowCopy, self.Name)
		else
			speaker:InternalSendMessage(v5, self.Name)
		end
	end

	local success4, result4 = pcall(function()
		self.eMessagePosted:Fire(v5)
	end)

	if not success4 and result4 then
		print("Error posting message: " .. result4)
	end

	local privateChat = self.Private and Enum.TextFilterContext.PrivateChat or Enum.TextFilterContext.PublicChat
	local v7 = nil

	if v3 then
		local set = {}
		local v8 = {}

		for _, speaker in pairs(self.Speakers) do
			local player = speaker:GetPlayer()

			if player ~= nil and player.LocaleId ~= nil then
				set[getLanguageCodeFromLocale(player.LocaleId)] = true
			end
		end

		for k, _ in set do
			table.insert(v8, k)
		end

		local internalApplyRobloxFilterAndTranslate, isFilterResult, filterResult = self.ChatService:InternalApplyRobloxFilterAndTranslate(
			v5.FromSpeaker,
			v8,
			message2,
			privateChat
		)

		if internalApplyRobloxFilterAndTranslate then
			if isFilterResult then
				v5.FilterResult = filterResult.SourceText
			else
				v5.FilterResult = filterResult
			end

			v5.IsFilterResult = isFilterResult

			if isFilterResult then
				v7 = filterResult
			end
		else
			if not v2 then
				return false
			end

			v5.IsFilterResult = false
			v5.FilterResult = ""
			v5.MessageLength = 0
		end
	else
		local internalApplyRobloxFilterNewAPI, isFilterResult, filterResult = self.ChatService:InternalApplyRobloxFilterNewAPI(
			v5.FromSpeaker,
			message2,
			privateChat
		)

		if internalApplyRobloxFilterNewAPI then
			v5.FilterResult = filterResult
			v5.IsFilterResult = isFilterResult
		else
			if not v2 then
				return false
			end

			v5.IsFilterResult = false
			v5.FilterResult = ""
			v5.MessageLength = 0
		end
	end

	v5.IsFiltered = true
	self:InternalAddMessageToHistoryLog(v5)

	for _, v8 in pairs(names) do
		local speaker = self.Speakers[v8]

		if not speaker then
			continue
		end

		local v9 = v3

		if v9 then
			if v7 then
				if object:GetPlayer() == nil or speaker:GetPlayer() == nil then
					v9 = false
				else
					v9 = object:GetPlayer().LocaleId ~= speaker:GetPlayer().LocaleId
				end
			else
				v9 = v7
			end
		end

		if v9 then
			speaker:InternalSendFilteredMessageWithTranslatedFilterResult(v5, self.Name, v7)
		else
			speaker:InternalSendFilteredMessageWithFilterResult(v5, self.Name)
		end
	end

	local names2 = {}

	for _, speaker in pairs(self.Speakers) do
		if speaker:IsSpeakerMuted(object.Name) or not self:CanCommunicate(object, speaker) then
			continue
		end

		local v8 = false

		for _, v9 in pairs(names) do
			if speaker.Name == v9 then
				v8 = true
				break
			end
		end

		if not v8 then
			table.insert(names2, speaker.Name)
		end
	end

	for _, v8 in pairs(names2) do
		local speaker = self.Speakers[v8]

		if speaker then
			speaker:InternalSendFilteredMessageWithFilterResult(v5, self.Name)
		end
	end

	return v5
end

function class.InternalAddSpeaker(p, p2)
	if p.Speakers[p2.Name] then
		warn("Speaker \"" .. p2.name .. "\" is already in the channel!")
		return
	end

	p.Speakers[p2.Name] = p2
	local success4, result4 = pcall(function()
		p.eSpeakerJoined:Fire(p2.Name)
	end)

	if not success4 and result4 then
		print("Error removing channel: " .. result4)
	end
end

function class.InternalRemoveSpeaker(p, p2)
	if not p.Speakers[p2.Name] then
		warn("Speaker \"" .. p2.name .. "\" is not in the channel!")
		return
	end

	p.Speakers[p2.Name] = nil
	local success4, result4 = pcall(function()
		p.eSpeakerLeft:Fire(p2.Name)
	end)

	if not success4 and result4 then
		print("Error removing speaker: " .. result4)
	end
end

function class:InternalRemoveExcessMessagesFromLog()
	local remove = table.remove

	while #self.ChatHistory > self.MaxHistory do
		remove(self.ChatHistory, 1)
	end
end

function class:InternalAddMessageToHistoryLog(p)
	table.insert(self.ChatHistory, p)

	self:InternalRemoveExcessMessagesFromLog()
end

function class:GetMessageType(_, p)
	if p == nil then
		return ChatConstants.MessageTypeSystem
	end

	return ChatConstants.MessageTypeDefault
end

function class:InternalCreateMessageObject(value, fromSpeaker, isFiltered, items)
	local messageType = self:GetMessageType(value, fromSpeaker)

	local speakerUserId = -1
	local nameForDisplay = nil
	local speaker

	if fromSpeaker then
		speaker = self.ChatService:GetSpeaker(fromSpeaker)

		if speaker then
			local player = speaker:GetPlayer()

			if player then
				speakerUserId = player.UserId

				if ChatSettings.PlayerDisplayNamesEnabled then
					nameForDisplay = speaker:GetNameForDisplay()
				end
			else
				speakerUserId = 0
			end
		end
	end

	local v5 = {
		ID = self.ChatService:InternalGetUniqueMessageId(),
		FromSpeaker = fromSpeaker,
		SpeakerDisplayName = nameForDisplay,
		SpeakerUserId = speakerUserId,
		OriginalChannel = self.Name,
		MessageLength = string.len(value),
		MessageLengthUtf8 = utf8.len(utf8.nfcnormalize(value)),
		MessageType = messageType,
		IsFiltered = isFiltered,
		Message = isFiltered and value or nil,
		Time = os.time(),
		ExtraData = {}
	}

	if speaker then
		for k, v6 in pairs(speaker.ExtraData) do
			v5.ExtraData[k] = v6
		end
	end

	if items then
		for k, item in pairs(items) do
			v5.ExtraData[k] = item
		end
	end

	return v5
end

function class:SetChannelNameColor(channelNameColor)
	self.ChannelNameColor = channelNameColor

	for _, speaker in pairs(self.Speakers) do
		speaker:UpdateChannelNameColor(self.Name, channelNameColor)
	end
end

function class.GetWelcomeMessageForSpeaker(p, p2)
	return p.GetWelcomeMessageFunction and p.GetWelcomeMessageFunction(p2) or p.WelcomeMessage
end

function class:RegisterGetWelcomeMessageFunction(getWelcomeMessageFunction)
	if type(getWelcomeMessageFunction) ~= "function" then
		error("RegisterGetWelcomeMessageFunction must be called with a function.")
	end

	self.GetWelcomeMessageFunction = getWelcomeMessageFunction
end

function class:UnRegisterGetWelcomeMessageFunction()
	self.GetWelcomeMessageFunction = nil
end

function ChatChannel.new(chatService, name, value, channelNameColor)
	local self = setmetatable({}, class)

	self.ChatService = chatService

	self.Name = name
	self.WelcomeMessage = value or ""
	self.GetWelcomeMessageFunction = nil
	self.ChannelNameColor = channelNameColor

	self.Joinable = true
	self.Leavable = true
	self.AutoJoin = false
	self.Private = false

	self.Speakers = {}
	self.Mutes = {}

	self.MaxHistory = 200
	self.HistoryIndex = 0
	self.ChatHistory = {}

	self.FilterMessageFunctions = Util:NewSortedFunctionContainer()
	self.ProcessCommandsFunctions = Util:NewSortedFunctionContainer()

	self.eDestroyed = Instance.new("BindableEvent")
	self.eMessagePosted = Instance.new("BindableEvent")
	self.eSpeakerJoined = Instance.new("BindableEvent")
	self.eSpeakerLeft = Instance.new("BindableEvent")
	self.eSpeakerMuted = Instance.new("BindableEvent")
	self.eSpeakerUnmuted = Instance.new("BindableEvent")

	self.MessagePosted = self.eMessagePosted.Event
	self.SpeakerJoined = self.eSpeakerJoined.Event
	self.SpeakerLeft = self.eSpeakerLeft.Event
	self.SpeakerMuted = self.eSpeakerMuted.Event
	self.SpeakerUnmuted = self.eSpeakerUnmuted.Event
	self.Destroyed = self.eDestroyed.Event

	return self
end

return ChatChannel
