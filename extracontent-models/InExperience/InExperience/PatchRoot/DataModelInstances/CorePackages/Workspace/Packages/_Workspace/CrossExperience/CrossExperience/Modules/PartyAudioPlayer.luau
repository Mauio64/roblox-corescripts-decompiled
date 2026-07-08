local UserGameSettings = UserSettings():GetService("UserGameSettings")
local EngineFeature = game:GetEngineFeature("PartyVoiceVolume")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CrossExperience = script:FindFirstAncestor("CrossExperience")

require(CrossExperience.Types)

local v5 = game:DefineFastInt("PartyVoiceAudioFaderVolumePerc", 100)
local EngineFeature2 = game:GetEngineFeature("AudioPlayerUpdateAssetAPI")
local t1 = {}

t1.__index = t1

function t1.new() -- line: 17
	-- upvalues: t1 (copy)
	local t2 = {
		isInitialized = false,
		sfxAudioFader = nil,
		onPartyVoiceVolumeChangedSignal = nil,
		audioPlayers = {}
	}

	setmetatable(t2, t1)

	return t2
end
function t1.addSound(t3: {[any]: any}, p1, s1: string) -- line: 28
	-- upvalues: EngineFeature2 (copy)
	local AudioPlayer = Instance.new("AudioPlayer")

	AudioPlayer.Parent = workspace

	if EngineFeature2 then
		AudioPlayer.Asset = s1
	else
		AudioPlayer.AssetId = s1
	end

	local Wire = Instance.new("Wire")

	Wire.Parent = workspace
	Wire.SourceInstance = AudioPlayer
	Wire.TargetInstance = t3.sfxAudioFader
	t3.audioPlayers[p1] = AudioPlayer
end
function t1.initialize(p2) -- line: 46
	-- upvalues: v5 (copy), ReplicatedStorage (copy), EngineFeature (copy), UserGameSettings (copy)
	if v5 ~= 100 then
		ReplicatedStorage:WaitForChild("AudioFader").Volume = v5 / 100
	end

	local AudioDeviceOutput = Instance.new("AudioDeviceOutput")

	AudioDeviceOutput.Parent = workspace

	local AudioFader = Instance.new("AudioFader")

	AudioFader.Parent = workspace

	if v5 ~= 100 then
		AudioFader.Volume = v5 / 100
	end

	local Wire = Instance.new("Wire")

	Wire.Parent = workspace
	Wire.SourceInstance = AudioFader
	Wire.TargetInstance = AudioDeviceOutput
	p2.sfxAudioFader = AudioFader
	p2:addSound("join", "rbxassetid://87296803139875")
	p2:addSound("leave", "rbxassetid://108128059974752")
	p2.isInitialized = true

	if EngineFeature then
		p2.onPartyVoiceVolumeChangedSignal = UserGameSettings:GetPropertyChangedSignal("PartyVoiceVolume"):Connect(function() -- line: 75
			-- upvalues: p2 (copy)
			p2:playSound("join")
		end)
	end
end
function t1.playSound(p3, p4) -- line: 81
	if not p3.isInitialized then
		p3:initialize()
	end

	if not p3.isInitialized or not p3.audioPlayers[p4] then
		return
	end

	p3.audioPlayers[p4].TimePosition = 0
	p3.audioPlayers[p4]:Play()
end
function t1.disconnect(p5) -- line: 94
	if p5.onPartyVoiceVolumeChangedSignal then
		p5.onPartyVoiceVolumeChangedSignal:Disconnect()
	end
end

t1.default = t1.new()

return t1
