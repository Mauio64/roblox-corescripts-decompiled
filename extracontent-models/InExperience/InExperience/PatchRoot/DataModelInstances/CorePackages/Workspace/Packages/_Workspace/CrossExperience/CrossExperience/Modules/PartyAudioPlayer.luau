local UserGameSettings = UserSettings():GetService("UserGameSettings")
local engineFeature = game:GetEngineFeature("PartyVoiceVolume")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CrossExperience = script:FindFirstAncestor("CrossExperience")
require(CrossExperience.Types)

local defineFastInt = game:DefineFastInt("PartyVoiceAudioFaderVolumePerc", 100)
local engineFeature2 = game:GetEngineFeature("AudioPlayerUpdateAssetAPI")

local PartyAudioPlayer = {}
PartyAudioPlayer.__index = PartyAudioPlayer

function PartyAudioPlayer.new()
	local v = {
		audioPlayers = {},
		isInitialized = false,
		sfxAudioFader = nil,
		onPartyVoiceVolumeChangedSignal = nil
	}

	setmetatable(v, PartyAudioPlayer)
	return v
end

function PartyAudioPlayer:addSound(p, p2: string)
	local audioPlayer = Instance.new("AudioPlayer")
	audioPlayer.Parent = workspace

	if engineFeature2 then
		audioPlayer.Asset = p2
	else
		audioPlayer.AssetId = p2
	end

	local wire = Instance.new("Wire")
	wire.Parent = workspace

	wire.SourceInstance = audioPlayer
	wire.TargetInstance = self.sfxAudioFader

	self.audioPlayers[p] = audioPlayer
end

function PartyAudioPlayer:initialize()
	if defineFastInt ~= 100 then
		local audioFader = ReplicatedStorage:WaitForChild("AudioFader")
		audioFader.Volume = defineFastInt / 100
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

function PartyAudioPlayer:playSound(p)
	if not self.isInitialized then
		self:initialize()
	end

	if self.isInitialized and self.audioPlayers[p] then
		self.audioPlayers[p].TimePosition = 0
		self.audioPlayers[p]:Play()
	end
end

function PartyAudioPlayer.disconnect(p)
	if p.onPartyVoiceVolumeChangedSignal then
		p.onPartyVoiceVolumeChangedSignal:Disconnect()
	end
end

PartyAudioPlayer.default = PartyAudioPlayer.new()

return PartyAudioPlayer
