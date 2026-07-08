game:GetService("Players")

local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local VoiceChatService = game:GetService("VoiceChatService")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local AvatarChatService = game:GetService("AvatarChatService")
local GetFFlagAvatarChatServiceEnabled = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagAvatarChatServiceEnabled
local v8 = game:DefineFastFlag("DebugLogVoiceDefault", false)
local EngineFeature = game:GetEngineFeature("AudioInstanceAddedApiEnabled")
local FFlagExpChatDictation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagExpChatDictation

local function log(...) -- line: 17
	-- upvalues: v8 (copy)
	if v8 then
		print("[VoiceDefault]", ...)
	end
end

local t1 = {}

for i = 7, 80, 2 do
	t1[i] = (i - 7 - 73) ^ 2 / 5329
end

t1[80] = 0

if GetFFlagAvatarChatServiceEnabled() then
	local ok, result = pcall(AvatarChatService.GetServerFeaturesAsync, AvatarChatService)

	if not ok then
		log("Failed to get GetServerFeaturesAsync, returning early")

		return
	end

	local v16 = AvatarChatService:IsEnabled(result, Enum.AvatarChatServiceFeature.UniverseAudio)
	local v17 = AvatarChatService:IsEnabled(result, Enum.AvatarChatServiceFeature.PlaceAudio)

	if not v16 or not v17 then
		log("Universe or place not voice enabled, returning early")

		return
	end
end

local t2 = {}
local t3 = {}
local t4 = {}

local function upsertDeviceList(t5: {[any]: any}?, p1) -- line: 58
	if t5 == nil then
		return {
			[p1] = true
		}
	end

	t5[p1] = true

	return t5
end
local function addEmitterToHead(p2) -- line: 69
	-- upvalues: log (copy), VoiceChatService (copy), t1 (copy)
	local AudioEmitter = Instance.new("AudioEmitter")

	AudioEmitter.Parent = p2
	AudioEmitter:AddTag("RbxDefaultVoiceEmitter")
	log("Adding emitter", AudioEmitter, " to ", p2)

	if VoiceChatService.DefaultDistanceAttenuation == Enum.VoiceChatDistanceAttenuationType.Legacy then
		AudioEmitter:SetDistanceAttenuation(t1)
	end

	return AudioEmitter
end
local function hookupDeviceInputToEmitter(p3, p4) -- line: 83
	-- upvalues: addEmitterToHead (copy), log (copy)
	local v40 = addEmitterToHead(p3)

	log("Hooking input device to emitter", p3, p4, v40)

	local Wire = Instance.new("Wire")

	Wire.Parent = v40
	Wire.SourceInstance = p4
	Wire.TargetInstance = v40
end
local function untrackDeviceForPlayer(p5, p6) -- line: 95
	-- upvalues: t2 (copy), t3 (copy), log (copy)
	if p6 then
		local v44 = t2[p6]

		if v44 then
			v44[p5] = nil
		end
	end

	local v45 = t3[p5]

	if not v45 then
		log("Attempting to remove connections from untracked AudioDeviceInput")

		return
	end

	v45.onPlayerChanged:Disconnect()
	t3[p5] = nil
end
local function isIgnoredAudioInput(p7) -- line: 116
	-- upvalues: CoreGui (copy)
	return p7:IsDescendantOf(CoreGui)
end
local function trackDevice(p8) -- line: 120
	-- upvalues: FFlagExpChatDictation (copy), CoreGui (copy), t2 (copy), t3 (copy), log (copy), trackDevice (copy)
	if FFlagExpChatDictation and p8:IsDescendantOf(CoreGui) then
		return
	end

	local Player = p8.Player

	if Player then
		local v49 = t2
		local v50 = t2[Player]

		if v50 == nil then
			v50 = {
				[p8] = true
			}
		else
			v50[p8] = true
		end

		v49[Player] = v50
	end

	local t6 = {}
	local u52 = Player

	t6.onPlayerChanged = p8:GetPropertyChangedSignal("Player"):Connect(function() -- line: 132
		-- upvalues: p8 (copy), u52 (ref), t2 (copy), t3 (copy), log (copy), trackDevice (copy)
		local v70 = p8
		local v71 = u52

		if v71 then
			local v72 = t2[v71]

			if v72 then
				v72[v70] = nil
			end
		end

		local v73 = t3[v70]

		if not v73 then
			log("Attempting to remove connections from untracked AudioDeviceInput")
		else
			v73.onPlayerChanged:Disconnect()
			t3[v70] = nil
		end

		u52 = p8.Player
		trackDevice(p8)
	end)
	t3[p8] = t6
	p8.Destroying:Connect(function() -- line: 139
		-- upvalues: p8 (copy), t2 (copy), t3 (copy), log (copy)
		local v74 = p8
		local Player2 = p8.Player

		if Player2 then
			local v76 = t2[Player2]

			if v76 then
				v76[v74] = nil
			end
		end

		local v77 = t3[v74]

		if not v77 then
			log("Attempting to remove connections from untracked AudioDeviceInput")

			return
		end

		v77.onPlayerChanged:Disconnect()
		t3[v74] = nil
	end)
end
local function createAudioDevice(p9) -- line: 144
	-- upvalues: VoiceChatService (copy), log (copy), trackDevice (copy), addEmitterToHead (copy), t4 (copy)
	local ok, result = pcall(function() -- line: 145
		-- upvalues: VoiceChatService (copy), p9 (copy)
		return VoiceChatService:IsVoiceEnabledForUserIdAsync(p9.UserId)
	end)

	if not ok then
		log("Error getting voice enabled status: \"", result, "\"")
	end

	if not ok or not result then
		return
	end

	local AudioDeviceInput = Instance.new("AudioDeviceInput")

	AudioDeviceInput.Player = p9
	AudioDeviceInput.Parent = p9
	AudioDeviceInput.Active = false
	trackDevice(AudioDeviceInput)

	if p9.Character then
		local Character = p9.Character
		local v58 = addEmitterToHead(Character)

		log("Hooking input device to emitter", Character, AudioDeviceInput, v58)

		local Wire = Instance.new("Wire")

		Wire.Parent = v58
		Wire.SourceInstance = AudioDeviceInput
		Wire.TargetInstance = v58
	end

	t4[p9] = p9.CharacterAdded:Connect(function(character) -- line: 164
		-- upvalues: AudioDeviceInput (copy), addEmitterToHead (copy), log (copy)
		local v79 = AudioDeviceInput
		local v80 = addEmitterToHead(character)

		log("Hooking input device to emitter", character, v79, v80)

		local Wire = Instance.new("Wire")

		Wire.Parent = v80
		Wire.SourceInstance = v79
		Wire.TargetInstance = v80
	end)
	log("Creating device for ", p9.Name)
end

if VoiceChatService.UseNewAudioApi then
	log("Using new Audio API, EnableDefaultVoice: ", VoiceChatService.EnableDefaultVoice)

	if VoiceChatService.EnableDefaultVoice then
		local Players = game:GetService("Players")

		Players.PlayerAdded:Connect(createAudioDevice)
		Players.PlayerRemoving:Connect(function(player) -- line: 175
			-- upvalues: t2 (copy), t4 (copy), log (copy)
			local v61 = t2[player]
			local v62 = t4[player]

			log(player.Name, "removed. Deleting instance", v61)

			if v61 then
				t2[player] = nil
			end

			if v62 then
				v62:Disconnect()
			end
		end)

		for _, player in Players:GetPlayers() do
			createAudioDevice(player)
		end
	end

	local RemoteEvent = Instance.new("RemoteEvent")

	RemoteEvent.Name = "SetUserActive"
	RemoteEvent.Parent = RobloxReplicatedStorage

	if EngineFeature then
		SoundService.AudioInstanceAdded:Connect(function(p10) -- line: 197
			-- upvalues: FFlagExpChatDictation (copy), CoreGui (copy), trackDevice (copy)
			if p10:IsA("AudioDeviceInput") then
				if FFlagExpChatDictation and p10:IsDescendantOf(CoreGui) then
					return
				end

				p10.Active = false
				trackDevice(p10)
			end
		end)
	else
		game.DescendantAdded:Connect(function(descendant) -- line: 208
			-- upvalues: FFlagExpChatDictation (copy), CoreGui (copy), trackDevice (copy)
			if descendant:IsA("AudioDeviceInput") then
				if FFlagExpChatDictation and descendant:IsDescendantOf(CoreGui) then
					return
				end

				descendant.Active = false
				trackDevice(descendant)
			end
		end)
	end

	for _, v33 in SoundService:GetAudioInstances() do
		if v33:IsA("AudioDeviceInput") and (not FFlagExpChatDictation or not v33:IsDescendantOf(CoreGui)) then
			v33.Active = false
			trackDevice(v33)
		end
	end

	RemoteEvent.OnServerEvent:Connect(function(player, p11) -- line: 231
		-- upvalues: t2 (copy), log (copy)
		local v67 = t2[player]

		if v67 then
			log("Setting", player, "to", p11)

			for v68, _ in v67 do
				v68.Active = p11
			end

			return
		end

		log("Attempting to set Active property for user", player, "without saved AudioDeviceInput")
	end)
end
