local SoundService = game:GetService("SoundService")
local VoiceChatService = game:GetService("VoiceChatService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function ShouldUseDefaultVoice() -- line: 7
	-- upvalues: SoundService (copy), VoiceChatService (copy)
	return SoundService.DefaultListenerLocation == Enum.ListenerLocation.Default and (VoiceChatService.UseAudioApi == Enum.AudioApiRollout.Enabled and VoiceChatService.EnableDefaultVoice)
end
local function ShouldUseCamera() -- line: 13
	-- upvalues: SoundService (copy)
	return SoundService.DefaultListenerLocation == Enum.ListenerLocation.Camera
end
local function ShouldUseCharacter() -- line: 17
	-- upvalues: SoundService (copy)
	return SoundService.DefaultListenerLocation == Enum.ListenerLocation.Character
end
local function ShouldSpawnListener() -- line: 21
	-- upvalues: SoundService (copy), VoiceChatService (copy)
	if SoundService.DefaultListenerLocation == Enum.ListenerLocation.None then
		return false
	end

	return SoundService.DefaultListenerLocation == Enum.ListenerLocation.Camera or (SoundService.DefaultListenerLocation == Enum.ListenerLocation.Character or SoundService.DefaultListenerLocation == Enum.ListenerLocation.Default and (VoiceChatService.UseAudioApi == Enum.AudioApiRollout.Enabled and VoiceChatService.EnableDefaultVoice))
end
local function WireUp(p1, p2) -- line: 28
	local Wire = Instance.new("Wire")

	Wire.SourceInstance = p1
	Wire.TargetInstance = p2
	Wire.Parent = p1

	return Wire
end
local function GetMainOut() -- line: 36
	-- upvalues: SoundService (copy)
	local AudioDeviceOutput = SoundService:FindFirstChildWhichIsA("AudioDeviceOutput", true)

	if not AudioDeviceOutput then
		AudioDeviceOutput = Instance.new("AudioDeviceOutput")
		AudioDeviceOutput.Parent = SoundService
	end

	return AudioDeviceOutput
end
local function SpawnCharacterListener(p3) -- line: 46
	-- upvalues: SpawnCharacterListener (copy), SoundService (copy), RunService (copy)
	local PrimaryPart = p3.PrimaryPart

	if not PrimaryPart then
		p3:GetPropertyChangedSignal("PrimaryPart"):Once(function() -- line: 49
			-- upvalues: SpawnCharacterListener (copy), p3 (copy)
			SpawnCharacterListener(p3)
		end)

		return
	end

	local Attachment = Instance.new("Attachment")

	local function UpdateCFrame() -- line: 56
		-- upvalues: Attachment (copy)
		local CurrentCamera = workspace.CurrentCamera

		if not CurrentCamera then
			return
		end

		local CFrameRotation = CurrentCamera.CFrame.Rotation

		Attachment.WorldAxis = CFrameRotation.XVector
		Attachment.WorldSecondaryAxis = CFrameRotation.YVector
	end

	local CurrentCamera = workspace.CurrentCamera

	if CurrentCamera then
		local CFrameRotation = CurrentCamera.CFrame.Rotation

		Attachment.WorldAxis = CFrameRotation.XVector
		Attachment.WorldSecondaryAxis = CFrameRotation.YVector
	end

	local AudioListener = Instance.new("AudioListener")

	AudioListener.Parent = Attachment
	Attachment.Parent = PrimaryPart

	local AudioDeviceOutput = SoundService:FindFirstChildWhichIsA("AudioDeviceOutput", true)

	if not AudioDeviceOutput then
		AudioDeviceOutput = Instance.new("AudioDeviceOutput")
		AudioDeviceOutput.Parent = SoundService
	end

	local Wire = Instance.new("Wire")

	Wire.SourceInstance = AudioListener
	Wire.TargetInstance = AudioDeviceOutput
	Wire.Parent = AudioListener

	local connection = RunService.Heartbeat:Connect(UpdateCFrame)
	local connection2 = nil

	connection2 = Attachment.AncestryChanged:Connect(function() -- line: 76
		-- upvalues: Attachment (copy), connection (copy), connection2 (ref)
		if not Attachment:IsDescendantOf(game) then
			connection:Disconnect()
			connection2:Disconnect()
		end
	end)
end

local u13 = false

local function Initialize() -- line: 86
	-- upvalues: SoundService (copy), VoiceChatService (copy), u13 (ref), LocalPlayer (copy), SpawnCharacterListener (copy)
	if SoundService.DefaultListenerLocation == Enum.ListenerLocation.None or SoundService.DefaultListenerLocation ~= Enum.ListenerLocation.Camera and (SoundService.DefaultListenerLocation ~= Enum.ListenerLocation.Character and (SoundService.DefaultListenerLocation ~= Enum.ListenerLocation.Default or (VoiceChatService.UseAudioApi ~= Enum.AudioApiRollout.Enabled or not VoiceChatService.EnableDefaultVoice))) then
		return
	end

	if u13 then
		return
	end

	if SoundService.DefaultListenerLocation == Enum.ListenerLocation.Character then
		local Character = LocalPlayer.Character

		if Character then
			SpawnCharacterListener(Character)
		end

		LocalPlayer.CharacterAdded:Connect(SpawnCharacterListener)
	elseif SoundService.DefaultListenerLocation == Enum.ListenerLocation.Camera then
		local AudioDeviceOutput = SoundService:FindFirstChildWhichIsA("AudioDeviceOutput", true)

		if not AudioDeviceOutput then
			AudioDeviceOutput = Instance.new("AudioDeviceOutput")
			AudioDeviceOutput.Parent = SoundService
		end

		local AudioListener = Instance.new("AudioListener")

		AudioListener.Parent = workspace.CurrentCamera

		local Wire = Instance.new("Wire")

		Wire.SourceInstance = AudioListener
		Wire.TargetInstance = AudioDeviceOutput
		Wire.Parent = AudioListener
	elseif SoundService.DefaultListenerLocation == Enum.ListenerLocation.Default and (VoiceChatService.UseAudioApi == Enum.AudioApiRollout.Enabled and VoiceChatService.EnableDefaultVoice) then
		local AudioListener = Instance.new("AudioListener")

		AudioListener.Parent = workspace.CurrentCamera

		local Wire = Instance.new("Wire")

		Wire.Parent = AudioListener

		local AudioDeviceOutput = Instance.new("AudioDeviceOutput")

		AudioDeviceOutput.Parent = Wire
		Wire.SourceInstance = AudioListener
		Wire.TargetInstance = AudioDeviceOutput
	end

	u13 = true
end

Initialize()
SoundService:GetPropertyChangedSignal("DefaultListenerLocation"):Connect(Initialize)
VoiceChatService:GetPropertyChangedSignal("UseAudioApi"):Connect(Initialize)
VoiceChatService:GetPropertyChangedSignal("EnableDefaultVoice"):Connect(Initialize)

return {}
