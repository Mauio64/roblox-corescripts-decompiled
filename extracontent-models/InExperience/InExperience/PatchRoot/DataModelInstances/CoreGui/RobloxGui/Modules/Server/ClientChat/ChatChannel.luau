local success, result = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserFlagRemoveMessageFromMessageLog")
end)

local v = success and result

local success2, result2 = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserIsChatTranslationEnabled2")
end)

local v2 = success2 and result2

local ChatChannel = {}

local Chat = game:GetService("Chat")
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local parent = script.Parent

local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))
local v3

if v2 then
	v3 = parent:FindFirstChild("ChatTranslationEnabled")

	if v3 == nil then
		local childAddedConnection = nil
		childAddedConnection = parent.ChildAdded:Connect(function(child)
			if child.Name == "ChatTranslationEnabled" then
				v3 = child

				childAddedConnection:Disconnect()
			end
		end)
	end
else
	v3 = nil
end

local class = {}
class.__index = class

function class:Destroy()
	self.Destroyed = true
end

function class:SetActive(active)
	if active == self.Active then
		return
	end

	if active == false then
		self.MessageLogDisplay:Clear()
	else
		self.MessageLogDisplay:SetCurrentChannelName(self.Name)

		for i = 1, #self.MessageLog do
			self.MessageLogDisplay:AddMessage(self.MessageLog[i])
		end
	end

	self.Active = active
end

function class:UpdateMessageFiltered(data)
	local messageLog = self.MessageLog
	local v4 = 1
	local v5 = nil

	while v4 <= #messageLog do
		local v6 = messageLog[v4]

		if v6.ID == data.ID then
			v5 = v6
			break
		end

		v4 += 1
	end

	if v5 then
		v5.Message = data.Message
		v5.IsFiltered = true

		if v2 and v3 ~= nil and v3.Value then
			v5.TranslatedMessage = data.TranslatedMessage
			v5.ShowTranslated = true
		end

		if self.Active then
			if v and v5.Message == "" then
				table.remove(self.MessageLog, v4)
			end

			self.MessageLogDisplay:UpdateMessageFiltered(v5)
		end
	else
		self:AddMessageToChannelByTimeStamp(data)
	end
end

function class:AddMessageToChannel(p)
	table.insert(self.MessageLog, p)

	if self.Active then
		self.MessageLogDisplay:AddMessage(p)
	end

	if #self.MessageLog > ChatSettings.MessageHistoryLengthPerChannel then
		self:RemoveLastMessageFromChannel()
	end
end

function class:InternalAddMessageAtTimeStamp(p)
	for i = 1, #self.MessageLog do
		if p.Time < self.MessageLog[i].Time then
			table.insert(self.MessageLog, i, p)
			return
		end
	end

	table.insert(self.MessageLog, p)
end

function class:AddMessagesToChannelByTimeStamp(list, p)
	for i = p, #list do
		self:InternalAddMessageAtTimeStamp(list[i])
	end

	while #self.MessageLog > ChatSettings.MessageHistoryLengthPerChannel do
		table.remove(self.MessageLog, 1)
	end

	if self.Active then
		self.MessageLogDisplay:Clear()

		for i = 1, #self.MessageLog do
			self.MessageLogDisplay:AddMessage(self.MessageLog[i])
		end
	end
end

function class:AddMessageToChannelByTimeStamp(p)
	if not (#self.MessageLog >= 1) then
		self:AddMessageToChannel(p)

		return
	end

	if self.MessageLog[1].Time > p.Time then
		return
	end

	if p.Time >= self.MessageLog[#self.MessageLog].Time then
		self:AddMessageToChannel(p)
		return
	end

	for i = 1, #self.MessageLog do
		if p.Time < self.MessageLog[i].Time then
			table.insert(self.MessageLog, i, p)

			if #self.MessageLog > ChatSettings.MessageHistoryLengthPerChannel then
				self:RemoveLastMessageFromChannel()
			end

			if self.Active then
				self.MessageLogDisplay:AddMessageAtIndex(p, i)
			end

			break
		end
	end
end

function class:RemoveLastMessageFromChannel()
	table.remove(self.MessageLog, 1)

	if self.Active then
		self.MessageLogDisplay:RemoveLastMessage()
	end
end

function class:ClearMessageLog()
	self.MessageLog = {}

	if self.Active then
		self.MessageLogDisplay:Clear()
	end
end

function class:RegisterChannelTab(channelTab)
	self.ChannelTab = channelTab
end

function ChatChannel.new(name, messageLogDisplay)
	local self = setmetatable({}, class)
	self.Destroyed = false
	self.Active = false

	self.MessageLog = {}
	self.MessageLogDisplay = messageLogDisplay
	self.ChannelTab = nil
	self.Name = name

	return self
end

return ChatChannel
