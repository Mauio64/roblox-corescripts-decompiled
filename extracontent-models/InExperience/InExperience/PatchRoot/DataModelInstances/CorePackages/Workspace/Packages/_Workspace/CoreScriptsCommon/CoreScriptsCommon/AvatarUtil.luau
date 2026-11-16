local Players = game:GetService("Players")

local class = {}
class.__index = class

function class.new(player)
	local object = setmetatable({}, class)

	object.player = player

	object.characterChangedEvent = Instance.new("BindableEvent")
	object.eventQueued = false

	object.connections = {}

	object.connections.characterAddedConnection = player.CharacterAdded:Connect(function(character)
		object:onCharacterChanged(character)
	end)

	object.connections.characterAppearanceChangedConnection = player.CharacterAppearanceLoaded:Connect(function(character)
		object:onCharacterChanged(character)
	end)

	if object.player.Character then
		object:onCharacterChanged(object.player.Character)
	end

	return object
end

function class:removeConnection(p)
	if self.connections[p] then
		self.connections[p]:Disconnect()
		self.connections[p] = nil
	end
end

function class:onCharacterChanged(folder)
	self:removeConnection("descendantAddedConnection")
	self.connections.descendantAddedConnection = folder.DescendantAdded:Connect(function(descendant)
		self:onDescendantAdded(descendant)
	end)

	self:removeConnection("descendantRemovedConnection")
	self.connections.descendantRemovedConnection = folder.DescendantRemoving:Connect(function(descendant)
		self:onDescendantRemoving(descendant)
	end)

	for _, descendant in pairs(folder:GetDescendants()) do
		self:onDescendantAdded(descendant)
	end

	self:fireCharacterChanged()
end

function class:onDescendantAdded(numberValue)
	if numberValue:IsA("NumberValue") then
		local v = numberValue.Name .. "Connection"
		self:removeConnection(v)
		self.connections[v] = numberValue.Changed:Connect(function()
			self:fireCharacterChanged()
		end)
	end

	self:fireCharacterChanged()
end

function class:onDescendantRemoving(numberValue)
	if numberValue:IsA("NumberValue") then
		self:removeConnection(numberValue.Name .. "Connection")
	end

	self:fireCharacterChanged()
end

function class:fireCharacterChanged()
	if self.eventQueued then
		return
	end

	self.eventQueued = true
	task.delay(0.1, function()
		self.eventQueued = false

		local character = self.player.Character

		if character then
			self.characterChangedEvent:Fire(character)
		end
	end)
end

local AvatarUtil = {}
AvatarUtil.__index = AvatarUtil

function AvatarUtil.new()
	local self = setmetatable({}, AvatarUtil)

	self.playerConnections = {}

	return self
end

function AvatarUtil:connectLocalCharacterChanges(callback)
	local localPlayer = Players.LocalPlayer

	while not localPlayer do
		Players.Changed:Wait()
		localPlayer = Players.LocalPlayer
	end

	self:connectPlayerCharacterChanges(localPlayer, callback)
end

function AvatarUtil:connectPlayerCharacterChanges(p, onEvent)
	if not self.playerConnections[p] then
		self.playerConnections[p] = class.new(p)
	end

	self.playerConnections[p].characterChangedEvent.Event:Connect(onEvent)

	self.playerConnections[p]:fireCharacterChanged()
end

return AvatarUtil
