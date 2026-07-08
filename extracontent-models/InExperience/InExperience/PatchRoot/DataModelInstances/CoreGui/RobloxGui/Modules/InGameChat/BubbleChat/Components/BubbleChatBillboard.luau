local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local StarterGui = game:GetService("StarterGui")
local VRService = game:GetService("VRService")
local v8 = require(script.Parent.Parent.Logger)(script.Name)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local Otter = require(CorePackages.Packages.Otter)
local BubbleChatList = require(script.Parent.BubbleChatList)
local ChatBubbleDistant = require(script.Parent.ChatBubbleDistant)
local VoiceBubble = require(script.Parent.VoiceBubble)
local VoiceIndicator = require(RobloxGui.Modules.VoiceChat.Components.VoiceIndicator)
local Types = require(script.Parent.Parent.Types)
local Constants = require(script.Parent.Parent.Constants)
local getSettingsForMessage = require(script.Parent.Parent.Helpers.getSettingsForMessage)
local selfViewVisibilityUpdatedSignal = require(RobloxGui.Modules.SelfView.selfViewVisibilityUpdatedSignal)
local Enabled = require(CorePackages.Workspace.Packages.Chrome).Enabled
local Constants2 = require(RobloxGui.Modules.VoiceChat.Constants)
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local GetFFlagMicConnectingToast = require(RobloxGui.Modules.Flags.GetFFlagMicConnectingToast)
local GetFFlagBubbleChatInexistantAdorneeFix = require(RobloxGui.Modules.Flags.GetFFlagBubbleChatInexistantAdorneeFix)
local publicApi = require(RobloxGui.Modules.SelfView.publicApi)
local v27 = game:DefineFastInt("BubbleVoiceTimeoutMillis", 1000)
local v28 = game:DefineFastFlag("DebugAllowControlButtonsNoVoiceChat", false)
local IXPServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper).IXPServiceWrapper
local v30 = game:DefineFastFlag("EasierUnmuting3", false)
local v31 = game:DefineFastFlag("EasierUnmutingBasedOnCamera", false)
local v32 = game:DefineFastFlag("EasierUnmutingHideIfMuted", false)
local v33 = game:DefineFastInt("EasierUnmutingDisplayDistance", 20)
local v34 = game:DefineFastString("EasierUnmutingIXPLayerName", "Voice.UserAgency")
local v35 = game:DefineFastString("EasierUnmutingIXPLayerValue", "VoiceUserAgencyEnabled")
local v36 = Roact.PureComponent:extend("BubbleChatBillboard")
local t1 = {
	dampingRatio = 1,
	frequency = 4
}

v36.validateProps = t.strictInterface({
	userId = t.string,
	onFadeOut = t.optional(t.callback),
	voiceEnabled = t.optional(t.boolean),
	bubbleChatEnabled = t.optional(t.boolean),
	chatSettings = Types.IChatSettings,
	messageIds = t.optional(t.array(t.string)),
	lastMessage = t.optional(Types.IMessage),
	voiceState = t.optional(t.string)
})

function getEasierUnmutingDistance(p1) -- line: 72
	-- upvalues: Players (copy), v31 (copy)
	if not p1 then
		return nil
	end

	local v42 = Players.LocalPlayer and (Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
	local v43 = v42 and (v42.CFrame and v42.CFrame.Position)
	local v44 = workspace.CurrentCamera and workspace.CurrentCamera.CFrame.Position

	if v31 or not v43 then
		if not v44 then
			return nil
		end

		return (p1 - v44).Magnitude
	end

	return (p1 - v43).Magnitude
end
function v36.init(p2) -- line: 98
	-- upvalues: publicApi (copy), StarterGui (copy), v30 (copy), v32 (copy), Roact (copy), Otter (copy), Players (copy), Constants (copy), default (copy), GetFFlagMicConnectingToast (copy), Constants2 (copy), VoiceIndicator (copy), selfViewVisibilityUpdatedSignal (copy), IXPServiceWrapper (copy), v34 (copy), v35 (copy)
	local v46 = publicApi.getSelfViewIsOpenAndVisible()
	local CoreGuiEnabled = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.SelfView)

	p2:setState({
		adornee = nil,
		isInsideRenderDistance = false,
		isInsideMaximizeDistance = false,
		voiceTimedOut = false,
		voiceStateCounter = 0,
		lastVoiceState = nil,
		savedChatSettings = p2.props.chatSettings,
		selfViewOpen = v46,
		selfViewEnabled = CoreGuiEnabled,
		isInsideEasierUnmutingDistance = not v30 and nil,
		isMuted = (not v30 or not v32) and nil,
		isInEasierUnmutingTreatment = not v30 and nil,
		haveLoggedUserExposure = not v30 and nil
	})
	p2.isMounted = false

	local v48, v49 = Roact.createBinding((Vector3.new()))

	p2.offset = v48
	p2.updateOffset = v49
	p2.offsetMotor = Otter.createSingleMotor(0)
	p2.offsetMotor:onStep(function(p3) -- line: 121
		-- upvalues: p2 (copy)
		p2.updateOffset((Vector3.new(0, p3, 0)))
	end)
	p2.offsetGoal = 0

	function p2.onSelfViewVisibilityUpdated() -- line: 126
		-- upvalues: p2 (copy), publicApi (copy)
		p2:setState({
			selfViewOpen = publicApi.getSelfViewIsOpenAndVisible()
		})
	end
	function p2.onLastBubbleFadeOut() -- line: 132
		-- upvalues: p2 (copy)
		if p2.props.onFadeOut and not p2.isFadingOut then
			p2.isFadingOut = true
			p2.props.onFadeOut(p2.props.userId)
		end

		if p2.state.hasMessage and p2.isMounted then
			p2:setState({
				hasMessage = false
			})
		end
	end

	if p2.props.voiceEnabled then
		local u50 = p2.props.userId ~= tostring(Players.LocalPlayer.UserId) and function() -- line: 158
			-- upvalues: default (copy), p2 (copy), Constants2 (copy)
			default:ToggleMutePlayer(tonumber(p2.props.userId), if not p2:isShowingDueToEasierUnmuting() then Constants2.VOICE_CONTEXT_TYPE.BUBBLE_CHAT else Constants2.VOICE_CONTEXT_TYPE.EASIER_UNMUTING)
		end or function() -- line: 148
			-- upvalues: p2 (copy), Constants (copy), default (copy), GetFFlagMicConnectingToast (copy)
			if p2.props.voiceState == Constants.VOICE_STATE.ERROR then
				default:RejoinPreviousChannel()

				return
			end

			if GetFFlagMicConnectingToast() and p2.props.voiceState == Constants.VOICE_STATE.CONNECTING then
				default:ShowVoiceChatLoadingMessage()

				return
			end

			default:ToggleMic("LegacyBubbleChat")
		end
		local userId = p2.props.userId
		local v52 = userId == tostring(Players.LocalPlayer.UserId) and "MicDark" or "SpeakerDark"

		function p2.renderInsert() -- line: 172
			-- upvalues: Roact (copy), VoiceIndicator (copy), u50 (ref), userId (copy), v52 (copy)
			return Roact.createElement(VoiceIndicator, {
				onClicked = u50,
				userId = userId,
				iconStyle = v52
			})
		end

		p2.insertSize = Vector2.new(28, 28)
	end

	function p2.onCoreGuiChanged() -- line: 183
		-- upvalues: StarterGui (copy), p2 (copy)
		local CoreGuiEnabled2 = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.SelfView)

		if CoreGuiEnabled2 ~= p2.state.selfViewOpen then
			p2:setState({
				selfViewOpen = CoreGuiEnabled2
			})
		end
	end

	p2.selfViewVisibilityUpdatedSignal = selfViewVisibilityUpdatedSignal:connect(function() -- line: 192
		-- upvalues: p2 (copy), publicApi (copy)
		p2:setState({
			selfViewOpen = publicApi.getSelfViewIsOpenAndVisible()
		})
	end)

	if v30 then
		local ok, result = pcall(function() -- line: 199
			-- upvalues: IXPServiceWrapper (copy), v34 (copy)
			return IXPServiceWrapper:GetLayerData(v34)
		end)

		if ok and result and result[v35] then
			p2:setState({
				isInEasierUnmutingTreatment = true
			})
		end
	end

	if v30 and p2.state.isInEasierUnmutingTreatment and v32 then
		p2.participantsUpdateConnection = default.participantsUpdate.Event:Connect(function(p4) -- line: 216
			-- upvalues: p2 (copy)
			local v124 = p4[p2.props.userId]

			if not v124 then
				return
			end

			if v124.isMuted ~= p2.state.isMuted then
				p2:setState({
					isMuted = v124.isMuted
				})
			end
		end)
	end
end
function v36.isShowingDueToEasierUnmuting(p5) -- line: 233
	-- upvalues: v30 (copy), Constants (copy), v32 (copy)
	return v30 and (p5.state.isInEasierUnmutingTreatment and (p5.props.voiceState == Constants.VOICE_STATE.LOCAL_MUTED and (p5.state.isInsideEasierUnmutingDistance and not (v32 and p5.state.isMuted))))
end
function v36.checkCounterForTimeout(p6, p7) -- line: 241
	-- upvalues: Players (copy), Constants (copy), v27 (copy)
	if p6.props.userId ~= tostring(Players.LocalPlayer.UserId) and p6.state.lastVoiceState ~= Constants.VOICE_STATE.TALKING and p7 ~= p6.state.voiceStateCounter then
		local voiceStateCounter = p6.state.voiceStateCounter

		delay(v27 / 1000, function() -- line: 250
			-- upvalues: p6 (copy), voiceStateCounter (copy)
			if p6.state.voiceStateCounter == voiceStateCounter and p6.isMounted then
				p6:setState({
					voiceTimedOut = true
				})
			end
		end)
	end
end
function v36.checkCounterForTimeoutWithEasierUnmuting(p8, p9) -- line: 261
	-- upvalues: v30 (copy), Players (copy), Constants (copy), v27 (copy)
	local v61 = if not p9 then nil else p9.voiceStateCounter

	if not v30 or not p8.state.isInEasierUnmutingTreatment then
		return p8:checkCounterForTimeout(v61)
	end

	local v62 = p8.props.userId ~= tostring(Players.LocalPlayer.UserId)
	local v63 = v61 ~= p8.state.voiceStateCounter
	local v64 = p8.state.lastVoiceState ~= Constants.VOICE_STATE.TALKING and p8.state.lastVoiceState ~= Constants.VOICE_STATE.LOCAL_MUTED

	if v62 and v63 and v64 then
		local voiceStateCounter = p8.state.voiceStateCounter

		delay(v27 / 1000, function() -- line: 279
			-- upvalues: p8 (copy), voiceStateCounter (copy)
			if p8.state.voiceStateCounter == voiceStateCounter and p8.isMounted then
				p8:setState({
					voiceTimedOut = true
				})
			end
		end)
	end
end
function v36.didMount(p10) -- line: 292
	-- upvalues: Otter (copy), Players (copy), RunService (copy), v30 (copy), v33 (copy), Constants (copy), t1 (copy)
	p10.isMounted = true

	local v67 = p10.props.lastMessage and p10.props.lastMessage.adornee

	p10:setState({
		adornee = v67
	})

	local v68 = p10:getVerticalOffset(v67)

	p10.offsetGoal = v68
	p10.offsetMotor:setGoal(Otter.instant(v68))

	local player = nil

	if v67 then
		player = Players:GetPlayerFromCharacter(v67)
	elseif tonumber(p10.props.userId) then
		player = Players:GetPlayerByUserId(p10.props.userId)
	end

	if player then
		if player.Character then
			coroutine.wrap(function() -- line: 313
				-- upvalues: p10 (copy), player (ref)
				p10:onCharacterAdded(player, player.Character)
			end)()
		end

		p10.characterConn = player.CharacterAdded:Connect(function(character) -- line: 317
			-- upvalues: p10 (copy), player (ref)
			p10:onCharacterAdded(player, character)
		end)
	end

	p10.heartbeatConn = RunService.Heartbeat:Connect(function() -- line: 323
		-- upvalues: p10 (copy), v30 (copy), v33 (copy), Constants (copy), Otter (copy), t1 (copy)
		local v126 = p10:getAdorneeInstance(p10.state.adornee)

		if workspace.CurrentCamera and v126 then
			local v127 = v126:IsA("Attachment") and v126.WorldPosition or v126.Position
			local Magnitude = (workspace.CurrentCamera.CFrame.Position - v127).Magnitude
			local v129 = Magnitude < p10.state.savedChatSettings.MaxDistance
			local v130 = Magnitude < p10.state.savedChatSettings.MinimizeDistance
			local v131 = false

			if v30 and p10.state.isInEasierUnmutingTreatment then
				local v132 = getEasierUnmutingDistance(v127)

				if v132 ~= nil then
					v131 = v132 < v33
				end
			end

			if v130 ~= p10.state.isInsideMaximizeDistance or v129 ~= p10.state.isInsideRenderDistance or v30 and p10.state.isInEasierUnmutingTreatment and v131 ~= p10.state.isInsideEasierUnmutingDistance then
				p10:setState({
					isInsideRenderDistance = v129,
					isInsideMaximizeDistance = v130,
					isInsideEasierUnmutingDistance = v131
				})
			end
		end

		local v133 = p10:getVerticalOffset(p10.state.adornee)

		if math.abs(v133 - p10.offsetGoal) > Constants.BILLBOARD_OFFSET_EPSILON then
			p10.offsetGoal = v133
			p10.offsetMotor:setGoal(Otter.spring(v133, t1))
		end
	end)

	if v30 and p10.state.isInEasierUnmutingTreatment then
		p10:checkCounterForTimeoutWithEasierUnmuting(nil)
	else
		p10:checkCounterForTimeout(nil)
	end
end
function v36.willUnmount(p11) -- line: 368
	-- upvalues: v8 (copy), v30 (copy), v32 (copy)
	v8:trace("Unmounting billboards for {}", p11.state.shortId)
	p11.isMounted = false

	if p11.characterConn then
		p11.characterConn:Disconnect()
		p11.characterConn = nil
	end

	if p11.heartbeatConn then
		p11.heartbeatConn:Disconnect()
		p11.heartbeatConn = nil
	end

	if p11.humanoidDiedConn then
		p11.humanoidDiedConn:Disconnect()
		p11.humanoidDiedConn = nil
	end

	p11.offsetMotor:destroy()

	if p11.selfViewVisibilityUpdatedSignal then
		p11.selfViewVisibilityUpdatedSignal:disconnect()
		p11.selfViewVisibilityUpdatedSignal = nil
	end

	if v30 and p11.state.isInEasierUnmutingTreatment and v32 and p11.participantsUpdateConnection then
		p11.participantsUpdateConnection:Disconnect()
		p11.participantsUpdateConnection = nil
	end
end

local function waitForFirst(...) -- line: 396
	local BindableEvent = Instance.new("BindableEvent")
	local t2 = { ... }

	local function fire(...) -- line: 400
		-- upvalues: t2 (copy), BindableEvent (copy)
		for i = 1, #t2 do
			t2[i]:Disconnect()
		end

		return BindableEvent:Fire(...)
	end

	for i = 1, #t2 do
		t2[i] = t2[i]:Connect(fire)
	end

	return BindableEvent.Event:Wait()
end
local function findFirstChildByNameAndClass(p12, p13, p14) -- line: 415
	for _, child in ipairs(p12:GetChildren()) do
		if p13 == child.Name and child:IsA(p14) then
			return child
		end
	end
end

function v36.onCharacterAdded(p15, p16, p17) -- line: 424
	-- upvalues: waitForFirst (copy), v8 (copy), GetFFlagBubbleChatInexistantAdorneeFix (copy), findFirstChildByNameAndClass (copy)
	if not p17.Parent then
		waitForFirst(p17.AncestryChanged, p16.CharacterAdded)
	end

	if p17 ~= p16.Character or not p17.Parent then
		v8:debug("Mismatched or unparented character in onCharacterAdded for {}", p15.state.shortId)

		return
	end

	local Humanoid = p17:FindFirstChildOfClass("Humanoid")

	while p17:IsDescendantOf(game) and not Humanoid do
		waitForFirst(p17.ChildAdded, p17.AncestryChanged, p16.CharacterAdded)
		Humanoid = p17:FindFirstChildOfClass("Humanoid")
	end

	if p17 ~= p16.Character or not p17:IsDescendantOf(game) then
		v8:debug("Mismatched or unparented character in onCharacterAdded for {}", p15.state.shortId)

		return
	end

	local v84 = if not GetFFlagBubbleChatInexistantAdorneeFix() then p17:FindFirstChild("HumanoidRootPart") else p17.PrimaryPart

	while p17:IsDescendantOf(game) and not v84 do
		waitForFirst(p17.ChildAdded, p17.AncestryChanged, p16.CharacterAdded)
		v84 = if not GetFFlagBubbleChatInexistantAdorneeFix() then p17:FindFirstChild("HumanoidRootPart") else p17.PrimaryPart
	end

	if v84 and p17:IsDescendantOf(game) and p17 == p16.Character and p15.isMounted then
		local v85 = findFirstChildByNameAndClass(p17, "Head", "BasePart")

		p15:setState({
			adornee = Humanoid.Health == 0 and v85 or p17
		})

		if p15.humanoidDiedConn then
			p15.humanoidDiedConn:Disconnect()
			p15.humanoidDiedConn = nil
		end

		p15.humanoidDiedConn = Humanoid.Died:Connect(function() -- line: 474
			-- upvalues: p15 (copy), findFirstChildByNameAndClass (copy), p17 (copy)
			p15:setState({
				adornee = findFirstChildByNameAndClass(p17, "Head", "BasePart") or p17
			})
		end)
	end
end
function v36.getVerticalOffset(p18, p19) -- line: 484
	if p19 and p19:IsA("Model") then
		local v88, v89 = p19:GetBoundingBox()
		local v90 = p18:getAdorneeInstance(p19)

		if not v90 then
			return v89.Y / 2
		end

		if v90:IsA("BasePart") then
			local v91 = v88:PointToObjectSpace(v90.Position)

			return v89.Y / 2 - v91.Y
		end

		return 0
	end

	if p19 and p19:IsA("BasePart") then
		return p19.Size.Y / 2
	end

	return 0
end
function v36.getAdorneeInstance(p20, p21) -- line: 506
	-- upvalues: GetFFlagBubbleChatInexistantAdorneeFix (copy)
	if not p21 then
		return
	end

	if p21:IsA("Model") then
		local p20statesavedChatSettingsAdorneeName = p21:FindFirstChild(p20.state.savedChatSettings.AdorneeName, true)

		if GetFFlagBubbleChatInexistantAdorneeFix() then
			p20statesavedChatSettingsAdorneeName = p20statesavedChatSettingsAdorneeName or p21.PrimaryPart
		end

		if not p20statesavedChatSettingsAdorneeName or p20statesavedChatSettingsAdorneeName:IsA("BasePart") or p20statesavedChatSettingsAdorneeName:IsA("Attachment") then
			return p20statesavedChatSettingsAdorneeName
		end
	elseif p21:IsA("BasePart") or p21:IsA("Attachment") then
		return p21
	end
end
function v36.getRenderVoiceAndCameraBubble(p22) -- line: 522
	-- upvalues: v28 (copy), Players (copy), VRService (copy), Enabled (copy)
	if not p22.props.voiceEnabled and not v28 then
		return false
	end

	if p22.props.userId == tostring(Players.LocalPlayer.UserId) then
		if VRService.VREnabled or Enabled() then
			return false
		end

		if not p22.state.selfViewOpen then
			return true
		end

		return false
	end

	return p22.props.voiceEnabled and not p22.state.voiceTimedOut
end
function v36.shouldRenderCarat(p23) -- line: 552
	return p23.props.chatSettings.TailVisible and not p23:getRenderVoiceAndCameraBubble()
end
function v36.render(p24) -- line: 556
	-- upvalues: Players (copy), v8 (copy), v30 (copy), Constants (copy), v32 (copy), VRService (copy), Enabled (copy), Roact (copy), VoiceBubble (copy), BubbleChatList (copy), ChatBubbleDistant (copy)
	local v98 = p24:getAdorneeInstance(p24.state.adornee)
	local v99 = p24.props.userId == tostring(Players.LocalPlayer.UserId)
	local savedChatSettings = p24.state.savedChatSettings

	if not v98 then
		v8:trace("No adornee for {}", p24.state.shortId)

		return
	end

	if not p24.state.isInsideRenderDistance then
		v8:trace("Not in range for {}", p24.state.shortId)

		return
	end

	if v30 and p24.state.isInEasierUnmutingTreatment and p24.props.voiceState == Constants.VOICE_STATE.LOCAL_MUTED and (not p24.state.isInsideEasierUnmutingDistance or v32 and p24.state.isMuted) then
		v8:trace("Unmute toggle not applicable for {}", p24.state.shortId)

		return
	end

	local t3 = {}
	local v102 = p24.props.voiceEnabled and not p24.state.voiceTimedOut

	if (VRService.VREnabled or Enabled()) and v99 then
		v102 = false
	end

	if v102 and (not p24.props.bubbleChatEnabled or not p24.props.messageIds or #p24.props.messageIds == 0) then
		t3.VoiceBubble = Roact.createElement(VoiceBubble, {
			chatSettings = savedChatSettings,
			renderInsert = p24.renderInsert,
			insertSize = p24.insertSize,
			isDistant = not p24.state.isInsideMaximizeDistance
		})
	end

	if p24.state.hasMessage then
		if p24.state.isInsideMaximizeDistance then
			t3.BubbleChatList = Roact.createElement(BubbleChatList, {
				userId = p24.props.userId,
				isVisible = p24.state.isInsideMaximizeDistance,
				onLastBubbleFadeOut = p24.onLastBubbleFadeOut,
				chatSettings = savedChatSettings,
				renderFirstInsert = if not v102 then nil else p24.renderInsert,
				insertSize = p24.insertSize,
				showCarat = p24:shouldRenderCarat()
			})
		else
			t3.DistantBubble = Roact.createElement(ChatBubbleDistant, {
				fadingOut = not p24.props.messageIds or #p24.props.messageIds == 0,
				onFadeOut = p24.onLastBubbleFadeOut,
				chatSettings = savedChatSettings,
				renderInsert = v102 and p24.renderInsert,
				insertSize = p24.insertSize
			})
		end
	end

	local v103 = v99 and savedChatSettings.LocalPlayerStudsOffset or Vector3.new(0, 1, 0.10000000149011612)

	return Roact.createElement("BillboardGui", {
		ResetOnSpawn = false,
		Adornee = v98,
		Active = v102,
		Size = UDim2.fromOffset(500, 200),
		SizeOffset = Vector2.new(0, 0.5),
		StudsOffset = v103 + Vector3.new(0, savedChatSettings.VerticalStudsOffset, 0),
		StudsOffsetWorldSpace = p24.offset
	}, t3)
end
function v36.didUpdate(p25, _, p27) -- line: 652
	-- upvalues: v30 (copy), Players (copy), Constants (copy), IXPServiceWrapper (copy), v34 (copy)
	if (not p25.props.messageIds or #p25.props.messageIds == 0) and not p25.state.isInsideRenderDistance then
		p25.onLastBubbleFadeOut()
	end

	if p25.props.messageIds and #p25.props.messageIds > 0 then
		p25.isFadingOut = false
	end

	if v30 and p25.state.isInEasierUnmutingTreatment then
		p25:checkCounterForTimeoutWithEasierUnmuting(p27)
	else
		p25:checkCounterForTimeout(p27.voiceStateCounter)
	end

	local v107 = p25.props.userId == tostring(Players.LocalPlayer.UserId)

	if v30 and v107 and not p25.state.haveLoggedUserExposure and (p25.props.voiceState == Constants.VOICE_STATE.INACTIVE or p25.props.voiceState == Constants.VOICE_STATE.TALKING or p25.props.voiceState == Constants.VOICE_STATE.MUTED) then
		IXPServiceWrapper:LogUserLayerExposure(v34)
		p25:setState({
			haveLoggedUserExposure = true
		})
	end
end
function v36.getDerivedStateFromProps(p28, p29) -- line: 689
	local v110 = "..." .. string.sub(tostring(p28.userId), -4)
	local v111 = not p29.hasMessage and (p28.messageIds and #p28.messageIds > 0)
	local voiceState = nil
	local v113 = nil
	local v114 = nil

	if p29.lastVoiceState ~= p28.voiceState then
		v113 = (p29.voiceStateCounter or 0) + 1
		v114 = false
		voiceState = p28.voiceState
	end

	return {
		hasMessage = v111 or nil,
		savedChatSettings = p28.lastMessage and p28.chatSettings,
		shortId = v110,
		voiceStateCounter = v113,
		voiceTimedOut = v114,
		lastVoiceState = voiceState
	}
end

local function mapStateToProps(p30, p31) -- line: 719
	-- upvalues: getSettingsForMessage (copy)
	local v117 = p30.userMessages[p31.userId]
	local v118 = v117 and (#v117 >= 1 and v117[#v117])
	local v119 = v118 and p30.messages[v118]
	local v120 = p30.voiceState[p31.userId]

	return {
		chatSettings = getSettingsForMessage(p30.chatSettings, v119),
		messageIds = v117,
		lastMessage = v119,
		voiceState = v120
	}
end

return RoactRodux.connect(mapStateToProps)(v36)
