local Players = game:GetService("Players")
local v2 = game:DefineFastFlag("FixAvatarUtilCharacter", false)
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 19
	-- upvalues: t1 (copy), v2 (copy)
	local self = setmetatable({}, t1)

	self.player = p1
	self.characterChangedEvent = Instance.new("BindableEvent")
	self.eventQueued = false
	self.connections = {}
	self.connections.characterAddedConnection = p1.CharacterAdded:Connect(function(character) -- line: 32
		-- upvalues: self (copy)
		self:onCharacterChanged(character)
	end)
	self.connections.characterAppearanceChangedConnection = p1.CharacterAppearanceLoaded:Connect(function(character) -- line: 37
		-- upvalues: self (copy)
		self:onCharacterChanged(character)
	end)

	if v2 and self.player.Character then
		self:onCharacterChanged(self.player.Character)
	end

	return self
end
function t1.removeConnection(p2, p3) -- line: 51
	if p2.connections[p3] then
		p2.connections[p3]:Disconnect()
		p2.connections[p3] = nil
	end
end
function t1.onCharacterChanged(t2: {[any]: any}, p4) -- line: 58
	t2:removeConnection("descendantAddedConnection")
	t2.connections.descendantAddedConnection = p4.DescendantAdded:Connect(function(descendant) -- line: 61
		-- upvalues: t2 (copy)
		t2:onDescendantAdded(descendant)
	end)
	t2:removeConnection("descendantRemovedConnection")
	t2.connections.descendantRemovedConnection = p4.DescendantRemoving:Connect(function(descendant) -- line: 66
		-- upvalues: t2 (copy)
		t2:onDescendantRemoving(descendant)
	end)

	for _, descendant in pairs(p4:GetDescendants()) do
		t2:onDescendantAdded(descendant)
	end

	t2:fireCharacterChanged()
end
function t1.onDescendantAdded(t3: {[any]: any}, p5) -- line: 79
	if p5:IsA("NumberValue") then
		local v15 = p5.Name .. "Connection"

		t3:removeConnection(v15)
		t3.connections[v15] = p5.Changed:Connect(function() -- line: 84
			-- upvalues: t3 (copy)
			t3:fireCharacterChanged()
		end)
	end

	t3:fireCharacterChanged()
end
function t1.onDescendantRemoving(t4: {[any]: any}, p6) -- line: 93
	if p6:IsA("NumberValue") then
		t4:removeConnection(p6.Name .. "Connection")
	end

	t4:fireCharacterChanged()
end
function t1.fireCharacterChanged(p7) -- line: 104
	if p7.eventQueued then
		return
	end

	p7.eventQueued = true
	task.delay(0.1, function() -- line: 111
		-- upvalues: p7 (copy)
		p7.eventQueued = false

		local Character = p7.player.Character

		if Character then
			p7.characterChangedEvent:Fire(Character)
		end
	end)
end

local t5 = {}

t5.__index = t5

function t5.new() -- line: 126
	-- upvalues: t5 (copy)
	local self = setmetatable({}, t5)

	self.playerConnections = {}

	return self
end
function t5.connectLocalCharacterChanges(t6: {[any]: any}, p8: ((...any) -> ...any)) -- line: 137
	-- upvalues: Players (copy)
	local LocalPlayer = Players.LocalPlayer

	while not LocalPlayer do
		Players.Changed:Wait()
		LocalPlayer = Players.LocalPlayer
	end

	t6:connectPlayerCharacterChanges(LocalPlayer, p8)
end
function t5.connectPlayerCharacterChanges(t7: {[any]: any}, p9, p10: ((...any) -> ...any)) -- line: 152
	-- upvalues: t1 (copy)
	if not t7.playerConnections[p9] then
		t7.playerConnections[p9] = t1.new(p9)
	end

	t7.playerConnections[p9].characterChangedEvent.Event:Connect(p10)
	t7.playerConnections[p9]:fireCharacterChanged()
end

return t5
