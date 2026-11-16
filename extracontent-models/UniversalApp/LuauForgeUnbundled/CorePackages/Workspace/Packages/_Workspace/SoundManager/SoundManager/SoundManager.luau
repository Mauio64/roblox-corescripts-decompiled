local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local robloxGui = CoreGui.RobloxGui

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SoundManager/Cryo")
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/SoundManager/Lumberyak").Logger.new(nil, "SoundManager")
local Sounds = require("@game/CorePackages/Workspace/Packages/_Workspace/SoundManager/SoundManager/Sounds")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/SoundManager/SoundManager/SoundEffects")
local SoundGroups = require("@game/CorePackages/Workspace/Packages/_Workspace/SoundManager/SoundManager/SoundGroups")

local class = {}

class.__index = class

local v5 = {
	Looped = false,
	PlaybackSpeed = 1,
	Volume = 1,
	FadeInTime = nil,
	FadeOutTime = nil,
	SoundEffects = nil
}

local connectionsBySoundId = {}

local function fadeVolume(object, p2, volume, p3)
	if p2 < 0 then
		error(p3 .. " cannot have a negative fadeIn/fadeOut time.")
	end

	local v6 = (volume - object.Volume) / p2

	local function onHeartBeat(p4)
		local v7 = v6 * p4
		local v8 = object.Volume + v7

		if v8 <= 0 then
			object.Volume = 0
			object:Stop()
			connectionsBySoundId[object.SoundId]:Disconnect()
		elseif volume <= v8 then
			object.Volume = volume
			connectionsBySoundId[object.SoundId]:Disconnect()
		else
			object.Volume = v8
		end
	end

	if connectionsBySoundId[object.SoundId] and connectionsBySoundId[object.SoundId].Connected then
		connectionsBySoundId[object.SoundId]:Disconnect()
	end

	connectionsBySoundId[object.SoundId] = RunService.Heartbeat:Connect(onHeartBeat)
end

function class:_createSoundEffect(className, name, items, parent)
	if not module3[className] then
		error(className .. " does not exist in list of SoundEffects")
	end

	local instance = Instance.new(className)

	for k, item in pairs(items) do
		instance[k] = item
	end

	instance.Parent = parent
	instance.Name = name
end

function class:PlaySound(p2, options, p3)
	local soundManager_Sounds = robloxGui:FindFirstChild("SoundManager_Sounds")

	if not soundManager_Sounds then
		error("SoundManager's Sounds folder is missing. SoundManager has not been initialized.")
	end

	local v6 = Sounds[p2]

	if not v6 then
		error(p2 .. " does not exist in library of Sounds")
		return
	end

	local joined = Cryo.Dictionary.join(v5, v6.DefaultPlaybackProperties or {}, options or {})

	local v7 = soundManager_Sounds:FindFirstChild(v6.Name)

	if not v7 then
		v7 = Instance.new("Sound")
		v7.Parent = soundManager_Sounds
		v7.SoundId = v6.SoundId
		v7.Name = v6.Name
	end

	for i, child in pairs(v7:GetChildren()) do
		child:Destroy()
	end

	if p3 then
		v7.SoundGroup = robloxGui:FindFirstChild("SoundManager_SoundGroups"):FindFirstChild(p3.Name)
	end

	for k, v8 in pairs(joined) do
		if k ~= "FadeInTime" and k ~= "FadeOutTime" and k ~= "Effects" then
			v7[k] = v8
		end
	end

	for i, v8 in ipairs(joined.SoundEffects or {}) do
		self:_createSoundEffect(v8.Type, v8.Name, v8.Properties, v7)
	end

	if joined.FadeInTime then
		v7.Volume = 0

		fadeVolume(v7, joined.FadeInTime, joined.Volume, p2)
	end

	v7:Play()
end

function class:StopSound(p3)
	local soundManager_Sounds = robloxGui:FindFirstChild("SoundManager_Sounds")

	if not soundManager_Sounds then
		error("SoundManager's Sounds folder is missing. SoundManager has not been initialized.")
	end

	local v6 = Sounds[p3]

	if not v6 then
		error(p3 .. " does not exist in list of Sounds")
		return
	end

	local child = soundManager_Sounds:FindFirstChild(v6.Name)

	if not child then
		error(p3 .. " does not exist")
		return
	end

	local defaultPlaybackProperties = v6.DefaultPlaybackProperties
	local fadeOutTime = if defaultPlaybackProperties then defaultPlaybackProperties.FadeOutTime else nil

	if fadeOutTime then
		fadeVolume(child, fadeOutTime, 0, p3)
	else
		child:Stop()
	end
end

function class:CreateSoundGroup(childName)
	local v6 = SoundGroups[childName]

	if not v6 then
		error("SoundGroup does not exist in list of SoundGroups")
		return
	end

	local soundManager_SoundGroups = robloxGui:FindFirstChild("SoundManager_SoundGroups")

	if not soundManager_SoundGroups then
		error("SoundManager's SoundGroups folder is missing. SoundManager has not been initialized.")
		return
	end

	if soundManager_SoundGroups:FindFirstChild(childName) then
		warn("SoundGroup already exists")
		return
	end

	local soundGroup = Instance.new("SoundGroup")
	soundGroup.Name = v6.Name
	soundGroup.Parent = soundManager_SoundGroups
	soundGroup.Volume = v6.Volume

	for i, soundEffect in ipairs(v6.SoundEffects) do
		self:_createSoundEffect(soundEffect.Type, soundEffect.Name, soundEffect.Properties, soundGroup)
	end
end

function class:SoundGroupAddSoundEffect(childName, data)
	if not SoundGroups[childName] then
		error("SoundGroup does not exist in list of SoundGroups")
		return
	end

	local soundManager_SoundGroups = robloxGui:FindFirstChild("SoundManager_SoundGroups")

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

function class.SoundGroupRemoveSoundEffect(p2, childName, childName2)
	local v6 = SoundGroups[childName]

	if not v6 then
		error("SoundGroup does not exist in list of SoundGroups")
		return
	end

	local soundManager_SoundGroups = robloxGui:FindFirstChild("SoundManager_SoundGroups")

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
		error(childName2 .. " not found in " .. v6.Name)
	end

	child2:Destroy()
end

function class.init()
	local object = setmetatable({}, class)

	if robloxGui:FindFirstChild("SoundManager_Sounds") then
		logger:warning("SoundManager already initialized")

		return object
	end

	local soundManager_Sounds = Instance.new("Folder")
	soundManager_Sounds.Name = "SoundManager_Sounds"
	soundManager_Sounds.Parent = robloxGui

	local soundManager_SoundGroups = Instance.new("Folder")
	soundManager_SoundGroups.Name = "SoundManager_SoundGroups"
	soundManager_SoundGroups.Parent = robloxGui
	return object
end

return class
