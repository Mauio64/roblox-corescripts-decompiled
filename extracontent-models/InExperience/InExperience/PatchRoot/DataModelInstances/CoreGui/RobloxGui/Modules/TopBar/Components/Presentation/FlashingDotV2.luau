local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")

game:GetService("VideoCaptureService")

local FaceAnimatorService = game:GetService("FaceAnimatorService")
local Roact = require(CorePackages.Packages.Roact)

require(CorePackages.Packages.UIBlox)

local ReactUtils = require(CorePackages.Packages.ReactUtils)
local t = require(CorePackages.Packages.t)
local EventConnection = ReactUtils.EventConnection
local Modules = CoreGui.RobloxGui.Modules
local default = require(Modules.VoiceChat.VoiceChatServiceManager).default
local cameraDevicePermissionGrantedSignal = require(CoreGui.RobloxGui.Modules.Settings.cameraDevicePermissionGrantedSignal)
local v12 = Roact.PureComponent:extend("FlashingDot")

local function lerpNum(n1: number, n2: number, n3: number) -- line: 29
	return n1 + (n2 - n1) * n3
end

v12.validateProps = t.strictInterface({})

function v12.init(p1) -- line: 35
	-- upvalues: Roact (copy), default (copy), FaceAnimatorService (copy), cameraDevicePermissionGrantedSignal (copy)
	p1:setState({
		Visible = false,
		isUsingMic = false
	})
	p1.prevTime = 1.5707963267948966
	p1.prevSinTime = 1

	local v18, v19 = Roact.createBinding(0)

	p1.transparencyBinding = v18
	p1.updateTransparencyBinding = v19

	function p1.checkNewVisibility() -- line: 45
		-- upvalues: default (copy), FaceAnimatorService (copy), p1 (copy)
		local v24 = default.localMuted ~= nil and not default.localMuted
		local v25 = FaceAnimatorService:IsStarted() and FaceAnimatorService.VideoAnimationEnabled
		local v26 = v24 or v25

		if v26 ~= p1.state.Visible then
			p1:setState({
				Visible = v26,
				isUsingMic = v24
			})
		end
	end
	function p1.animationConnection(p2) -- line: 61
		-- upvalues: p1 (copy)
		local v28 = p1.prevTime + p2
		local v29 = math.sin(v28 * 3)
		local v30 = math.abs(p1.prevSinTime)

		p1.updateTransparencyBinding(v30 * -0.5 + 0.5)
		p1.prevTime = v28
		p1.prevSinTime = v29
	end
	function p1.teardownCameraPermissionGrantedListener() -- line: 71
		-- upvalues: p1 (copy)
		if p1.cameraPermissionGrantedListener then
			p1.cameraPermissionGrantedListener:disconnect()
			p1.cameraPermissionGrantedListener = nil
		end
	end

	p1.cameraPermissionGrantedListener = cameraDevicePermissionGrantedSignal:connect(function() -- line: 79
		-- upvalues: p1 (copy)
		p1.checkNewVisibility()
	end)
end
function v12.didMount(p3) -- line: 84
	p3.checkNewVisibility()
end
function v12.willUnmount(p4) -- line: 88
	if p4.teardownCameraPermissionGrantedListener then
		p4.teardownCameraPermissionGrantedListener()
	end
end
function v12.render(p5) -- line: 94
	-- upvalues: Roact (copy), EventConnection (copy), default (copy), FaceAnimatorService (copy), RunService (copy)
	local uDim2 = UDim2.fromOffset(4, 4)

	return Roact.createElement("Frame", {
		ZIndex = 2,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -4, 0, 3),
		Size = UDim2.fromOffset(4, 4),
		Visible = p5.state.Visible
	}, {
		FlashingDot = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/AnimationEditor/FaceCaptureUI/FlashingDot.png",
			LayoutOrder = 2,
			Size = uDim2,
			ImageTransparency = p5.transparencyBinding
		}),
		MuteChangedEvent = Roact.createElement(EventConnection, {
			event = default.muteChanged.Event,
			callback = p5.checkNewVisibility
		}),
		CameraChangedEvent = Roact.createElement(EventConnection, {
			event = FaceAnimatorService:GetPropertyChangedSignal("VideoAnimationEnabled"),
			callback = p5.checkNewVisibility
		}),
		AnimationConnection = if not p5.state.Visible then nil else Roact.createElement(EventConnection, {
			event = RunService.RenderStepped,
			callback = p5.animationConnection
		})
	})
end

return v12
