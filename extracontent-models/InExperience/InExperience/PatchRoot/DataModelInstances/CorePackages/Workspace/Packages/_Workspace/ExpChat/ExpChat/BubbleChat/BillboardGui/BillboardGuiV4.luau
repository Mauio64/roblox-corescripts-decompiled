local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local Roact = require(ExpChatParent.Roact)
local React = require(ExpChatParent.React)
local RoactRodux = require(ExpChatParent.RoactRodux)
local List = require(ExpChatParent.llama).List
local Otter = require(ExpChatParent.Otter)
local tutils = require(ExpChatParent.tutils)
local SharedFlags = require(ExpChatParent.SharedFlags)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local VRService = game:GetService("VRService")
local createEffect = require(ExpChatParent.Signals).createEffect
local v16 = ExpChatShared.Logger:new("ExpChat/" .. script.Name)
local BubbleChat = script:FindFirstAncestor("BubbleChat")
local VoiceIndicator = require(BubbleChat.VoiceIndicator)
local BlankBubble = require(BubbleChat.BlankBubble)
local BubbleChatList = require(BubbleChat.BubbleChatList)
local ChatBubbleDistant = require(BubbleChat.ChatBubbleDistant)
local GlobalFlags = require(ExpChat.GlobalFlags)
local Helpers = BubbleChat.Helpers
local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)
local GetChatConfigurationStore = require(ExpChat.Stores.GetChatConfigurationStore)
local getSettingsForMessage = require(Helpers.getSettingsForMessage)
local v27 = game:DefineFastFlag("SelfViewNoApi", false)
local PlayerButtons = require(BubbleChat.PlayerButtons)
local FFlagEasierUnmuting = require(ExpChat.Flags.FFlagEasierUnmuting)
local v30 = game:DefineFastFlag("ExpChatMemoBillboardGui", false)
local v31 = game:DefineFastFlag("StopBubbleChatReactWarning", false)
local v32 = game:DefineFastInt("ExperienceChatHeartbeatIncrement", 5)
local FFlagExpChatUseAdorneeStore = SharedFlags.FFlagExpChatUseAdorneeStore
local FFlagExpChatUseProximityStore = SharedFlags.FFlagExpChatUseProximityStore
local v35 = game:DefineFastInt("ExpChatProximityStoreExtraRendersBeforeUnmount", 10)
local FFlagExpChatUseMessagesStore = SharedFlags.FFlagExpChatUseMessagesStore
local FFlagExpChatUseChatConfigStore = SharedFlags.FFlagExpChatUseChatConfigStore
local vector2 = Vector2.new(28, 28)

local function getRecentMessages(p1, p2, p3) -- line: 53
	-- upvalues: List (copy)
	local v50 = workspace:GetServerTimeNow() * 1000
	local v51 = p1 or {}

	return List.filter(v51, function(p4, p5) -- line: 57
		-- upvalues: p1 (copy), p3 (copy), v50 (copy), p2 (copy)
		if p4.isVisibleInBubbleChat then
			return p5 > #p1 - p3 and v50 - p4.timestamp.UnixTimestampMillis < p2
		end

		return false
	end)
end

local v40 = ((if not v31 then Roact.PureComponent else Roact.Component)):extend("BubbleChatBillboard")
local t1 = {
	dampingRatio = 1,
	frequency = 4
}
local CurrentCamera = workspace.CurrentCamera

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line: 78
	-- upvalues: CurrentCamera (ref)
	CurrentCamera = workspace.CurrentCamera
end)

function v40.init(p6) -- line: 82
	-- upvalues: GlobalFlags (copy), v27 (copy), StarterGui (copy), FFlagExpChatUseProximityStore (copy), ExpChatShared (copy), Roact (copy), FFlagExpChatUseMessagesStore (copy), Otter (copy), Players (copy), VoiceIndicator (copy), GetMessagesStore (copy), FFlagExpChatUseChatConfigStore (copy), GetChatConfigurationStore (copy)
	local v53 = nil
	local v54 = nil

	if GlobalFlags.AvatarChatEnabled then
		v53 = p6.props.selfViewListenerChanged.getSelfViewVisibility()
		v54 = v27 or (StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.All) or StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.SelfView))
	end

	if FFlagExpChatUseProximityStore then
		local context = ExpChatShared.context

		p6.ProximityStore = context and context.proximityStore

		local v56, v57 = Roact.createBinding(100)

		p6.invisibleCount = v56
		p6.setInvisibleCount = v57

		local v58, v59 = Roact.createBinding(false)

		p6.renderDistanceBinding = v58
		p6.updateRenderDistanceBinding = v59

		local v60, v61 = Roact.createBinding(false)

		p6.maximizeDistanceBinding = v60
		p6.updateMaximizeDistanceBinding = v61
	end

	p6:setState({
		isInsideRenderDistance = false,
		isInsideMaximizeDistance = false,
		voiceTimedOut = false,
		voiceStateCounter = 0,
		lastVoiceState = nil,
		savedChatSettings = p6.props.chatSettings,
		selfViewOpen = v53,
		selfViewEnabled = v54,
		filteredMessages = if not FFlagExpChatUseMessagesStore then nil else {}
	})
	p6.isMounted = false

	local v62, v63 = Roact.createBinding((Vector3.new()))

	p6.offset = v62
	p6.updateOffset = v63
	p6.offsetMotor = Otter.createSingleMotor(0)
	p6.offsetMotor:onStep(function(p7) -- line: 117
		-- upvalues: p6 (copy)
		p6.updateOffset((Vector3.new(0, p7, 0)))
	end)
	p6.offsetGoal = 0

	local v64, v65 = Roact.createBinding(nil)

	p6.adorneeBinding = v64
	p6.updateAdorneeBinding = v65

	local v66, v67 = Roact.createBinding(nil)

	p6.localAdorneeBinding = v66
	p6.updateLocalAdorneeBinding = v67

	if FFlagExpChatUseProximityStore then
		local v68, v69 = Roact.createBinding(false)

		p6.voiceTimedOutBinding = v68
		p6.setVoiceTimedOutBinding = v69
	end

	p6.heartbeatCount = 0
	p6.lastDistanceUpdate = 0

	function p6.onLastBubbleFadeOut() -- line: 133
		-- upvalues: p6 (copy)
		if p6.props.onFadeOut and not p6.isFadingOut then
			p6.isFadingOut = true
			p6.props.onFadeOut(p6.props.userId)
		end
	end
	function p6.wrappedOnClickVoiceIndicator(p8, p9) -- line: 141
		-- upvalues: p6 (copy)
		return p6.props.onClickedVoiceIndicator(p8, p9, "bubblechat")
	end

	local LocalPlayer = Players.LocalPlayer
	local v71 = not LocalPlayer and "SpeakerDark" or (p6.props.userId == tostring(LocalPlayer.UserId) and "MicDark" or "SpeakerDark")

	function p6.renderInsert() -- line: 149
		-- upvalues: Roact (copy), VoiceIndicator (copy), p6 (copy), v71 (copy)
		return Roact.createElement(VoiceIndicator, {
			userId = p6.props.userId,
			getIcon = p6.props.getIconVoiceIndicator,
			onClicked = p6.wrappedOnClickVoiceIndicator,
			iconStyle = v71
		})
	end

	if GlobalFlags.AvatarChatEnabled then
		local selfViewVisibilityUpdatedSignal = p6.props.selfViewListenerChanged.selfViewVisibilityUpdatedSignal
		local getSelfViewVisibility = p6.props.selfViewListenerChanged.getSelfViewVisibility

		local function callback() -- line: 162
			-- upvalues: p6 (copy), getSelfViewVisibility (copy)
			p6:setState({
				selfViewOpen = getSelfViewVisibility()
			})
		end

		p6.selfViewConnection = selfViewVisibilityUpdatedSignal:connect(callback)
	end

	if FFlagExpChatUseMessagesStore then
		p6.MessagesStore = GetMessagesStore(false)
	end

	if FFlagExpChatUseChatConfigStore then
		p6.ChatConfigurationStore = GetChatConfigurationStore(false)
	end
end
function v40.checkCounterForTimeout(p10, p11) -- line: 179
	-- upvalues: Players (copy), FFlagExpChatUseProximityStore (copy)
	if Players.LocalPlayer and (p10.props.userId ~= tostring(Players.LocalPlayer.UserId) and p10.state.lastVoiceState ~= "Talking" and p11 ~= p10.state.voiceStateCounter) then
		local voiceStateCounter = p10.state.voiceStateCounter

		delay(1, function() -- line: 189
			-- upvalues: p10 (copy), voiceStateCounter (copy), FFlagExpChatUseProximityStore (copy)
			if p10.state.voiceStateCounter == voiceStateCounter and p10.isMounted then
				if FFlagExpChatUseProximityStore then
					p10.setVoiceTimedOutBinding(true)

					return
				end

				p10:setState({
					voiceTimedOut = true
				})
			end
		end)
	end
end
function v40.getVerticalOffset(p12) -- line: 204
	local v79 = p12:getEffectiveAdornee(false)

	if v79 and v79:IsA("Model") then
		local v80, v81 = v79:GetBoundingBox()
		local v82 = getAdorneeInstance(v79, p12.state.savedChatSettings.AdorneeName)

		if not v82 then
			return v81.Y / 2
		end

		if v82:IsA("BasePart") then
			local v83 = v80:PointToObjectSpace(v82.Position)

			return v81.Y / 2 - v83.Y
		end

		return 0
	end

	if v79 and v79:IsA("BasePart") then
		return v79.Size.Y / 2
	end

	return 0
end
function getAdorneeInstance(p13, s1: string) -- line: 228
	if not p13 then
		return nil
	end

	if p13:IsA("Model") then
		local v86 = p13:FindFirstChild(s1, true) or p13.PrimaryPart

		if not v86 or v86:IsA("BasePart") or v86:IsA("Attachment") then
			return v86
		end
	elseif p13:IsA("BasePart") or p13:IsA("Attachment") then
		return p13
	end

	return nil
end
function v40.getEffectiveAdornee(t2: {[any]: any}, b1: boolean?) -- line: 244
	-- upvalues: FFlagExpChatUseAdorneeStore (copy), ExpChatShared (copy)
	if not FFlagExpChatUseAdorneeStore then
		return t2.props.adornee
	end

	local context = ExpChatShared.context
	local v90 = context and context.adorneeStore

	if v90 and t2.props.userId then
		local v91 = v90.getAdornee(t2.props.userId)

		if v91 then
			local v92 = v91(b1 or false)

			if v92 then
				return v92
			end
		end
	end

	return t2.props.partOrModel
end
function v40.shouldRenderCaret(p14) -- line: 265
	-- upvalues: FFlagExpChatUseChatConfigStore (copy)
	return ((if not FFlagExpChatUseChatConfigStore then p14.state.savedChatSettings else p14.ChatConfigurationStore.getBubbleChatSettings(false))).TailVisible and not p14:shouldRenderPlayerButtons()
end
function v40.shouldRenderCaretNew(p15, p16) -- line: 273
	return p15.state.savedChatSettings.TailVisible and not p15:shouldRenderPlayerButtonsNew(p16)
end
function v40.shouldRenderPlayerButtons(p17) -- line: 279
	-- upvalues: Players (copy), FFlagExpChatUseProximityStore (copy), VRService (copy), GlobalFlags (copy)
	if not p17.props.voiceEnabled or not p17.props.isVoiceUIVisible then
		return false
	end

	local v97 = not not Players.LocalPlayer and p17.props.userId == tostring(Players.LocalPlayer.UserId)

	if FFlagExpChatUseProximityStore then
		if v97 and not p17.props.testMode then
			if VRService.VREnabled or GlobalFlags.ChromeEnabled then
				return false
			end

			if not p17.state.selfViewOpen then
				return true
			end

			return false
		end
	elseif v97 then
		if VRService.VREnabled or GlobalFlags.ChromeEnabled then
			return false
		end

		if not p17.state.selfViewOpen then
			return true
		end

		return false
	end

	return p17.props.voiceEnabled and not p17.state.voiceTimedOut
end
function v40.shouldRenderPlayerButtonsNew(p18, p19) -- line: 323
	-- upvalues: Players (copy), VRService (copy), GlobalFlags (copy)
	if not p18.props.voiceEnabled or not p18.props.isVoiceUIVisible then
		return false
	end

	if Players.LocalPlayer and p18.props.userId == tostring(Players.LocalPlayer.UserId) then
		if VRService.VREnabled or GlobalFlags.ChromeEnabled then
			return false
		end

		if not p18.state.selfViewOpen then
			return true
		end

		return false
	end

	if p19 == nil then
		return p18.props.voiceEnabled and not p18.state.voiceTimedOut
	end

	return p18.props.voiceEnabled and not p19
end

local function messagesHaveChanged(p20, p21) -- line: 354
	-- upvalues: FFlagExpChatUseMessagesStore (copy)
	local v102 = #p20
	local v103 = #p21

	if v102 == 0 and v103 == 0 then
		return false
	end

	if v102 ~= v103 then
		return true
	end

	for v104, v105 in p20 do
		if v105.messageId ~= p21[v104].messageId then
			return true
		end

		if FFlagExpChatUseMessagesStore and v105.text ~= p21[v104].text then
			return true
		end
	end

	return false
end

local t3 = {
	filteredMessages = true
}

function v40.shouldComponentUpdate(p22, p23, p24) -- line: 375
	-- upvalues: FFlagExpChatUseProximityStore (copy), messagesHaveChanged (copy), tutils (copy), t3 (copy)
	if not FFlagExpChatUseProximityStore and (p22.state.isInsideRenderDistance ~= p24.isInsideRenderDistance and not p24.isInsideRenderDistance) then
		return false
	end

	if messagesHaveChanged(p22.state.filteredMessages, p24.filteredMessages) then
		return true
	end

	return not tutils.shallowEqual(p23, p22.props, t3) or not tutils.shallowEqual(p24, p22.state, t3)
end
function v40.render(p25) -- line: 394
	-- upvalues: FFlagExpChatUseChatConfigStore (copy), FFlagExpChatUseAdorneeStore (copy), Players (copy), v16 (copy), FFlagExpChatUseProximityStore (copy), v35 (copy), Roact (copy), GlobalFlags (copy), vector2 (copy), PlayerButtons (copy), BlankBubble (copy), BubbleChatList (copy), ChatBubbleDistant (copy)
	local v110 = if not FFlagExpChatUseChatConfigStore then p25.state.savedChatSettings else p25.ChatConfigurationStore.getBubbleChatSettings(false)
	local v111 = if not FFlagExpChatUseAdorneeStore then p25.props.adornee or p25.props.partOrModel else p25.adorneeBinding
	local v112 = if not FFlagExpChatUseAdorneeStore then getAdorneeInstance(v111, p25.state.savedChatSettings.AdorneeName) else p25.adorneeBinding:map(function(p26) -- line: 404
		-- upvalues: p25 (copy)
		return getAdorneeInstance(p26, p25.state.savedChatSettings.AdorneeName)
	end)
	local v113 = not not Players.LocalPlayer and p25.props.userId == tostring(Players.LocalPlayer.UserId)

	if not FFlagExpChatUseAdorneeStore and not v112 then
		v16:trace("No adornee for {}", p25.state.shortId)

		return
	end

	if FFlagExpChatUseProximityStore then
		if p25.renderDistanceBinding:getValue() or p25.props.testMode then
			p25.setInvisibleCount(0)
		else
			if p25.invisibleCount:getValue() > v35 then
				return
			end

			p25.setInvisibleCount(p25.invisibleCount:getValue() + 1)
		end
	elseif not p25.state.isInsideRenderDistance then
		return
	end

	local v114 = nil

	if FFlagExpChatUseProximityStore then
		v114 = Roact.joinBindings({
			renderDistance = p25.renderDistanceBinding,
			maximizeDistance = p25.maximizeDistanceBinding
		}):map(function(p27) -- line: 450
			return {
				isInsideMaximizeDistance = p27.maximizeDistance,
				isDistant = not p27.maximizeDistance
			}
		end)
	end

	local t4 = {}
	local v116 = p25.state.filteredMessages and #p25.state.filteredMessages > 0
	local v117 = p25.props.voiceEnabled and not p25.state.voiceTimedOut

	if GlobalFlags.AvatarChatEnabled and v113 then
		v117 = v117 and not p25.state.selfViewOpen
	end

	if GlobalFlags.ChromeEnabled and v113 then
		v117 = false
	end

	local v118 = v117 and (not GlobalFlags.AvatarChatEnabled and not GlobalFlags.ChromeEnabled)
	local v119 = if not v117 then nil else p25.renderInsert
	local v120 = vector2
	local v121 = nil

	if FFlagExpChatUseProximityStore then
		v121 = p25.voiceTimedOutBinding:map(function(p28) -- line: 481
			-- upvalues: p25 (copy), GlobalFlags (copy), v113 (copy)
			local v159 = p25.props.voiceEnabled and not p28

			if GlobalFlags.AvatarChatEnabled and v113 then
				v159 = v159 and not p25.state.selfViewOpen
			end

			if GlobalFlags.ChromeEnabled and v113 then
				v159 = false
			end

			return v159
		end)
	end

	local clientSettings = p25.props.clientSettings

	if FFlagExpChatUseProximityStore then
		if p25.props.testMode or GlobalFlags.AvatarChatEnabled or GlobalFlags.ChromeEnabled then
			local t5 = {
				LayoutOrder = 2,
				Visible = if not FFlagExpChatUseProximityStore or p25.props.testMode then p25:shouldRenderPlayerButtons() else p25.voiceTimedOutBinding:map(function(p29) -- line: 499
					-- upvalues: p25 (copy)
					return p25:shouldRenderPlayerButtonsNew(p29)
				end),
				chatSettings = p25.props.chatSettings,
				isInsideMaximizeDistance = v114:map(function(p30) -- line: 504
					return p30.isInsideMaximizeDistance
				end),
				isLocalPlayer = v113,
				userId = p25.props.userId,
				getIcon = p25.props.getIconVoiceIndicator,
				hasCameraPermissions = p25.props.hasCameraPermissions,
				hasMicPermissions = p25.props.hasMicPermissions,
				onClickedVoiceIndicator = p25.wrappedOnClickVoiceIndicator,
				onClickedCameraIndicator = p25.props.onClickedCameraIndicator,
				voiceEnabled = p25.props.voiceEnabled,
				displayCameraDeniedToast = p25.props.displayCameraDeniedToast,
				isCamEnabledForUserAndPlace = p25.props.isCamEnabledForUserAndPlace,
				setCameraPermissionStateFromControl = p25.props.setCameraPermissionStateFromControl,
				getPermissions = p25.props.getPermissions,
				isCameraOnlyUser = p25.props.isCameraOnlyUser,
				isVoiceServiceInitialized = p25.props.isVoiceServiceInitialized
			}

			t4.PlayerButtons = Roact.createElement(PlayerButtons, t5)
			t4.listLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				Padding = UDim.new(0, 8)
			})
			t4.padding = Roact.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 8)
			})
		elseif v117 and v116 == false then
			t4.VoiceBubble = Roact.createElement(BlankBubble, {
				chatSettings = v110,
				userId = p25.props.userId,
				renderInsert = v119,
				insertSize = v120,
				isDistant = not p25.state.isInsideMaximizeDistance,
				clientSettings = clientSettings
			})
		end
	elseif GlobalFlags.AvatarChatEnabled or GlobalFlags.ChromeEnabled then
		if p25:shouldRenderPlayerButtons() then
			local t6 = {
				LayoutOrder = 2,
				chatSettings = p25.props.chatSettings,
				isInsideMaximizeDistance = p25.state.isInsideMaximizeDistance,
				isLocalPlayer = v113,
				userId = p25.props.userId,
				getIcon = p25.props.getIconVoiceIndicator,
				hasCameraPermissions = p25.props.hasCameraPermissions,
				hasMicPermissions = p25.props.hasMicPermissions,
				onClickedVoiceIndicator = p25.wrappedOnClickVoiceIndicator,
				onClickedCameraIndicator = p25.props.onClickedCameraIndicator,
				voiceEnabled = p25.props.voiceEnabled,
				displayCameraDeniedToast = p25.props.displayCameraDeniedToast,
				isCamEnabledForUserAndPlace = p25.props.isCamEnabledForUserAndPlace,
				setCameraPermissionStateFromControl = p25.props.setCameraPermissionStateFromControl,
				getPermissions = p25.props.getPermissions,
				isCameraOnlyUser = p25.props.isCameraOnlyUser,
				isVoiceServiceInitialized = p25.props.isVoiceServiceInitialized
			}

			t4.PlayerButtons = Roact.createElement(PlayerButtons, t6)
			t4.listLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				Padding = UDim.new(0, 8)
			})
			t4.padding = Roact.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 8)
			})
		end
	elseif v117 and v116 == false then
		t4.VoiceBubble = Roact.createElement(BlankBubble, {
			chatSettings = v110,
			userId = p25.props.userId,
			renderInsert = v119,
			insertSize = v120,
			isDistant = not p25.state.isInsideMaximizeDistance,
			clientSettings = clientSettings
		})
	end

	local v125 = p25:shouldRenderCaret()

	if FFlagExpChatUseProximityStore then
		t4.BubbleChatListContainer = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Visible = v114:map(function(p31) -- line: 607
				return p31.isInsideMaximizeDistance
			end)
		}, {
			BubbleChatList = Roact.createElement(BubbleChatList, {
				userId = p25.props.userId,
				isVisible = v114:map(function(p32) -- line: 613
					return p32.isInsideMaximizeDistance
				end),
				onLastBubbleFadeOut = p25.onLastBubbleFadeOut,
				chatSettings = v110,
				renderFirstInsert = if not v118 then nil else v119,
				insertSize = v120,
				messages = p25.state.filteredMessages,
				clientSettings = clientSettings,
				isTextChatServiceOn = p25.props.isTextChatServiceOn,
				showCaret = p25.voiceTimedOutBinding:map(function(p33) -- line: 623
					-- upvalues: p25 (copy)
					return p25:shouldRenderCaretNew(p33)
				end)
			})
		})

		if v116 then
			t4.DistantBubbleContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Visible = v114:map(function(p34) -- line: 633
					return not p34.isInsideMaximizeDistance
				end)
			}, {
				DistantBubble = Roact.createElement(ChatBubbleDistant, {
					fadingOut = not p25.state.filteredMessages or #p25.state.filteredMessages == 0,
					onFadeOut = p25.onLastBubbleFadeOut,
					chatSettings = v110,
					renderInsert = if not v118 then nil else v119,
					insertSize = v120,
					clientSettings = clientSettings,
					showCaret = p25.voiceTimedOutBinding:map(function(p35) -- line: 644
						-- upvalues: p25 (copy)
						return p25:shouldRenderCaretNew(p35)
					end)
				})
			})
		end
	elseif p25.state.isInsideMaximizeDistance then
		t4.BubbleChatList = Roact.createElement(BubbleChatList, {
			userId = p25.props.userId,
			isVisible = p25.state.isInsideMaximizeDistance,
			onLastBubbleFadeOut = p25.onLastBubbleFadeOut,
			chatSettings = v110,
			renderFirstInsert = if not v118 then nil else v119,
			insertSize = v120,
			messages = p25.state.filteredMessages,
			clientSettings = clientSettings,
			isTextChatServiceOn = p25.props.isTextChatServiceOn,
			showCaret = v125
		})
	elseif v116 then
		t4.DistantBubble = Roact.createElement(ChatBubbleDistant, {
			fadingOut = not p25.state.filteredMessages or #p25.state.filteredMessages == 0,
			onFadeOut = p25.onLastBubbleFadeOut,
			chatSettings = v110,
			renderInsert = if not v118 then nil else v119,
			insertSize = v120,
			clientSettings = clientSettings,
			showCaret = v125
		})
	end

	local v126 = v113 and v110.LocalPlayerStudsOffset or Vector3.new(0, 1, 0.10000000149011612)

	if FFlagExpChatUseProximityStore then
		return Roact.createElement("BillboardGui", {
			ResetOnSpawn = false,
			Adornee = v112,
			Active = if not GlobalFlags.AvatarChatEnabled then v121:map(function(p36) -- line: 690
				return p36
			end) else p25.voiceTimedOutBinding:map(function(p37) -- line: 687
				-- upvalues: p25 (copy)
				return p25:shouldRenderPlayerButtonsNew(p37)
			end),
			Size = UDim2.fromOffset(500, 200),
			SizeOffset = Vector2.new(0, 0.5),
			StudsOffset = v126 + Vector3.new(0, v110.VerticalStudsOffset, 0),
			StudsOffsetWorldSpace = p25.offset,
			MaxDistance = p25.renderDistanceBinding:map(function(p38) -- line: 698
				if p38 then
					return 1e999
				end

				return 0
			end)
		}, t4)
	end

	return Roact.createElement("BillboardGui", {
		ResetOnSpawn = false,
		Adornee = v112,
		Active = if not GlobalFlags.AvatarChatEnabled then v117 else p25:shouldRenderPlayerButtons(),
		Size = UDim2.fromOffset(500, 200),
		SizeOffset = Vector2.new(0, 0.5),
		StudsOffset = v126 + Vector3.new(0, v110.VerticalStudsOffset, 0),
		StudsOffsetWorldSpace = p25.offset
	}, t4)
end
function v40.didUpdate(p39, _, p41) -- line: 715
	-- upvalues: FFlagExpChatUseProximityStore (copy)
	if FFlagExpChatUseProximityStore then
		if (not p39.state.filteredMessages or #p39.state.filteredMessages == 0) and not p39.renderDistanceBinding:getValue() then
			p39.onLastBubbleFadeOut()
		end
	elseif (not p39.state.filteredMessages or #p39.state.filteredMessages == 0) and not p39.state.isInsideRenderDistance then
		p39.onLastBubbleFadeOut()
	end

	if p39.state.filteredMessages and #p39.state.filteredMessages > 0 then
		p39.isFadingOut = false
	end

	if FFlagExpChatUseProximityStore and p39.state.voiceStateCounter ~= p41.voiceStateCounter then
		p39.setVoiceTimedOutBinding(false)
	end

	p39:checkCounterForTimeout(p41.voiceStateCounter)
end
function v40.didMount(p42) -- line: 746
	-- upvalues: FFlagExpChatUseMessagesStore (copy), createEffect (copy), FFlagExpChatUseChatConfigStore (copy), GetChatConfigurationStore (copy), getRecentMessages (copy), Otter (copy), FFlagExpChatUseAdorneeStore (copy), ExpChatShared (copy), Players (copy), FFlagEasierUnmuting (copy), FFlagExpChatUseProximityStore (copy), RunService (copy), v32 (copy), CurrentCamera (ref), t1 (copy)
	p42.isMounted = true

	if FFlagExpChatUseMessagesStore and p42.MessagesStore then
		p42.messagesEffect = createEffect(function(p43) -- line: 752
			-- upvalues: p42 (copy), FFlagExpChatUseChatConfigStore (copy), GetChatConfigurationStore (copy), getRecentMessages (copy)
			local v171 = p42.props.userId or (not p42.props.partOrModel or p42.MessagesStore.getPartOrModelToMockUserId(p43)[p42.props.partOrModel])

			if v171 then
				local v172 = p42.MessagesStore.getUserBubbleMessages(v171)(p43)
				local v173 = if not FFlagExpChatUseChatConfigStore then p42.props.chatSettings else GetChatConfigurationStore(false).getBubbleChatSettings(p43)
				local MaxBubbles = v173.MaxBubbles
				local v175 = v173.BubbleDuration * 1000
				local v176 = getRecentMessages(v172, v175, MaxBubbles)

				p42:setState({
					filteredMessages = v176
				})

				return
			end

			p42:setState({
				filteredMessages = {}
			})
		end)
	end

	if FFlagExpChatUseChatConfigStore then
		p42.chatConfigEffect = createEffect(function(p44) -- line: 785
			-- upvalues: GetChatConfigurationStore (copy), p42 (copy)
			local v178 = GetChatConfigurationStore(false).getBubbleChatSettings(p44)

			p42:setState({
				savedChatSettings = v178
			})
		end)
	end

	local v131 = p42:getVerticalOffset()

	p42.offsetGoal = v131
	p42.offsetMotor:setGoal(Otter.instant(v131))

	if FFlagExpChatUseAdorneeStore then
		local context = ExpChatShared.context
		local v133 = context and context.adorneeStore
		local v134 = not Players.LocalPlayer and -1 or Players.LocalPlayer.UserId

		if v133 and p42.props.userId and createEffect then
			p42.adorneeEffect = createEffect(function(p45) -- line: 802
				-- upvalues: p42 (copy)
				local v180 = p42:getEffectiveAdornee(p45)

				p42.updateAdorneeBinding(v180)
			end)

			if FFlagEasierUnmuting then
				local v135 = v133.getAdornee(v134)

				if v135 then
					p42.localAdorneeEffect = createEffect(function(p46) -- line: 810
						-- upvalues: v135 (copy), p42 (copy)
						local v182 = v135(p46)

						p42.updateLocalAdorneeBinding(v182)
					end)
				end
			end
		end
	end

	if FFlagExpChatUseProximityStore and p42.ProximityStore and p42.props.userId then
		p42.proximityEffect = createEffect(function(p47) -- line: 822
			-- upvalues: p42 (copy)
			local v184 = p42.ProximityStore.getUserProximityState(p42.props.userId)(p47)

			p42.updateRenderDistanceBinding(v184.isInsideRenderDistance)
			p42.updateMaximizeDistanceBinding(v184.isInsideMaximizeDistance)
		end)
	end

	p42.heartbeatConn = RunService.Heartbeat:Connect(function(dt) -- line: 833
		-- upvalues: p42 (copy), v32 (copy), FFlagExpChatUseAdorneeStore (copy), CurrentCamera (ref), FFlagExpChatUseProximityStore (copy), Otter (copy), t1 (copy), FFlagExpChatUseMessagesStore (copy), getRecentMessages (copy)
		if p42.props.billboardUpdateFrequency > 0 then
			p42.lastDistanceUpdate = p42.lastDistanceUpdate + dt

			if p42.lastDistanceUpdate < p42.props.billboardUpdateFrequency then
				return
			end

			p42.lastDistanceUpdate = 0
		elseif not p42.props.tests_skipHeartbeatCheck then
			if p42.heartbeatCount < v32 then
				local v186 = p42

				v186.heartbeatCount = v186.heartbeatCount + 1

				return
			end

			p42.heartbeatCount = 0
		end

		local v187 = if not FFlagExpChatUseAdorneeStore then getAdorneeInstance(p42.props.adornee or p42.props.partOrModel, p42.state.savedChatSettings.AdorneeName) else getAdorneeInstance(p42.adorneeBinding:getValue(), p42.state.savedChatSettings.AdorneeName)

		if CurrentCamera and v187 then
			local v188 = if not v187:IsA("Attachment") then v187.Position else v187.WorldPosition
			local Magnitude = (CurrentCamera.CFrame.Position - v188).Magnitude
			local v190 = Magnitude < p42.state.savedChatSettings.MaxDistance
			local v191 = Magnitude < p42.state.savedChatSettings.MinimizeDistance

			if FFlagExpChatUseProximityStore and p42.ProximityStore then
				if not p42._lastProximityState or v190 ~= p42._lastProximityState.isInsideRenderDistance or v191 ~= p42._lastProximityState.isInsideMaximizeDistance then
					p42.ProximityStore.updateProximity(p42.props.userId, v190, v191)
					p42._lastProximityState = {
						isInsideRenderDistance = v190,
						isInsideMaximizeDistance = v191
					}
				end
			elseif v191 ~= p42.state.isInsideMaximizeDistance or v190 ~= p42.state.isInsideRenderDistance then
				p42:setState({
					isInsideRenderDistance = v190,
					isInsideMaximizeDistance = v191
				})
			end
		end

		local v192 = p42:getVerticalOffset()

		if math.abs(v192 - p42.offsetGoal) > 0.5 then
			p42.offsetGoal = v192
			p42.offsetMotor:setGoal(Otter.spring(v192, t1))
		end

		local v193 = workspace:GetServerTimeNow() * 1000
		local v194 = p42.state.savedChatSettings.BubbleDuration * 1000

		for _, v196 in p42.state.filteredMessages do
			if v194 <= v193 - v196.timestamp.UnixTimestampMillis then
				if FFlagExpChatUseMessagesStore then
					p42:setState(function(p48) -- line: 915
						-- upvalues: v193 (copy), v194 (copy)
						local t7 = {}

						for _, v in ipairs(p48.filteredMessages) do
							if v193 - v.timestamp.UnixTimestampMillis < v194 then
								table.insert(t7, v)
							end
						end

						return {
							filteredMessages = t7
						}
					end)

					return
				end

				p42:setState(function(p49) -- line: 927
					-- upvalues: getRecentMessages (copy), v194 (copy), p42 (copy)
					return {
						filteredMessages = getRecentMessages(p49.filteredMessages, v194, p42.props.chatSettings.MaxBubbles)
					}
				end)

				return
			end
		end
	end)
	p42:checkCounterForTimeout(nil)
end
function v40.willUnmount(p50) -- line: 946
	-- upvalues: v16 (copy), FFlagExpChatUseProximityStore (copy), FFlagExpChatUseMessagesStore (copy), FFlagExpChatUseChatConfigStore (copy)
	v16:trace("Unmounting billboards for {}", p50.state.shortId)
	p50.isMounted = false

	if p50.characterConn then
		p50.characterConn:Disconnect()
		p50.characterConn = nil
	end

	if p50.heartbeatConn then
		p50.heartbeatConn:Disconnect()
		p50.heartbeatConn = nil
	end

	if p50.humanoidDiedConn then
		p50.humanoidDiedConn:Disconnect()
		p50.humanoidDiedConn = nil
	end

	if p50.selfViewConnection then
		p50.selfViewConnection:disconnect()
		p50.selfViewConnection = nil
	end

	if p50.adorneeEffect then
		p50.adorneeEffect()
		p50.adorneeEffect = nil
	end

	if p50.localAdorneeEffect then
		p50.localAdorneeEffect()
		p50.localAdorneeEffect = nil
	end

	if FFlagExpChatUseProximityStore and p50.proximityEffect then
		p50.proximityEffect()
		p50.proximityEffect = nil
	end

	if FFlagExpChatUseMessagesStore and p50.messagesEffect then
		p50.messagesEffect()
		p50.messagesEffect = nil
	end

	if FFlagExpChatUseChatConfigStore and p50.chatConfigEffect then
		p50.chatConfigEffect()
		p50.chatConfigEffect = nil
	end

	p50.offsetMotor:destroy()
end
function v40.getDerivedStateFromProps(p51, p52) -- line: 996
	-- upvalues: FFlagExpChatUseMessagesStore (copy), getRecentMessages (copy)
	local v139 = "..." .. string.sub(tostring(p51.userId), -4)
	local voiceState = nil
	local v141 = nil
	local v142 = nil

	if p52.lastVoiceState ~= p51.voiceState then
		v141 = (p52.voiceStateCounter or 0) + 1
		v142 = false
		voiceState = p51.voiceState
	end

	local v143 = p52.savedChatSettings.BubbleDuration * 1000
	local v144 = if not FFlagExpChatUseMessagesStore then getRecentMessages(p51.messages, v143, p52.savedChatSettings.MaxBubbles) else p52.filteredMessages

	return {
		savedChatSettings = if not FFlagExpChatUseMessagesStore then p51.lastMessage and p51.chatSettings else p51.chatSettings,
		shortId = v139,
		filteredMessages = v144,
		voiceStateCounter = v141,
		voiceTimedOut = v142,
		lastVoiceState = voiceState
	}
end

local function mapStateToProps(p53, p54) -- line: 1037
	-- upvalues: Players (copy), FFlagExpChatUseChatConfigStore (copy), GetChatConfigurationStore (copy), getSettingsForMessage (copy), FFlagExpChatUseMessagesStore (copy), FFlagExpChatUseAdorneeStore (copy), FFlagEasierUnmuting (copy)
	local v147 = p53.Messages.messagesBySenderId[p54.userId]
	local v148 = if v147 == nil then nil else v147[#v147]
	local v149 = not Players.LocalPlayer and "" or tostring(Players.LocalPlayer.UserId)
	local v150 = if not p54.isTextChatServiceOn then getSettingsForMessage(p53.LegacyBubbleChatSettings, v148) else if not FFlagExpChatUseChatConfigStore then p53.BubbleChatSettings else GetChatConfigurationStore(false).getBubbleChatSettings(false)

	return {
		messages = if not FFlagExpChatUseMessagesStore then v147 else nil,
		lastMessage = if not FFlagExpChatUseMessagesStore then v148 else nil,
		chatSettings = v150,
		adornee = if not FFlagExpChatUseAdorneeStore then p53.Adornees[p54.userId] or p54.partOrModel else nil,
		localAdornee = if not FFlagExpChatUseAdorneeStore then if not FFlagEasierUnmuting then nil else p53.Adornees[v149] else nil,
		clientSettings = p53.ClientSettings,
		isVoiceUIVisible = p53.Voice.isVoiceUIVisible
	}
end

if FFlagExpChatUseAdorneeStore then
	local v46 = RoactRodux.connect(mapStateToProps)(v40)

	if v30 then
		return React.memo(v46)
	end

	return v46
end

if v30 then
	return React.memo(RoactRodux.connect(mapStateToProps)(v40))
end

return RoactRodux.connect(mapStateToProps)(v40)
