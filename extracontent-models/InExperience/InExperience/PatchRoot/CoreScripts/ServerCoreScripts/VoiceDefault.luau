game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local VoiceChatService = game:GetService("VoiceChatService")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local AvatarChatService = game:GetService("AvatarChatService")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagAvatarChatServiceEnabled = SharedFlags.GetFFlagAvatarChatServiceEnabled

local defineFastFlag = game:DefineFastFlag("DebugLogVoiceDefault", false)

local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagUseAudioDeviceInputAddedSignal = SharedFlags2.FFlagUseAudioDeviceInputAddedSignal
local engineFeature = game:GetEngineFeature("AudioInstanceAddedApiEnabled")

local SharedFlags3 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagExpChatDictation = SharedFlags3.FFlagExpChatDictation

local function log(...)
	if defineFastFlag then
		print("[VoiceDefault]", ...)
	end
end

local v = {}

for i = 7, 80, 2 do
	v[i] = (i - 7 - 73) ^ 2 / 5329
end

v[80] = 0

if GetFFlagAvatarChatServiceEnabled() then
	local success, serverFeaturesAsync = pcall(AvatarChatService.GetServerFeaturesAsync, AvatarChatService)

	if not success then
		log("Failed to get GetServerFeaturesAsync, returning early")
		return
	end

	local isEnabled = AvatarChatService:IsEnabled(serverFeaturesAsync, Enum.AvatarChatServiceFeature.UniverseAudio)
	local isEnabled2 = AvatarChatService:IsEnabled(serverFeaturesAsync, Enum.AvatarChatServiceFeature.PlaceAudio)

	if not (isEnabled and isEnabled2) then
		log("Universe or place not voice enabled, returning early")
		return
	end
end

local v2 = {}
local v3 = {}
local connections = {}

local function upsertDeviceList(p, p2)
	if p ~= nil then
		p[p2] = true
		return p
	end

	local set = {}
	set[p2] = true
	return set
end

local function addEmitterToHead(parent)
	local audioEmitter = Instance.new("AudioEmitter")
	audioEmitter.Parent = parent
	audioEmitter:AddTag("RbxDefaultVoiceEmitter")
	log("Adding emitter", audioEmitter, " to ", parent)

	if VoiceChatService.DefaultDistanceAttenuation == Enum.VoiceChatDistanceAttenuationType.Legacy then
		audioEmitter:SetDistanceAttenuation(v)
	end

	return audioEmitter
end

local function hookupDeviceInputToEmitter(character, audioDeviceInput) -- 2 equivalent calls inferred from this helper
	local v4 = addEmitterToHead(character)
	log("Hooking input device to emitter", character, audioDeviceInput, v4)
	local wire = Instance.new("Wire")
	wire.Parent = v4
	wire.SourceInstance = audioDeviceInput
	wire.TargetInstance = v4
end

local function untrackDeviceForPlayer(instance, p) -- 2 equivalent calls inferred from this helper
	local v4 = p and v2[p]

	if v4 then
		v4[instance] = nil
	end

	local v5 = v3[instance]

	if not v5 then
		log("Attempting to remove connections from untracked AudioDeviceInput")
		return
	end

	v5.onPlayerChanged:Disconnect()
	v3[instance] = nil
end

local function isIgnoredAudioInput(instance) -- 3 equivalent calls inferred from this helper
	return instance:IsDescendantOf(CoreGui)
end

local function trackDevice(instance)
	if FFlagExpChatDictation and isIgnoredAudioInput(instance) then -- inferred equivalent call
		return
	end

	local player = instance.Player

	if player then
		local v4 = v2[player]

		if v4 == nil then
			v4 = {}
		end

		v4[instance] = true

		v2[player] = v4
	end

	local v4 = player
	v3[instance] = {
		onPlayerChanged = instance:GetPropertyChangedSignal("Player"):Connect(function()
			untrackDeviceForPlayer(instance, v4) -- inferred equivalent call
			v4 = instance.Player
			trackDevice(instance)
		end)
	}
	instance.Destroying:Connect(function()
		untrackDeviceForPlayer(instance, instance.Player) -- inferred equivalent call
	end)
end

local function createAudioDevice(player)
	local success, result = pcall(function()
		return VoiceChatService:IsVoiceEnabledForUserIdAsync(player.UserId)
	end)

	if not success then
		log("Error getting voice enabled status: \"", result, "\"")
	end

	if not (success and result) then
		return
	end

	local audioDeviceInput = Instance.new("AudioDeviceInput")
	audioDeviceInput.Player = player
	audioDeviceInput.Parent = player
	audioDeviceInput.Active = false
	trackDevice(audioDeviceInput)

	if player.Character then
		hookupDeviceInputToEmitter(player.Character, audioDeviceInput) -- inferred equivalent call
	end

	connections[player] = player.CharacterAdded:Connect(function(character)
		hookupDeviceInputToEmitter(character, audioDeviceInput) -- inferred equivalent call
	end)
	log("Creating device for ", player.Name)
end

if VoiceChatService.UseNewAudioApi then
	log("Using new Audio API, EnableDefaultVoice: ", VoiceChatService.EnableDefaultVoice)

	if VoiceChatService.EnableDefaultVoice then
		local Players = game:GetService("Players")
		Players.PlayerAdded:Connect(createAudioDevice)
		Players.PlayerRemoving:Connect(function(player)
			local v4 = v2[player]
			local connection = connections[player]
			log(player.Name, "removed. Deleting instance", v4)

			if v4 then
				v2[player] = nil
			end

			if connection then
				connection:Disconnect()
			end
		end)

		for _, v4 in Players:GetPlayers() do
			createAudioDevice(v4)
		end
	end

	local setUserActive = Instance.new("RemoteEvent")
	setUserActive.Name = "SetUserActive"
	setUserActive.Parent = RobloxReplicatedStorage

	local function onAudioDeviceInputAdded(audioDeviceInput) -- 2 equivalent calls inferred from this helper
		if FFlagExpChatDictation and isIgnoredAudioInput(audioDeviceInput) then -- inferred equivalent call
			return
		end

		audioDeviceInput.Active = false
		trackDevice(audioDeviceInput)
	end

	if FFlagUseAudioDeviceInputAddedSignal then
		SoundService.AudioDeviceInputAdded:Connect(onAudioDeviceInputAdded)
	elseif engineFeature then
		SoundService.AudioInstanceAdded:Connect(function(audioDeviceInput)
			if audioDeviceInput:IsA("AudioDeviceInput") then
				onAudioDeviceInputAdded(audioDeviceInput) -- inferred equivalent call
			end
		end)
	else
		game.DescendantAdded:Connect(function(audioDeviceInput)
			if audioDeviceInput:IsA("AudioDeviceInput") then
				onAudioDeviceInputAdded(audioDeviceInput) -- inferred equivalent call
			end
		end)
	end

	for _, audioDeviceInput in SoundService:GetAudioInstances() do
		if
			not audioDeviceInput:IsA("AudioDeviceInput")
			or FFlagExpChatDictation and isIgnoredAudioInput(audioDeviceInput) -- inferred equivalent call
		then
			continue
		end

		audioDeviceInput.Active = false
		trackDevice(audioDeviceInput)
	end

	setUserActive.OnServerEvent:Connect(function(p, active)
		local v4 = v2[p]

		if not v4 then
			log("Attempting to set Active property for user", p, "without saved AudioDeviceInput")

			return
		end

		log("Setting", p, "to", active)

		for k, _ in v4 do
			k.Active = active
		end
	end)
end
