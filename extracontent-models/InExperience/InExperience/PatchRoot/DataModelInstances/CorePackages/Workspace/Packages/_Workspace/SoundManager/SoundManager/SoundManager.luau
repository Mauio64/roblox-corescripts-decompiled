local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local RobloxGui = CoreGui.RobloxGui
local parent = script.Parent.Parent
local Cryo = require(parent.Cryo)
local Lumberyak = require(parent.Lumberyak)
local logger = Lumberyak.Logger.new(nil, "SoundManager")
local Sounds = require(script.Parent.Sounds)
local SoundEffects = require(script.Parent.SoundEffects)
local SoundGroups = require(script.Parent.SoundGroups)

local SoundManager = {}

SoundManager.__index = SoundManager

local v = {
	Looped = false,
	PlaybackSpeed = 1,
	Volume = 1,
	FadeInTime = nil,
	FadeOutTime = nil,
	SoundEffects = nil
}

local connectionsBySoundId = {}

local function fadeVolume(object, p: number, volume: number, p2: string)
	if p < 0 then
		error(p2 .. " cannot have a negative fadeIn/fadeOut time.")
	end

	local v2 = (volume - object.Volume) / p

	local function onHeartBeat(p3)
		local v3 = v2 * p3
		local volume2 = object.Volume + v3

		if volume2 <= 0 then
			object.Volume = 0
			object:Stop()
			connectionsBySoundId[object.SoundId]:Disconnect()
		elseif volume <= volume2 then
			object.Volume = volume
			connectionsBySoundId[object.SoundId]:Disconnect()
		else
			object.Volume = volume2
		end
	end

	if connectionsBySoundId[object.SoundId] and connectionsBySoundId[object.SoundId].Connected then
		connectionsBySoundId[object.SoundId]:Disconnect()
	end

	connectionsBySoundId[object.SoundId] = RunService.Heartbeat:Connect(onHeartBeat)
end

function SoundManager:_createSoundEffect(className: string, name: string, items, parent2)
	if not SoundEffects[className] then
		error(className .. " does not exist in list of SoundEffects")
	end

	local instance = Instance.new(className)

	for k, item in pairs(items) do
		instance[k] = item
	end

	instance.Parent = parent2
	instance.Name = name
end

function SoundManager:PlaySound(p: string, options, p2)
	local soundManager_Sounds = RobloxGui:FindFirstChild("SoundManager_Sounds")

	if not soundManager_Sounds then
		error("SoundManager's Sounds folder is missing. SoundManager has not been initialized.")
	end

	local sound = Sounds[p]

	if not sound then
		error(p .. " does not exist in library of Sounds")
		return
	end

	local joined = Cryo.Dictionary.join(v, sound.DefaultPlaybackProperties or {}, options or {})

	local v2 = soundManager_Sounds:FindFirstChild(sound.Name)

	if not v2 then
		v2 = Instance.new("Sound")
		v2.Parent = soundManager_Sounds
		v2.SoundId = sound.SoundId
		v2.Name = sound.Name
	end

	for _, child in pairs(v2:GetChildren()) do
		child:Destroy()
	end

	if p2 then
		v2.SoundGroup = RobloxGui:FindFirstChild("SoundManager_SoundGroups"):FindFirstChild(p2.Name)
	end

	for k, v3 in pairs(joined) do
		if k ~= "FadeInTime" and k ~= "FadeOutTime" and k ~= "Effects" then
			v2[k] = v3
		end
	end

	for _, v3 in ipairs(joined.SoundEffects or {}) do
		self:_createSoundEffect(v3.Type, v3.Name, v3.Properties, v2)
	end

	if joined.FadeInTime then
		v2.Volume = 0

		fadeVolume(v2, joined.FadeInTime, joined.Volume, p)
	end

	v2:Play()
end

function SoundManager.StopSound(_, p: string)
	local soundManager_Sounds = RobloxGui:FindFirstChild("SoundManager_Sounds")

	if not soundManager_Sounds then
		error("SoundManager's Sounds folder is missing. SoundManager has not been initialized.")
	end

	local sound = Sounds[p]

	if not sound then
		error(p .. " does not exist in list of Sounds")
		return
	end

	local child = soundManager_Sounds:FindFirstChild(sound.Name)

	if not child then
		error(p .. " does not exist")
		return
	end

	local defaultPlaybackProperties = sound.DefaultPlaybackProperties
	local fadeOutTime

	if defaultPlaybackProperties then
		fadeOutTime = defaultPlaybackProperties.FadeOutTime
	end

	if fadeOutTime then
		fadeVolume(child, fadeOutTime, 0, p)
	else
		child:Stop()
	end
end

function SoundManager:CreateSoundGroup(childName: string)
	local soundGroup = SoundGroups[childName]

	if not soundGroup then
		error("SoundGroup does not exist in list of SoundGroups")
		return
	end

	local soundManager_SoundGroups = RobloxGui:FindFirstChild("SoundManager_SoundGroups")

	if not soundManager_SoundGroups then
		error("SoundManager's SoundGroups folder is missing. SoundManager has not been initialized.")
		return
	end

	if soundManager_SoundGroups:FindFirstChild(childName) then
		warn("SoundGroup already exists")
		return
	end

	local soundGroup2 = Instance.new("SoundGroup")
	soundGroup2.Name = soundGroup.Name
	soundGroup2.Parent = soundManager_SoundGroups
	soundGroup2.Volume = soundGroup.Volume

	for _, soundEffect in ipairs(soundGroup.SoundEffects) do
		self:_createSoundEffect(soundEffect.Type, soundEffect.Name, soundEffect.Properties, soundGroup2)
	end
end

function SoundManager:SoundGroupAddSoundEffect(childName: string, data)
	if not SoundGroups[childName] then
		error("SoundGroup does not exist in list of SoundGroups")
		return
	end

	local soundManager_SoundGroups = RobloxGui:FindFirstChild("SoundManager_SoundGroups")

	if not soundManager_SoundGroups then
		error("SoundManager's SoundGroups folder is missing. SoundManager has not been initialized.")
		return
	end

	local child = soundManager_SoundGroups:FindFirstChild(childName)

	if not child then
		error("SoundGroup Instance not created")
	elseif child:FindFirstChild(data.Name) then
		error("SoundEffect with name " .. data.Name .. " already exists for sound group " .. childName)
	else
		self:_createSoundEffect(data.Type, data.Name, data.Properties, child)
	end
end

function SoundManager.SoundGroupRemoveSoundEffect(_, childName: string, childName2: string)
	local soundGroup = SoundGroups[childName]

	if not soundGroup then
		error("SoundGroup does not exist in list of SoundGroups")
		return
	end

	local soundManager_SoundGroups = RobloxGui:FindFirstChild("SoundManager_SoundGroups")

	if not soundManager_SoundGroups then
		error("SoundManager's SoundGroups folder is missing. SoundManager has not been initialized.")
		return
	end

	local child = soundManager_SoundGroups:FindFirstChild(childName)

	if not child then
		error("SoundGroup Instance not created")
		return
	end

	local child2 = child:FindFirstChild(childName2)

	if not child2 then
		error(childName2 .. " not found in " .. soundGroup.Name)
	end

	child2:Destroy()
end

function SoundManager.init()
	local self = setmetatable({}, SoundManager)

	if RobloxGui:FindFirstChild("SoundManager_Sounds") then
		logger:warning("SoundManager already initialized")

		return self
	end

	local soundManager_Sounds = Instance.new("Folder")
	soundManager_Sounds.Name = "SoundManager_Sounds"
	soundManager_Sounds.Parent = RobloxGui

	local soundManager_SoundGroups = Instance.new("Folder")
	soundManager_SoundGroups.Name = "SoundManager_SoundGroups"
	soundManager_SoundGroups.Parent = RobloxGui
	return self
end

return SoundManager
