local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local VideoCaptureService = game:GetService("VideoCaptureService")
local FaceAnimatorService = game:GetService("FaceAnimatorService")

local Roact = require(CorePackages.Packages.Roact)
local ReactUtils = require(CorePackages.Packages.ReactUtils)
local t = require(CorePackages.Packages.t)

local EventConnection = ReactUtils.EventConnection

local Modules = CoreGui.RobloxGui.Modules
local VoiceChatServiceManager = require(Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default
local getCamMicPermissions = require(Modules.Settings.getCamMicPermissions)

local extended = Roact.PureComponent:extend("FlashingDot")

local function lerpNum(p: number, p2: number, p3: number)
	return p + (p2 - p) * p3
end

extended.validateProps = t.strictInterface({})

function extended:init()
	self:setState({
		Visible = false,
		isUsingMic = false,
		hasMicPermissions = false,
		hasCameraPermissions = false
	})

	self.prevTime = 1.5707963267948966
	self.prevSinTime = 1
	local binding, updateTransparencyBinding = Roact.createBinding(0)
	self.transparencyBinding = binding
	self.updateTransparencyBinding = updateTransparencyBinding

	function self.checkNewVisibility()
		local isUsingMic = self.state.hasMicPermissions

		if isUsingMic then
			if default.localMuted == nil then
				isUsingMic = false
			else
				isUsingMic = not default.localMuted
			end
		end

		local active = self.state.hasCameraPermissions
			and FaceAnimatorService.VideoAnimationEnabled
			and VideoCaptureService.Active
		local visible = isUsingMic or active

		if self.state.Visible ~= visible then
			self:setState({ Visible = visible, isUsingMic = isUsingMic })
		end
	end

	function self.animationConnection(p)
		local prevTime = self.prevTime + p
		local prevSinTime2 = math.sin(prevTime * 3)

		local prevSinTime = math.abs(self.prevSinTime)
		self.updateTransparencyBinding(prevSinTime * -0.5 + 0.5)
		self.prevTime = prevTime
		self.prevSinTime = prevSinTime2
	end
end

function extended:didMount()
	self.isMounted = true
	getCamMicPermissions(function(p)
		if not self.isMounted then
			return
		end

		self:setState({
			hasCameraPermissions = p.hasCameraPermissions,
			hasMicPermissions = p.hasMicPermissions
		})
	end, nil, nil, "FlashingDot.didMount")
	self.checkNewVisibility()
end

function extended.didUpdate(p, p2, _)
	if p.state.hasMicPermissions ~= p2.hasMicPermissions or p.state.hasCameraPermissions ~= p2.hasCameraPermissions then
		p.checkNewVisibility()
	end
end

function extended.render(props)
	local udim = UDim2.fromOffset(4, 4)

	local createElement = Roact.createElement
	local v = {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -4, 0, 3),
		Size = UDim2.fromOffset(4, 4),
		ZIndex = 2,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Visible = props.state.Visible
	}
	local v2 = {
		FlashingDot = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Size = udim,
			Image = "rbxasset://textures/AnimationEditor/FaceCaptureUI/FlashingDot.png",
			ImageTransparency = props.transparencyBinding,
			LayoutOrder = 2
		}),
		MuteChangedEvent = Roact.createElement(EventConnection, {
			event = default.muteChanged.Event,
			callback = props.checkNewVisibility
		}),
		CameraChangedEvent = Roact.createElement(EventConnection, {
			event = FaceAnimatorService:GetPropertyChangedSignal("VideoAnimationEnabled"),
			callback = props.checkNewVisibility
		}),
		AnimationConnection = 0
	}
	local animationConnection

	if props.state.Visible then
		animationConnection = Roact.createElement(EventConnection, {
			event = RunService.RenderStepped,
			callback = props.animationConnection
		})
	end

	v2.AnimationConnection = animationConnection
	return createElement("Frame", v, v2)
end

function extended:willUnmount()
	self.isMounted = false
end

return extended
