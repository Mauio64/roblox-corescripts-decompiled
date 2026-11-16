local UserGameSettings = UserSettings():GetService("UserGameSettings")
local engineFeature = game:GetEngineFeature("PartyVoiceVolume")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Types")

local defineFastInt = game:DefineFastInt("PartyVoiceAudioFaderVolumePerc", 100)
local engineFeature2 = game:GetEngineFeature("AudioPlayerUpdateAssetAPI")

local class = {}
class.__index = class

function class.new()
	local v5 = {
		audioPlayers = {},
		isInitialized = false,
		sfxAudioFader = nil,
		onPartyVoiceVolumeChangedSignal = nil
	}

	setmetatable(v5, class)
	return v5
end

function class:addSound(p3, p4)
	local audioPlayer = Instance.new("AudioPlayer")
	audioPlayer.Parent = workspace

	if engineFeature2 then
		audioPlayer.Asset = p4
	else
		audioPlayer.AssetId = p4
	end

	local wire = Instance.new("Wire")
	wire.Parent = workspace

	wire.SourceInstance = audioPlayer
	wire.TargetInstance = self.sfxAudioFader

	self.audioPlayers[p3] = audioPlayer
end

function class:initialize()
	if defineFastInt ~= 100 then
		local audioFader_2 = ReplicatedStorage:WaitForChild("AudioFader")
		audioFader_2.Volume = defineFastInt / 100
	end

	local audioDeviceOutput = Instance.new("AudioDeviceOutput")
	audioDeviceOutput.Parent = workspace

	local audioFader = Instance.new("AudioFader")
	audioFader.Parent = workspace

	if defineFastInt ~= 100 then
		audioFader.Volume = defineFastInt / 100
	end

	local wire = Instance.new("Wire")
	wire.Parent = workspace
	wire.SourceInstance = audioFader
	wire.TargetInstance = audioDeviceOutput

	self.sfxAudioFader = audioFader

	self:addSound("join", "rbxassetid://87296803139875")
	self:addSound("leave", "rbxassetid://108128059974752")

	self.isInitialized = true

	if engineFeature then
		self.onPartyVoiceVolumeChangedSignal = UserGameSettings:GetPropertyChangedSignal("PartyVoiceVolume"):Connect(function()
			self:playSound("join")
		end)
	end
end

function class:playSound(p2)
	if not self.isInitialized then
		self:initialize()
	end

	if self.isInitialized and self.audioPlayers[p2] then
		self.audioPlayers[p2].TimePosition = 0
		self.audioPlayers[p2]:Play()
	end
end

function class.disconnect(p2)
	if p2.onPartyVoiceVolumeChangedSignal then
		p2.onPartyVoiceVolumeChangedSignal:Disconnect()
	end
end

class.default = class.new()

return class
