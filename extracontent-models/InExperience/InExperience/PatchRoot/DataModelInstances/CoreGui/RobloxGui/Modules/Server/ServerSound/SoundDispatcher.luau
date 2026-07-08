local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t1 = {}
local DefaultSoundEvents = ReplicatedStorage:FindFirstChild("DefaultSoundEvents")

if not DefaultSoundEvents then
	DefaultSoundEvents = Instance.new("Folder")
	DefaultSoundEvents.Name = "DefaultSoundEvents"
	DefaultSoundEvents.Archivable = false
	DefaultSoundEvents.Parent = ReplicatedStorage
end

local function createEvent(p1, p2) -- line: 27
	-- upvalues: DefaultSoundEvents (ref)
	local p1_2 = DefaultSoundEvents:FindFirstChild(p1)

	if not p1_2 then
		p1_2 = Instance.new(p2)
		p1_2.Name = p1
		p1_2.Parent = DefaultSoundEvents
	end

	return p1_2
end

local DefaultServerSoundEvent = DefaultSoundEvents:FindFirstChild("DefaultServerSoundEvent")

if not DefaultServerSoundEvent then
	DefaultServerSoundEvent = Instance.new("RemoteEvent")
	DefaultServerSoundEvent.Name = "DefaultServerSoundEvent"
	DefaultServerSoundEvent.Parent = DefaultSoundEvents
end

local v7 = DefaultServerSoundEvent
local AddCharacterLoadedEvent = DefaultSoundEvents:FindFirstChild("AddCharacterLoadedEvent")

if not AddCharacterLoadedEvent then
	AddCharacterLoadedEvent = Instance.new("RemoteEvent")
	AddCharacterLoadedEvent.Name = "AddCharacterLoadedEvent"
	AddCharacterLoadedEvent.Parent = DefaultSoundEvents
end

local RemoveCharacterEvent = DefaultSoundEvents:FindFirstChild("RemoveCharacterEvent")

if not RemoveCharacterEvent then
	RemoveCharacterEvent = Instance.new("RemoteEvent")
	RemoveCharacterEvent.Name = "RemoveCharacterEvent"
	RemoveCharacterEvent.Parent = DefaultSoundEvents
end

local function fireDefaultServerSoundEventToClient(p3, p4, p5, p6) -- line: 43
	-- upvalues: t1 (copy), v7 (copy)
	if t1[p3] then
		v7:FireClient(p3, p4, p5, p6)
	end
end
local function addCharacterLoaded(p7) -- line: 50
	-- upvalues: t1 (copy)
	t1[p7] = true
end
local function removeCharacter(p8) -- line: 55
	-- upvalues: t1 (copy)
	t1[p8] = nil
end

local SoundDispatcher = DefaultSoundEvents:FindFirstChild("SoundDispatcher")

if not SoundDispatcher then
	SoundDispatcher = Instance.new("BindableEvent")
	SoundDispatcher.Name = "SoundDispatcher"
	SoundDispatcher.Parent = DefaultSoundEvents
end

SoundDispatcher.Event:Connect(fireDefaultServerSoundEventToClient)
v7.OnServerEvent:Connect(function() -- line: 63
end)
AddCharacterLoadedEvent.OnServerEvent:Connect(addCharacterLoaded)
RemoveCharacterEvent.OnServerEvent:Connect(removeCharacter)
Players.PlayerRemoving:Connect(removeCharacter)
