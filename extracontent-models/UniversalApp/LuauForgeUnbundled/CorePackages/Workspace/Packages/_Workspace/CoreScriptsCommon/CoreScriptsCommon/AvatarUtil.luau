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

function class:removeConnection(p3)
	if self.connections[p3] then
		self.connections[p3]:Disconnect()
		self.connections[p3] = nil
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

	for i, descendant in pairs(folder:GetDescendants()) do
		self:onDescendantAdded(descendant)
	end

	self:fireCharacterChanged()
end

function class:onDescendantAdded(numberValue)
	if numberValue:IsA("NumberValue") then
		local v5 = numberValue.Name .. "Connection"
		self:removeConnection(v5)
		self.connections[v5] = numberValue.Changed:Connect(function()
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

local class2 = {}
class2.__index = class2

function class2.new()
	local object = setmetatable({}, class2)

	object.playerConnections = {}

	return object
end

function class2:connectLocalCharacterChanges(p2)
	local localPlayer = Players.LocalPlayer

	while not localPlayer do
		Players.Changed:Wait()
		localPlayer = Players.LocalPlayer
	end

	self:connectPlayerCharacterChanges(localPlayer, p2)
end

function class2:connectPlayerCharacterChanges(p3, onEvent)
	if not self.playerConnections[p3] then
		self.playerConnections[p3] = class.new(p3)
	end

	self.playerConnections[p3].characterChangedEvent.Event:Connect(onEvent)

	self.playerConnections[p3]:fireCharacterChanged()
end

return class2
