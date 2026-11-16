local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local v = {}

local DefaultSoundEvents = ReplicatedStorage:FindFirstChild("DefaultSoundEvents")

if not DefaultSoundEvents then
	DefaultSoundEvents = Instance.new("Folder")
	DefaultSoundEvents.Name = "DefaultSoundEvents"
	DefaultSoundEvents.Archivable = false
	DefaultSoundEvents.Parent = ReplicatedStorage
end

local function createEvent(name, className) -- 4 equivalent calls inferred from this helper
	local event = DefaultSoundEvents:FindFirstChild(name)

	if not event then
		event = Instance.new(className)
		event.Name = name
		event.Parent = DefaultSoundEvents
	end

	return event
end

local event = createEvent("DefaultServerSoundEvent", "RemoteEvent") -- inferred equivalent call
local event2 = createEvent("AddCharacterLoadedEvent", "RemoteEvent") -- inferred equivalent call
local event3 = createEvent("RemoveCharacterEvent", "RemoteEvent") -- inferred equivalent call

local function fireDefaultServerSoundEventToClient(player, p, p2, p3)
	if v[player] then
		event:FireClient(player, p, p2, p3)
	end
end

local function addCharacterLoaded(p)
	v[p] = true
end

local function removeCharacter(p)
	v[p] = nil
end

createEvent("SoundDispatcher", "BindableEvent").Event:Connect(fireDefaultServerSoundEventToClient) -- inferred equivalent call

event.OnServerEvent:Connect(function() end)
event2.OnServerEvent:Connect(addCharacterLoaded)
event3.OnServerEvent:Connect(removeCharacter)
Players.PlayerRemoving:Connect(removeCharacter)
