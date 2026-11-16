local FaceAnimatorService = game:GetService("FaceAnimatorService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local Roact = require(parent.Roact)
local RoactRodux = require(parent.RoactRodux)
local ReactUtils = require(parent.ReactUtils)
local llama = require(parent.llama)
local dictionary = llama.Dictionary
local SharedFlags = require(parent.SharedFlags)

local EventConnection = ReactUtils.EventConnection

local Config = require(ExpChat.Config)
local AvatarChatUISettings = Config.AvatarChatUISettings
local Permissions = Config.Permissions
local GlobalFlags = require(ExpChat.GlobalFlags)
local FFlagExpChatUseProximityStore = SharedFlags.FFlagExpChatUseProximityStore
local ReactIs

if FFlagExpChatUseProximityStore then
	ReactIs = require(parent.ReactIs)
else
	ReactIs = nil
end

local ControlBubble = require(script.Parent.ControlBubble)
local GetFFlagExpChatEnableVoiceReverseNudge = require(ExpChat.Flags.GetFFlagExpChatEnableVoiceReverseNudge)

local GetFFlagExpChatUseVoiceParticipantsStore = SharedFlags.GetFFlagExpChatUseVoiceParticipantsStore

local defineFastFlag = game:DefineFastFlag("PreventMicToggleIfGameConsumedEvent", false)

local extended = Roact.PureComponent:extend("PlayerButtons")

extended.defaultProps = { LayoutOrder = 1 }

function extended:init()
	local cameraEnabled

	if FaceAnimatorService then
		cameraEnabled = FaceAnimatorService:IsStarted() and FaceAnimatorService.VideoAnimationEnabled
	else
		cameraEnabled = false
	end

	self:setState({ cameraEnabled = cameraEnabled })

	function self.toggleMic(p, p2)
		if defineFastFlag and p then
			return
		end

		local onClickedVoiceIndicator = self.props.onClickedVoiceIndicator
		local userId = self.props.userId

		if not GetFFlagExpChatUseVoiceParticipantsStore() then
			p2 = self.props.voiceState
		end

		onClickedVoiceIndicator(userId, p2)
	end

	function self.onVideoButtonPressed()
		if self.props.hasCameraPermissions then
			self:toggleVideo()
		else
			local function fn(p, _)
				if p then
					self:toggleVideo()

					if self.props.setCameraPermissionStateFromControl then
						self.props.setCameraPermissionStateFromControl(p)
					end
				elseif self.props.displayCameraDeniedToast then
					self.props.displayCameraDeniedToast()
				end
			end

			if self.props.getPermissions then
				self.props.getPermissions(fn, Permissions.CAMERA_ACCESS)
			end
		end
	end

	function self.toggleVideo()
		self.props.onClickedCameraIndicator()
	end

	function self.updateVideo()
		self:setState({ cameraEnabled = FaceAnimatorService.VideoAnimationEnabled })
	end
end

function extended:shouldShowCameraIndicator()
	return self.props.isLocalPlayer and self:getCameraButtonVisibleAtMount()
end

function extended:shouldShowMicOffIndicator()
	if not self.props.isLocalPlayer then
		return false
	end

	local v = self.props.voiceState == "Muted" or self.props.voiceState == "LOCAL_MUTED"

	if GlobalFlags.JoinWithoutMicPermissions then
		return v
	end

	return v or not self.props.hasMicPermissions
end

function extended:getCameraButtonVisibleAtMount()
	if self.props.isCameraOnlyUser and self.props.isCameraOnlyUser() then
		return false
	end

	if self.props.isCamEnabledForUserAndPlace then
		return self.props.isCamEnabledForUserAndPlace()
	end

	return false
end

function extended:render()
	local v = self.props.hasMicPermissions or self.props.voiceEnabled

	if GlobalFlags.JoinWithoutMicPermissions then
		v = self.props.voiceEnabled
	end

	local shouldShowCameraIndicator = self:shouldShowCameraIndicator()
	local v2

	if GetFFlagExpChatUseVoiceParticipantsStore() then
		v2 = false
	else
		v2 = self:shouldShowMicOffIndicator()
	end

	local v3 = shouldShowCameraIndicator and v
	local chatSettings = self.props.chatSettings

	local doubleIconCornerRadiusOffset = v3 and AvatarChatUISettings.DoubleIconCornerRadiusOffset
		or AvatarChatUISettings.SingleIconCornerRadiusOffset
	local doubleIconButtonSize = v3 and AvatarChatUISettings.DoubleIconButtonSize
		or AvatarChatUISettings.SingleIconButtonSize

	local iconStyle = self.props.isLocalPlayer and "microphone" or "speaker"

	local iconAssetName = self.state.cameraEnabled
		and self:getCameraButtonVisibleAtMount()
		and "icons/controls/voice/video_on_light"
		or "icons/controls/voice/video_off_light"

	local createElement = Roact.createElement
	local v4 = {
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1, -8),
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.fromOffset(0, AvatarChatUISettings.FrameHeight),
		LayoutOrder = self.props.LayoutOrder,
		BackgroundTransparency = chatSettings.BackgroundTransparency,
		BackgroundColor3 = chatSettings.BackgroundColor3,
		Visible = 0
	}
	local visible

	if FFlagExpChatUseProximityStore and ReactIs.isBinding(self.props.Visible) then
		visible = self.props.Visible:map(function(p)
			return p and v or shouldShowCameraIndicator
		end)
	else
		visible = v or shouldShowCameraIndicator
	end

	v4.Visible = visible

	local v5 = {
		Scale = Roact.createElement("UIScale", {
			Scale = self.props.isInsideMaximizeDistance and 1 or 0.75
		}),
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, doubleIconCornerRadiusOffset)
		}),
		Container = 0,
		Carat = 0,
		BubbleGradient = 0,
		VideoEnabledChanged = 0
	}

	local createElement2 = Roact.createElement

	local joined = dictionary.join(
		{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 },
		chatSettings.ImageLabel
	)
	local v6 = {
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, doubleIconCornerRadiusOffset)
		}),
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		MicrophoneBubble = 0,
		Divider = 0,
		CameraBubble = 0
	}

	local microphoneBubble = v

	if microphoneBubble then
		local createElement3 = Roact.createElement
		local v7 = {
			LayoutOrder = 1,
			onActivated = self.toggleMic,
			chatSettings = chatSettings,
			controlBubbleSize = doubleIconButtonSize,
			cornerRadiusOffset = doubleIconCornerRadiusOffset,
			iconAssetName = v2 and "icons/controls/voice/microphone_off_light" or nil,
			iconSize = AvatarChatUISettings.IconSize,
			iconTransparency = AvatarChatUISettings.IconTransparency,
			voiceState = 0,
			iconStyle = 0,
			isUserToxic = 0,
			userId = 0
		}
		local voiceState

		if not GetFFlagExpChatUseVoiceParticipantsStore() then
			voiceState = self.props.voiceState
		end

		v7.voiceState = voiceState
		v7.iconStyle = iconStyle
		local isUserToxic

		if not GetFFlagExpChatUseVoiceParticipantsStore() then
			isUserToxic = self.props.isUserToxic
		end

		v7.isUserToxic = isUserToxic
		local userId

		if GetFFlagExpChatUseVoiceParticipantsStore() then
			userId = self.props.userId
		end

		v7.userId = userId
		microphoneBubble = createElement3(ControlBubble, v7)
	end

	v6.MicrophoneBubble = microphoneBubble

	v6.Divider = v and shouldShowCameraIndicator and Roact.createElement("Frame", {
		Size = AvatarChatUISettings.DividerSize,
		AnchorPoint = Vector2.new(0.5, 1),
		BorderSizePixel = 0,
		LayoutOrder = 2,
		ZIndex = 1,
		BackgroundColor3 = AvatarChatUISettings.DividerColor
	})
	local cameraBubble

	if shouldShowCameraIndicator then
		local createElement3 = Roact.createElement
		local v7 = {
			LayoutOrder = 3,
			onActivated = self.onVideoButtonPressed or self.toggleVideo,
			chatSettings = chatSettings,
			cornerRadiusOffset = doubleIconCornerRadiusOffset,
			controlBubbleSize = doubleIconButtonSize,
			iconAssetName = iconAssetName,
			iconSize = AvatarChatUISettings.IconSize,
			iconTransparency = AvatarChatUISettings.IconTransparency,
			iconStyle = iconStyle,
			isUserToxic = 0
		}
		local isUserToxic

		if not GetFFlagExpChatUseVoiceParticipantsStore() then
			isUserToxic = self.props.isUserToxic
		end

		v7.isUserToxic = isUserToxic
		cameraBubble = createElement3(ControlBubble, v7)
	else
		cameraBubble = shouldShowCameraIndicator
	end

	v6.CameraBubble = cameraBubble
	v5.Container = createElement2("ImageLabel", joined, v6)

	v5.Carat = chatSettings.TailVisible and Roact.createElement("ImageLabel", {
		LayoutOrder = 3,
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 1, -1),
		Size = UDim2.fromOffset(12, 8),
		Image = "rbxasset://textures/ui/InGameChat/Caret.png",
		ImageColor3 = chatSettings.BackgroundColor3,
		ImageTransparency = chatSettings.BackgroundTransparency
	}, {
		CaratGradient = chatSettings.UIGradient and Roact.createElement("UIGradient", chatSettings.UIGradient)
	})

	v5.BubbleGradient = chatSettings.UIGradient and Roact.createElement("UIGradient", chatSettings.UIGradient)
	v5.VideoEnabledChanged = FaceAnimatorService
		and Roact.createElement(EventConnection, {
			event = FaceAnimatorService:GetPropertyChangedSignal("VideoAnimationEnabled"),
			callback = self.updateVideo
		})
		or nil
	return createElement("Frame", v4, v5)
end

local function mapStateToProps(p, p2)
	local isUserToxic

	if GetFFlagExpChatEnableVoiceReverseNudge() and p.ReverseNudgeToxicUsers then
		isUserToxic = p.ReverseNudgeToxicUsers[p2.userId]

		if isUserToxic == nil then
			isUserToxic = false
		end
	else
		isUserToxic = false
	end

	return { voiceState = p.Voice.participants[p2.userId], isUserToxic = isUserToxic }
end

if GetFFlagExpChatUseVoiceParticipantsStore() then
	return extended
end

return RoactRodux.connect(mapStateToProps)(extended)
