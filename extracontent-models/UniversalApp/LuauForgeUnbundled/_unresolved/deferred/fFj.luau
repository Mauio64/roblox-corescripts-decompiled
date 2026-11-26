local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local VideoService = game:GetService("VideoService")

local notificationType = require("@luauforge/deferred/fFk").NotificationType
local DeviceDisplayService

if require("@luauforge/deferred/fEW").FFlagLuaAppVideoServerDisplayWakeLock then
	DeviceDisplayService = game:GetService("DeviceDisplayService")
else
	DeviceDisplayService = nil
end

local v5 = {}
v5.SURFACE_DISPLAY_ORDER = 200

function v5.createSurface()
	local cloudClientStream = Instance.new("ScreenGui")
	cloudClientStream.Name = "CloudClientStream"
	cloudClientStream.DisplayOrder = v5.SURFACE_DISPLAY_ORDER
	cloudClientStream.IgnoreGuiInset = true
	cloudClientStream.ScreenInsets = Enum.ScreenInsets.None
	cloudClientStream.ResetOnSpawn = false
	cloudClientStream.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	cloudClientStream.Enabled = false

	local cloudClientStreamSurface = Instance.new("Frame")
	cloudClientStreamSurface.Name = "CloudClientStreamSurface"
	cloudClientStreamSurface.Size = UDim2.fromScale(1, 1)
	cloudClientStreamSurface.BackgroundColor3 = Color3.new(0, 0, 0)
	cloudClientStreamSurface.BorderSizePixel = 0
	cloudClientStreamSurface.Parent = cloudClientStream

	local realtimeMedia = Instance.new("RealtimeMedia")
	realtimeMedia.ForwardInput = true
	realtimeMedia.Name = "RealtimeMedia"
	realtimeMedia.Parent = cloudClientStreamSurface

	local videoDisplay = Instance.new("VideoDisplay")
	videoDisplay.Name = "VideoDisplay"
	videoDisplay.Size = UDim2.fromScale(1, 1)
	videoDisplay.BackgroundTransparency = 1
	videoDisplay.BorderSizePixel = 0
	videoDisplay.ZIndex = 2
	videoDisplay.Parent = cloudClientStreamSurface

	local audioDeviceOutput = Instance.new("AudioDeviceOutput")
	audioDeviceOutput.Name = "AudioDeviceOutput"
	audioDeviceOutput.Parent = cloudClientStreamSurface

	cloudClientStream.Parent = CoreGui

	return {
		screenGui = cloudClientStream,
		frame = cloudClientStreamSurface,
		realtimeMedia = realtimeMedia,
		videoDisplay = videoDisplay,
		audioDeviceOutput = audioDeviceOutput
	}
end

function v5.createWire(sourceInstance, targetInstance, parent)
	local wire = Instance.new("Wire")
	wire.SourceInstance = sourceInstance
	wire.TargetInstance = targetInstance
	wire.SourceName = "Output"
	wire.TargetName = "Input"
	wire.Parent = parent
	return wire
end

function v5.createAudioDeviceInput(player, active, parent)
	local audioDeviceInput = Instance.new("AudioDeviceInput")
	audioDeviceInput.Player = player
	audioDeviceInput.Active = active
	audioDeviceInput.Parent = parent
	return audioDeviceInput
end

function v5.setStatusBarHidden(p2)
	GuiService:BroadcastNotification(
		HttpService:JSONEncode({ hidden = p2 }),
		notificationType.SET_STATUS_BAR_STYLE
	)
end

function v5.setInGameStreaming(p2)
	GuiService:BroadcastNotification(
		HttpService:JSONEncode({ inGameStreaming = p2 }),
		notificationType.GAME_STREAMING_STATUS_CHANGED
	)
end

function v5.set3dRenderingEnabled(p2)
	RunService:Set3dRenderingEnabled(p2)
end

function v5.acquireDisplayWakeLock()
	return DeviceDisplayService:AcquireWakeLock("VideoServer")
end

function v5.connectGameStreamingResolutionReady(onGameStreamingResolutionReady)
	return VideoService.GameStreamingResolutionReady:Connect(onGameStreamingResolutionReady)
end

return v5
