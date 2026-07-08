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
local default = require(Modules.VoiceChat.VoiceChatServiceManager).default
local getCamMicPermissions = require(Modules.Settings.getCamMicPermissions)
local v13 = Roact.PureComponent:extend("FlashingDot")

local function lerpNum(n1: number, n2: number, n3: number) -- line: 26
	return n1 + (n2 - n1) * n3
end

v13.validateProps = t.strictInterface({})

function v13.init(p1) -- line: 32
	-- upvalues: Roact (copy), default (copy), FaceAnimatorService (copy), VideoCaptureService (copy)
	p1:setState({
		Visible = false,
		isUsingMic = false,
		hasMicPermissions = false,
		hasCameraPermissions = false
	})
	p1.prevTime = 1.5707963267948966
	p1.prevSinTime = 1

	local v19, v20 = Roact.createBinding(0)

	p1.transparencyBinding = v19
	p1.updateTransparencyBinding = v20

	function p1.checkNewVisibility() -- line: 44
		-- upvalues: p1 (copy), default (copy), FaceAnimatorService (copy), VideoCaptureService (copy)
		local v28 = p1.state.hasMicPermissions and (default.localMuted ~= nil and not default.localMuted)
		local v29 = p1.state.hasCameraPermissions and (FaceAnimatorService.VideoAnimationEnabled and VideoCaptureService.Active)
		local v30 = v28 or v29

		if v30 ~= p1.state.Visible then
			p1:setState({
				Visible = v30,
				isUsingMic = v28
			})
		end
	end
	function p1.animationConnection(p2) -- line: 66
		-- upvalues: p1 (copy)
		local v32 = p1.prevTime + p2
		local v33 = math.sin(v32 * 3)
		local v34 = math.abs(p1.prevSinTime)

		p1.updateTransparencyBinding(v34 * -0.5 + 0.5)
		p1.prevTime = v32
		p1.prevSinTime = v33
	end
end
function v13.didMount(p3) -- line: 77
	-- upvalues: getCamMicPermissions (copy)
	p3.isMounted = true
	getCamMicPermissions(function(p4) -- line: 79
		-- upvalues: p3 (copy)
		if not p3.isMounted then
			return
		end

		p3:setState({
			hasCameraPermissions = p4.hasCameraPermissions,
			hasMicPermissions = p4.hasMicPermissions
		})
	end, nil, nil, "FlashingDot.didMount")
	p3.checkNewVisibility()
end
function v13.didUpdate(p5, p6, _) -- line: 93
	if p5.state.hasMicPermissions ~= p6.hasMicPermissions or p5.state.hasCameraPermissions ~= p6.hasCameraPermissions then
		p5.checkNewVisibility()
	end
end
function v13.render(p8) -- line: 102
	-- upvalues: Roact (copy), EventConnection (copy), default (copy), FaceAnimatorService (copy), RunService (copy)
	local uDim2 = UDim2.fromOffset(4, 4)

	return Roact.createElement("Frame", {
		ZIndex = 2,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -4, 0, 3),
		Size = UDim2.fromOffset(4, 4),
		Visible = p8.state.Visible
	}, {
		FlashingDot = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/AnimationEditor/FaceCaptureUI/FlashingDot.png",
			LayoutOrder = 2,
			Size = uDim2,
			ImageTransparency = p8.transparencyBinding
		}),
		MuteChangedEvent = Roact.createElement(EventConnection, {
			event = default.muteChanged.Event,
			callback = p8.checkNewVisibility
		}),
		CameraChangedEvent = Roact.createElement(EventConnection, {
			event = FaceAnimatorService:GetPropertyChangedSignal("VideoAnimationEnabled"),
			callback = p8.checkNewVisibility
		}),
		AnimationConnection = if not p8.state.Visible then nil else Roact.createElement(EventConnection, {
			event = RunService.RenderStepped,
			callback = p8.animationConnection
		})
	})
end
function v13.willUnmount(p9) -- line: 138
	p9.isMounted = false
end

return v13
