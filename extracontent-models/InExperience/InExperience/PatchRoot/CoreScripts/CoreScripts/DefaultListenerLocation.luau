local SoundService = game:GetService("SoundService")
local VoiceChatService = game:GetService("VoiceChatService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function ShouldUseDefaultVoice() -- 3 equivalent calls inferred from this helper
	return SoundService.DefaultListenerLocation == Enum.ListenerLocation.Default
		and VoiceChatService.UseAudioApi == Enum.AudioApiRollout.Enabled
		and VoiceChatService.EnableDefaultVoice
end

local function ShouldUseCamera(): boolean -- 3 equivalent calls inferred from this helper
	return SoundService.DefaultListenerLocation == Enum.ListenerLocation.Camera
end

local function ShouldUseCharacter(): boolean -- 3 equivalent calls inferred from this helper
	return SoundService.DefaultListenerLocation == Enum.ListenerLocation.Character
end

local function ShouldSpawnListener()
	if SoundService.DefaultListenerLocation == Enum.ListenerLocation.None then
		return false
	end

	return ShouldUseCamera() or ShouldUseCharacter() or ShouldUseDefaultVoice() -- inferred equivalent call
end

local function WireUp(audioListener, targetInstance) -- 2 equivalent calls inferred from this helper
	local wire = Instance.new("Wire")
	wire.SourceInstance = audioListener
	wire.TargetInstance = targetInstance
	wire.Parent = audioListener
	return wire
end

local function GetMainOut() -- 2 equivalent calls inferred from this helper
	local v = SoundService:FindFirstChildWhichIsA("AudioDeviceOutput", true)

	if not v then
		v = Instance.new("AudioDeviceOutput")
		v.Parent = SoundService
	end

	return v
end

local function SpawnCharacterListener(character)
	local primaryPart = character.PrimaryPart

	if not primaryPart then
		character:GetPropertyChangedSignal("PrimaryPart"):Once(function()
			SpawnCharacterListener(character)
		end)
		return
	end

	local attachment = Instance.new("Attachment")
	local function UpdateCFrame() -- 1 equivalent call inferred from this helper
		local currentCamera = workspace.CurrentCamera

		if not currentCamera then
			return
		end

		local rotation = currentCamera.CFrame.Rotation
		attachment.WorldAxis = rotation.XVector
		attachment.WorldSecondaryAxis = rotation.YVector
	end

	UpdateCFrame() -- inferred equivalent call
	local audioListener = Instance.new("AudioListener")
	audioListener.Parent = attachment
	attachment.Parent = primaryPart
	WireUp(audioListener, GetMainOut()) -- inferred equivalent call
	local heartbeatConnection = RunService.Heartbeat:Connect(UpdateCFrame)

	local ancestryChangedConnection = nil
	ancestryChangedConnection = attachment.AncestryChanged:Connect(function()
		if not attachment:IsDescendantOf(game) then
			heartbeatConnection:Disconnect()
			ancestryChangedConnection:Disconnect()
		end
	end)
end

local flag = false
local function Initialize()
	local v

	if SoundService.DefaultListenerLocation == Enum.ListenerLocation.None then
		v = false
	else
		v = ShouldUseCamera() or ShouldUseCharacter() or ShouldUseDefaultVoice() -- inferred equivalent call
	end

	if not v or flag then
		return
	end

	if ShouldUseCharacter() then -- inferred equivalent call
		local character = LocalPlayer.Character

		if character then
			SpawnCharacterListener(character)
		end

		LocalPlayer.CharacterAdded:Connect(SpawnCharacterListener)
	elseif ShouldUseCamera() then -- inferred equivalent call
		local targetInstance = GetMainOut() -- inferred equivalent call
		local audioListener = Instance.new("AudioListener")
		audioListener.Parent = workspace.CurrentCamera
		WireUp(audioListener, targetInstance) -- inferred equivalent call
	elseif ShouldUseDefaultVoice() then -- inferred equivalent call
		local audioListener = Instance.new("AudioListener")
		audioListener.Parent = workspace.CurrentCamera
		local wire = Instance.new("Wire")
		wire.Parent = audioListener
		local audioDeviceOutput = Instance.new("AudioDeviceOutput")
		audioDeviceOutput.Parent = wire
		wire.SourceInstance = audioListener
		wire.TargetInstance = audioDeviceOutput
	end

	flag = true
end

Initialize()
SoundService:GetPropertyChangedSignal("DefaultListenerLocation"):Connect(Initialize)
VoiceChatService:GetPropertyChangedSignal("UseAudioApi"):Connect(Initialize)
VoiceChatService:GetPropertyChangedSignal("EnableDefaultVoice"):Connect(Initialize)

return {}
