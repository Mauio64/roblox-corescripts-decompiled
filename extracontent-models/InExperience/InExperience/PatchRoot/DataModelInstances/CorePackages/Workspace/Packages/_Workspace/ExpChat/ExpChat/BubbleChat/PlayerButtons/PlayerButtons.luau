local FaceAnimatorService = game:GetService("FaceAnimatorService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Roact = require(ExpChatParent.Roact)
local RoactRodux = require(ExpChatParent.RoactRodux)
local ReactUtils = require(ExpChatParent.ReactUtils)
local Dictionary = require(ExpChatParent.llama).Dictionary
local SharedFlags = require(ExpChatParent.SharedFlags)
local EventConnection = ReactUtils.EventConnection
local Config = require(ExpChat.Config)
local AvatarChatUISettings = Config.AvatarChatUISettings
local Permissions = Config.Permissions
local GlobalFlags = require(ExpChat.GlobalFlags)
local FFlagExpChatUseProximityStore = SharedFlags.FFlagExpChatUseProximityStore
local v15 = if not FFlagExpChatUseProximityStore then nil else require(ExpChatParent.ReactIs)
local ControlBubble = require(script.Parent.ControlBubble)
local GetFFlagExpChatEnableVoiceReverseNudge = require(ExpChat.Flags.GetFFlagExpChatEnableVoiceReverseNudge)
local GetFFlagExpChatUseVoiceParticipantsStore = SharedFlags.GetFFlagExpChatUseVoiceParticipantsStore
local v19 = game:DefineFastFlag("PreventMicToggleIfGameConsumedEvent", false)
local v20 = Roact.PureComponent:extend("PlayerButtons")

v20.defaultProps = {
	LayoutOrder = 1
}

function v20.init(p1) -- line: 41
	-- upvalues: FaceAnimatorService (copy), v19 (copy), GetFFlagExpChatUseVoiceParticipantsStore (copy), Permissions (copy)
	p1:setState({
		cameraEnabled = not not FaceAnimatorService and (FaceAnimatorService:IsStarted() and FaceAnimatorService.VideoAnimationEnabled)
	})

	function p1.toggleMic(p2, p3) -- line: 49
		-- upvalues: v19 (copy), p1 (copy), GetFFlagExpChatUseVoiceParticipantsStore (copy)
		if v19 and p2 then
			return
		end

		p1.props.onClickedVoiceIndicator(p1.props.userId, if not GetFFlagExpChatUseVoiceParticipantsStore() then p1.props.voiceState else p3)
	end
	function p1.onVideoButtonPressed() -- line: 61
		-- upvalues: p1 (copy), Permissions (copy)
		if not p1.props.hasCameraPermissions then
			if p1.props.getPermissions then
				p1.props.getPermissions(function(p4, _) -- line: 64
					-- upvalues: p1 (copy)
					if p4 then
						p1:toggleVideo()

						if p1.props.setCameraPermissionStateFromControl then
							p1.props.setCameraPermissionStateFromControl(p4)

							return
						end
					elseif p1.props.displayCameraDeniedToast then
						p1.props.displayCameraDeniedToast()
					end
				end, Permissions.CAMERA_ACCESS)

				return
			end
		else
			p1:toggleVideo()
		end
	end
	function p1.toggleVideo() -- line: 86
		-- upvalues: p1 (copy)
		p1.props.onClickedCameraIndicator()
	end
	function p1.updateVideo() -- line: 90
		-- upvalues: p1 (copy), FaceAnimatorService (copy)
		p1:setState({
			cameraEnabled = FaceAnimatorService.VideoAnimationEnabled
		})
	end
end
function v20.shouldShowCameraIndicator(p6) -- line: 97
	return p6.props.isLocalPlayer and p6:getCameraButtonVisibleAtMount()
end
function v20.shouldShowMicOffIndicator(p7) -- line: 101
	-- upvalues: GlobalFlags (copy)
	if p7.props.isLocalPlayer then
		local v25 = p7.props.voiceState == "Muted" or p7.props.voiceState == "LOCAL_MUTED"

		if GlobalFlags.JoinWithoutMicPermissions then
			return v25
		end

		return v25 or not p7.props.hasMicPermissions
	end

	return false
end
function v20.getCameraButtonVisibleAtMount(p8) -- line: 114
	if p8.props.isCameraOnlyUser and p8.props.isCameraOnlyUser() then
		return false
	end

	if p8.props.isCamEnabledForUserAndPlace then
		return p8.props.isCamEnabledForUserAndPlace()
	end

	return false
end
function v20.render(p9) -- line: 130
	-- upvalues: GlobalFlags (copy), GetFFlagExpChatUseVoiceParticipantsStore (copy), AvatarChatUISettings (copy), Roact (copy), FFlagExpChatUseProximityStore (copy), v15 (copy), Dictionary (copy), ControlBubble (copy), FaceAnimatorService (copy), EventConnection (copy)
	local u28 = p9.props.hasMicPermissions or p9.props.voiceEnabled

	if GlobalFlags.JoinWithoutMicPermissions then
		u28 = p9.props.voiceEnabled
	end

	local v29 = p9:shouldShowCameraIndicator()
	local v30 = not GetFFlagExpChatUseVoiceParticipantsStore() and p9:shouldShowMicOffIndicator()
	local v31 = v29 and u28
	local chatSettings = p9.props.chatSettings
	local v33 = v31 and AvatarChatUISettings.DoubleIconCornerRadiusOffset or AvatarChatUISettings.SingleIconCornerRadiusOffset
	local v34 = v31 and AvatarChatUISettings.DoubleIconButtonSize or AvatarChatUISettings.SingleIconButtonSize
	local v35 = not p9.props.isLocalPlayer and "speaker" or "microphone"
	local v36 = (not p9.state.cameraEnabled or not p9:getCameraButtonVisibleAtMount()) and "icons/controls/voice/video_off_light" or "icons/controls/voice/video_on_light"

	return Roact.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1, -8),
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.fromOffset(0, AvatarChatUISettings.FrameHeight),
		LayoutOrder = p9.props.LayoutOrder,
		BackgroundTransparency = chatSettings.BackgroundTransparency,
		BackgroundColor3 = chatSettings.BackgroundColor3,
		Visible = if not FFlagExpChatUseProximityStore or not v15.isBinding(p9.props.Visible) then u28 or v29 else p9.props.Visible:map(function(p10) -- line: 163
			-- upvalues: u28 (ref), v29 (copy)
			return p10 and u28 or v29
		end)
	}, {
		Scale = Roact.createElement("UIScale", {
			Scale = p9.props.isInsideMaximizeDistance and 1 or 0.75
		}),
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, v33)
		}),
		Container = Roact.createElement("ImageLabel", Dictionary.join({
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1)
		}, chatSettings.ImageLabel), {
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, v33)
			}),
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			MicrophoneBubble = u28 and Roact.createElement(ControlBubble, {
				LayoutOrder = 1,
				onActivated = p9.toggleMic,
				chatSettings = chatSettings,
				controlBubbleSize = v34,
				cornerRadiusOffset = v33,
				iconAssetName = if not v30 then nil else "icons/controls/voice/microphone_off_light",
				iconSize = AvatarChatUISettings.IconSize,
				iconTransparency = AvatarChatUISettings.IconTransparency,
				voiceState = if not GetFFlagExpChatUseVoiceParticipantsStore() then p9.props.voiceState else nil,
				iconStyle = v35,
				isUserToxic = if not GetFFlagExpChatUseVoiceParticipantsStore() then p9.props.isUserToxic else nil,
				userId = if not GetFFlagExpChatUseVoiceParticipantsStore() then nil else p9.props.userId
			}),
			Divider = u28 and (v29 and Roact.createElement("Frame", {
				BorderSizePixel = 0,
				LayoutOrder = 2,
				ZIndex = 1,
				Size = AvatarChatUISettings.DividerSize,
				AnchorPoint = Vector2.new(0.5, 1),
				BackgroundColor3 = AvatarChatUISettings.DividerColor
			})),
			CameraBubble = v29 and Roact.createElement(ControlBubble, {
				LayoutOrder = 3,
				onActivated = p9.onVideoButtonPressed or p9.toggleVideo,
				chatSettings = chatSettings,
				cornerRadiusOffset = v33,
				controlBubbleSize = v34,
				iconAssetName = v36,
				iconSize = AvatarChatUISettings.IconSize,
				iconTransparency = AvatarChatUISettings.IconTransparency,
				iconStyle = v35,
				isUserToxic = if not GetFFlagExpChatUseVoiceParticipantsStore() then p9.props.isUserToxic else nil
			})
		}),
		Carat = chatSettings.TailVisible and Roact.createElement("ImageLabel", {
			LayoutOrder = 3,
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/InGameChat/Caret.png",
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 1, -1),
			Size = UDim2.fromOffset(12, 8),
			ImageColor3 = chatSettings.BackgroundColor3,
			ImageTransparency = chatSettings.BackgroundTransparency
		}, {
			CaratGradient = chatSettings.UIGradient and Roact.createElement("UIGradient", chatSettings.UIGradient)
		}),
		BubbleGradient = chatSettings.UIGradient and Roact.createElement("UIGradient", chatSettings.UIGradient),
		VideoEnabledChanged = FaceAnimatorService and Roact.createElement(EventConnection, {
			event = FaceAnimatorService:GetPropertyChangedSignal("VideoAnimationEnabled"),
			callback = p9.updateVideo
		}) or nil
	})
end

local function mapStateToProps(p11, p12) -- line: 246
	-- upvalues: GetFFlagExpChatEnableVoiceReverseNudge (copy)
	local v39 = false

	if GetFFlagExpChatEnableVoiceReverseNudge() and p11.ReverseNudgeToxicUsers then
		v39 = p11.ReverseNudgeToxicUsers[p12.userId]

		if v39 == nil then
			v39 = false
		end
	end

	return {
		voiceState = p11.Voice.participants[p12.userId],
		isUserToxic = v39
	}
end

if GetFFlagExpChatUseVoiceParticipantsStore() then
	return v20
end

return RoactRodux.connect(mapStateToProps)(v20)
