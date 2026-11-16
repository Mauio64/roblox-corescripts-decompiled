local Speaker = {}

local RunService = game:GetService("RunService")
local Chat = game:GetService("Chat")
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))

local parent = script.Parent

local success, result = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserRemoveMessageOnTextFilterFailures")
end)

local v = success and result

local _, _ = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserIsChatTranslationEnabled2")
end)

local function ShallowCopy(items) -- 2 equivalent calls inferred from this helper
	local result2 = {}

	for k, item in pairs(items) do
		result2[k] = item
	end

	return result2
end

local class = {}

local v2 = {
	eDestroyed = true,
	eSaidMessage = true,
	eReceivedMessage = true,
	eReceivedUnfilteredMessage = true,
	eMessageDoneFiltering = true,
	eReceivedSystemMessage = true,
	eChannelJoined = true,
	eChannelLeft = true,
	eMuted = true,
	eUnmuted = true,
	eExtraDataUpdated = true,
	eMainChannelSet = true,
	eChannelNameColorUpdated = true
}

local v3 = {
	Destroyed = "eDestroyed",
	SaidMessage = "eSaidMessage",
	ReceivedMessage = "eReceivedMessage",
	ReceivedUnfilteredMessage = "eReceivedUnfilteredMessage",
	RecievedUnfilteredMessage = "eReceivedUnfilteredMessage",
	MessageDoneFiltering = "eMessageDoneFiltering",
	ReceivedSystemMessage = "eReceivedSystemMessage",
	ChannelJoined = "eChannelJoined",
	ChannelLeft = "eChannelLeft",
	Muted = "eMuted",
	Unmuted = "eUnmuted",
	ExtraDataUpdated = "eExtraDataUpdated",
	MainChannelSet = "eMainChannelSet",
	ChannelNameColorUpdated = "eChannelNameColorUpdated"
}

function class.__index(p, p2)
	local v4 = rawget(class, p2)

	if v4 then
		return v4
	end

	if v2[p2] and not rawget(p, p2) then
		rawset(p, p2, Instance.new("BindableEvent"))
	end

	local v5 = v3[p2]

	if v5 and not rawget(p, p2) then
		local v6 = rawget(p, v5)

		if not v6 then
			v6 = Instance.new("BindableEvent")
			rawset(p, v5, v6)
		end

		rawset(p, p2, v6.Event)
	end

	return (rawget(p, p2))
end

function class:LazyFire(p, ...)
	local v4 = rawget(self, p)

	if v4 then
		v4:Fire(...)
	end
end

function class:SayMessage(p, value, p2)
	if self.ChatService:InternalDoProcessCommands(self.Name, p, value) or not value then
		return
	end

	local channel = self.Channels[value:lower()]

	if not channel then
		return
	end

	local internalPostMessage = channel:InternalPostMessage(self, p, p2)

	if internalPostMessage then
		pcall(function()
			self:LazyFire("eSaidMessage", internalPostMessage, value)
		end)
	end

	return internalPostMessage
end

function class.JoinChannel(data, value)
	if data.Channels[value:lower()] then
		warn("Speaker is already in channel \"" .. value .. "\"")
		return
	end

	local channel = data.ChatService:GetChannel(value)

	if not channel then
		error("Channel \"" .. value .. "\" does not exist!")
	end

	data.Channels[value:lower()] = channel
	channel:InternalAddSpeaker(data)
	local success2, result2 = pcall(function()
		data.eChannelJoined:Fire(channel.Name, channel:GetWelcomeMessageForSpeaker(data))
	end)

	if not success2 and result2 then
		print("Error joining channel: " .. result2)
	end
end

function class:LeaveChannel(value)
	if not self.Channels[value:lower()] then
		warn("Speaker is not in channel \"" .. value .. "\"")
		return
	end

	local channel = self.Channels[value:lower()]

	self.Channels[value:lower()] = nil
	channel:InternalRemoveSpeaker(self)
	local success2, result2 = pcall(function()
		self:LazyFire("eChannelLeft", channel.Name)

		if self.PlayerObj then
			self.EventFolder.OnChannelLeft:FireClient(self.PlayerObj, channel.Name)
		end
	end)

	if not success2 and result2 then
		print("Error leaving channel: " .. result2)
	end
end

function class.IsInChannel(p, value): boolean
	return p.Channels[value:lower()] ~= nil
end

function class.GetChannelList(p)
	local names = {}

	for _, channel in pairs(p.Channels) do
		table.insert(names, channel.Name)
	end

	return names
end

function class.SendMessage(p, p2, value, p3, p4)
	local channel = p.Channels[value:lower()]

	if channel then
		channel:SendMessageToSpeaker(p2, p.Name, p3, p4)
	elseif RunService:IsStudio() then
		warn(string.format("Speaker '%s' is not in channel '%s' and cannot receive a message in it.", p.Name, value))
	end
end

function class.SendSystemMessage(p, p2, value, p3)
	local channel = p.Channels[value:lower()]

	if channel then
		channel:SendSystemMessageToSpeaker(p2, p.Name, p3)
	elseif RunService:IsStudio() then
		warn(string.format(
			"Speaker '%s' is not in channel '%s' and cannot receive a system message in it.",
			p.Name,
			value
		))
	end
end

function class:GetPlayer()
	return self.PlayerObj
end

function class:GetNameForDisplay()
	if not ChatSettings.PlayerDisplayNamesEnabled then
		return self.Name
	end

	local player = self:GetPlayer()

	return if player then player.DisplayName else self.Name
end

function class:SetExtraData(p, p2)
	self.ExtraData[p] = p2
	self:LazyFire("eExtraDataUpdated", p, p2)
end

function class.GetExtraData(p, p2)
	return p.ExtraData[p2]
end

function class:SetMainChannel(p)
	local success2, result2 = pcall(function()
		self:LazyFire("eMainChannelSet", p)

		if self.PlayerObj then
			self.EventFolder.OnMainChannelSet:FireClient(self.PlayerObj, p)
		end
	end)

	if not success2 and result2 then
		print("Error setting main channel: " .. result2)
	end
end

function class.AddMutedSpeaker(p, value)
	p.MutedSpeakers[value:lower()] = true
end

function class.RemoveMutedSpeaker(p, value)
	p.MutedSpeakers[value:lower()] = false
end

function class.IsSpeakerMuted(p, value)
	return p.MutedSpeakers[value:lower()]
end

function class:InternalDestroy()
	for _, channel in pairs(self.Channels) do
		channel:InternalRemoveSpeaker(self)
	end

	self.eDestroyed:Fire()

	self.EventFolder = nil
	self.eDestroyed:Destroy()
	self.eSaidMessage:Destroy()
	self.eReceivedMessage:Destroy()
	self.eReceivedUnfilteredMessage:Destroy()
	self.eMessageDoneFiltering:Destroy()
	self.eReceivedSystemMessage:Destroy()
	self.eChannelJoined:Destroy()
	self.eChannelLeft:Destroy()
	self.eMuted:Destroy()
	self.eUnmuted:Destroy()
	self.eExtraDataUpdated:Destroy()
	self.eMainChannelSet:Destroy()
	self.eChannelNameColorUpdated:Destroy()
end

function class:InternalAssignPlayerObject(playerObj)
	self.PlayerObj = playerObj
end

function class:InternalAssignEventFolder(eventFolder)
	self.EventFolder = eventFolder
end

function class:InternalSendMessage(p, p2)
	local success2, result2 = pcall(function()
		self:LazyFire("eReceivedUnfilteredMessage", p, p2)

		if self.PlayerObj then
			self.EventFolder.OnNewMessage:FireClient(self.PlayerObj, p, p2)
		end
	end)

	if not success2 and result2 then
		print("Error sending internal message: " .. result2)
	end
end

function class:InternalSendFilteredMessage(p, p2)
	local success2, result2 = pcall(function()
		self:LazyFire("eReceivedMessage", p, p2)
		self:LazyFire("eMessageDoneFiltering", p, p2)

		if self.PlayerObj then
			self.EventFolder.OnMessageDoneFiltering:FireClient(self.PlayerObj, p, p2)
		end
	end)

	if not success2 and result2 then
		print("Error sending internal filtered message: " .. result2)
	end
end

function class:InternalSendFilteredMessageWithTranslatedFilterResult(items, p, object)
	local shallowCopy = ShallowCopy(items) -- inferred equivalent call
	local filterResult = shallowCopy.FilterResult
	local player = self:GetPlayer()
	local translationForLocale

	if player == nil then
		translationForLocale = nil
	else
		translationForLocale = object:GetTranslationForLocale(player.LocaleId)
	end

	local message = ""
	local translatedMessage = nil
	pcall(function()
		if shallowCopy.IsFilterResult then
			if player then
				message = filterResult:GetChatForUserAsync(player.UserId)

				if translationForLocale then
					translatedMessage = translationForLocale:GetChatForUserAsync(player.UserId)
				end
			else
				message = filterResult:GetNonChatStringForBroadcastAsync()

				if translationForLocale then
					translatedMessage = translationForLocale:GetNonChatStringForBroadcastAsync()
				end
			end
		else
			message = filterResult
		end
	end)

	if v then
		shallowCopy.Message = message

		if translatedMessage then
			shallowCopy.TranslatedMessage = translatedMessage
		end

		shallowCopy.FilterResult = nil
		self:InternalSendFilteredMessage(shallowCopy, p)
	elseif #message > 0 then
		shallowCopy.Message = message

		if translatedMessage then
			shallowCopy.TranslatedMessage = translatedMessage
		end

		shallowCopy.FilterResult = nil
		self:InternalSendFilteredMessage(shallowCopy, p)
	end
end

function class:InternalSendFilteredMessageWithFilterResult(items, p)
	local shallowCopy = ShallowCopy(items) -- inferred equivalent call
	local filterResult = shallowCopy.FilterResult
	local player = self:GetPlayer()

	local message = ""
	pcall(function()
		if not shallowCopy.IsFilterResult then
			message = filterResult
		elseif player then
			message = filterResult:GetChatForUserAsync(player.UserId)
		else
			message = filterResult:GetNonChatStringForBroadcastAsync()
		end
	end)

	if v then
		shallowCopy.Message = message
		shallowCopy.FilterResult = nil
		self:InternalSendFilteredMessage(shallowCopy, p)
	elseif #message > 0 then
		shallowCopy.Message = message
		shallowCopy.FilterResult = nil
		self:InternalSendFilteredMessage(shallowCopy, p)
	end
end

function class:InternalSendSystemMessage(p, p2)
	local success2, result2 = pcall(function()
		self:LazyFire("eReceivedSystemMessage", p, p2)

		if self.PlayerObj then
			self.EventFolder.OnNewSystemMessage:FireClient(self.PlayerObj, p, p2)
		end
	end)

	if not success2 and result2 then
		print("Error sending internal system message: " .. result2)
	end
end

function class:UpdateChannelNameColor(p, p2)
	self:LazyFire("eChannelNameColorUpdated", p, p2)

	if self.PlayerObj then
		self.EventFolder.ChannelNameColorUpdated:FireClient(self.PlayerObj, p, p2)
	end
end

function Speaker.new(chatService, name)
	local self = setmetatable({}, class)

	self.ChatService = chatService

	self.PlayerObj = nil

	self.Name = name
	self.ExtraData = {}

	self.Channels = {}
	self.MutedSpeakers = {}
	self.EventFolder = nil

	return self
end

return Speaker
