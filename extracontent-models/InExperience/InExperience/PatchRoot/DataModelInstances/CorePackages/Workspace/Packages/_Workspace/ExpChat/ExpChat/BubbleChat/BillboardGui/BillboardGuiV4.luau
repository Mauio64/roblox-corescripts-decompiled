local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local ExpChatShared = require(parent.ExpChatShared)
local Roact = require(parent.Roact)
local React = require(parent.React)
local RoactRodux = require(parent.RoactRodux)
local llama = require(parent.llama)
local list = llama.List
local Otter = require(parent.Otter)
local tutils = require(parent.tutils)
local SharedFlags = require(parent.SharedFlags)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local VRService = game:GetService("VRService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local Signals = require(parent.Signals)
local createEffect = Signals.createEffect
local v = ExpChatShared.Logger:new("ExpChat/" .. script.Name)

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
local getDisplayedBubbleMessages = require(Helpers.getDisplayedBubbleMessages)
local getBubbleChatStartTimeMillis = require(Helpers.getBubbleChatStartTimeMillis)
local getServerTimeNowMillis = require(Helpers.getServerTimeNowMillis)
local getBubbleDurationInMillis = require(Helpers.getBubbleDurationInMillis)
local getBorderlessBubbleChatRenderDistance = require(Helpers.getBorderlessBubbleChatRenderDistance)
local isBorderlessBubbleChatMessage = require(Helpers.isBorderlessBubbleChatMessage)

local defineFastFlag = game:DefineFastFlag("SelfViewNoApi", false)

local PlayerButtons = require(BubbleChat.PlayerButtons)

local FFlagEasierUnmuting = require(ExpChat.Flags.FFlagEasierUnmuting)
local defineFastFlag2 = game:DefineFastFlag("ExpChatMemoBillboardGui", false)
local defineFastFlag3 = game:DefineFastFlag("StopBubbleChatReactWarning", false)

local defineFastInt = game:DefineFastInt("ExperienceChatHeartbeatIncrement", 5)
local FFlagExpChatUseAdorneeStore = SharedFlags.FFlagExpChatUseAdorneeStore

local FFlagExpChatUseProximityStore = SharedFlags.FFlagExpChatUseProximityStore

local defineFastInt2 = game:DefineFastInt("ExpChatProximityStoreExtraRendersBeforeUnmount", 10)
local FFlagExpChatUseChatConfigStore = SharedFlags.FFlagExpChatUseChatConfigStore
local isBorderlessBubbleChatEnabled = require(ExpChat.isBorderlessBubbleChatEnabled)

local vector2 = Vector2.new(28, 28)

local function getRecentMessages(options, p, maxBubbles)
	local v2 = workspace:GetServerTimeNow() * 1000
	return list.filter(options or {}, function(p2, p3): boolean
		if not p2.isVisibleInBubbleChat then
			return false
		end

		return #options - maxBubbles < p3 and v2 - p2.timestamp.UnixTimestampMillis < p
	end)
end

local v2

if defineFastFlag3 then
	v2 = Roact.Component
else
	v2 = Roact.PureComponent
end

local extended = v2:extend("BubbleChatBillboard")

local v3 = { dampingRatio = 1, frequency = 4 }

local CurrentCamera = workspace.CurrentCamera
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	CurrentCamera = workspace.CurrentCamera
end)

function extended:init()
	local selfViewOpen, selfViewEnabled

	if GlobalFlags.AvatarChatEnabled then
		selfViewOpen = self.props.selfViewListenerChanged.getSelfViewVisibility()

		selfViewEnabled = defineFastFlag
			or StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.All)
			or StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.SelfView)
	end

	if FFlagExpChatUseProximityStore then
		local context = ExpChatShared.context
		self.ProximityStore = context and context.proximityStore
		local binding, setInvisibleCount = Roact.createBinding(100)
		self.invisibleCount = binding
		self.setInvisibleCount = setInvisibleCount

		local binding2, updateRenderDistanceBinding = Roact.createBinding(false)
		self.renderDistanceBinding = binding2
		self.updateRenderDistanceBinding = updateRenderDistanceBinding
		local binding3, updateMaximizeDistanceBinding = Roact.createBinding(false)
		self.maximizeDistanceBinding = binding3
		self.updateMaximizeDistanceBinding = updateMaximizeDistanceBinding
	end

	self:setState({
		isInsideRenderDistance = false,
		isInsideMaximizeDistance = false,
		savedChatSettings = self.props.chatSettings,
		selfViewOpen = selfViewOpen,
		selfViewEnabled = selfViewEnabled,
		voiceTimedOut = false,
		voiceStateCounter = 0,
		lastVoiceState = nil,
		filteredMessages = {}
	})

	self.isMounted = false
	local binding, updateOffset = Roact.createBinding((Vector3.new()))
	self.offset = binding
	self.updateOffset = updateOffset
	self.offsetMotor = Otter.createSingleMotor(0)
	self.offsetMotor:onStep(function(p)
		self.updateOffset((Vector3.new(0, p, 0)))
	end)
	self.offsetGoal = 0

	if isBorderlessBubbleChatEnabled() then
		local binding2, updateBorderlessDistanceTransparency = Roact.createBinding(0)
		self.borderlessDistanceTransparency = binding2
		self.updateBorderlessDistanceTransparency = updateBorderlessDistanceTransparency

		local binding3, updateBorderlessBillboardMaxDistance = Roact.createBinding(getBorderlessBubbleChatRenderDistance(self.props.chatSettings))
		self.borderlessBillboardMaxDistance = binding3
		self.updateBorderlessBillboardMaxDistance = updateBorderlessBillboardMaxDistance

		self.isInsideBorderlessRenderDistance = nil
		self.borderlessDistanceFadeConnection = nil
	end

	local binding2, updateAdorneeBinding = Roact.createBinding(nil)
	self.adorneeBinding = binding2
	self.updateAdorneeBinding = updateAdorneeBinding
	local binding3, updateLocalAdorneeBinding = Roact.createBinding(nil)
	self.localAdorneeBinding = binding3
	self.updateLocalAdorneeBinding = updateLocalAdorneeBinding

	if FFlagExpChatUseProximityStore then
		local binding4, setVoiceTimedOutBinding = Roact.createBinding(false)
		self.voiceTimedOutBinding = binding4
		self.setVoiceTimedOutBinding = setVoiceTimedOutBinding
	end

	self.heartbeatCount = 0

	self.lastDistanceUpdate = 0

	function self.onLastBubbleFadeOut()
		if isBorderlessBubbleChatEnabled() and self.isMounted and self.state.isShowingBorderlessBubbleChat then
			self:setState({ isShowingBorderlessBubbleChat = false })
		end

		if self.props.onFadeOut and not self.isFadingOut then
			self.isFadingOut = true
			self.props.onFadeOut(self.props.userId)
		end
	end

	function self.wrappedOnClickVoiceIndicator(p, p2)
		return self.props.onClickedVoiceIndicator(p, p2, "bubblechat")
	end

	local localPlayer = Players.LocalPlayer

	local iconStyle = localPlayer and self.props.userId == tostring(localPlayer.UserId) and "MicDark" or "SpeakerDark"

	function self.renderInsert()
		return Roact.createElement(VoiceIndicator, {
			userId = self.props.userId,
			getIcon = self.props.getIconVoiceIndicator,
			onClicked = self.wrappedOnClickVoiceIndicator,
			iconStyle = iconStyle
		})
	end

	if GlobalFlags.AvatarChatEnabled then
		local selfViewVisibilityUpdatedSignal = self.props.selfViewListenerChanged.selfViewVisibilityUpdatedSignal
		local getSelfViewVisibility = self.props.selfViewListenerChanged.getSelfViewVisibility

		local function callback()
			self:setState({ selfViewOpen = getSelfViewVisibility() })
		end
		self.selfViewConnection = selfViewVisibilityUpdatedSignal:connect(callback)
	end

	self.MessagesStore = GetMessagesStore(false)

	if FFlagExpChatUseChatConfigStore then
		self.ChatConfigurationStore = GetChatConfigurationStore(false)
	end
end

function extended:checkCounterForTimeout(p)
	if
		Players.LocalPlayer
		and self.props.userId ~= tostring(Players.LocalPlayer.UserId)
		and self.state.lastVoiceState ~= "Talking"
		and self.state.voiceStateCounter ~= p
	then
		local voiceStateCounter = self.state.voiceStateCounter
		delay(1, function()
			if self.state.voiceStateCounter == voiceStateCounter and self.isMounted then
				if FFlagExpChatUseProximityStore then
					self.setVoiceTimedOutBinding(true)
				else
					self:setState({ voiceTimedOut = true })
				end
			end
		end)
	end
end

function extended:getVerticalOffset()
	local instance = self:getEffectiveAdornee(false)

	if instance and instance:IsA("Model") then
		local boundingBox, v4 = instance:GetBoundingBox()
		local adorneeInstance = getAdorneeInstance(instance, self.state.savedChatSettings.AdorneeName)

		if not adorneeInstance then
			return v4.Y / 2
		end

		if not adorneeInstance:IsA("BasePart") then
			return 0
		end

		local pointToObjectSpace = boundingBox:PointToObjectSpace(adorneeInstance.Position)
		return v4.Y / 2 - pointToObjectSpace.Y
	elseif instance and instance:IsA("BasePart") then
		return instance.Size.Y / 2
	else
		return 0
	end
end

function getAdorneeInstance(instance, childName: string)
	if not instance then
		return nil
	end

	if instance:IsA("Model") then
		local instance2 = instance:FindFirstChild(childName, true) or instance.PrimaryPart

		if not instance2 or instance2:IsA("BasePart") or instance2:IsA("Attachment") then
			return instance2
		end
	elseif instance:IsA("BasePart") or instance:IsA("Attachment") then
		return instance
	end

	return nil
end

function extended:getEffectiveAdornee(flag: boolean?)
	if not FFlagExpChatUseAdorneeStore then
		return self.props.adornee
	end

	local context = ExpChatShared.context
	local adorneeStore = context and context.adorneeStore

	if adorneeStore and self.props.userId then
		local adornee = adorneeStore.getAdornee(self.props.userId)

		local v4 = adornee and adornee(flag or false)

		if v4 then
			return v4
		end
	end

	return self.props.partOrModel
end

function extended:shouldRenderCaret()
	local v4

	if FFlagExpChatUseChatConfigStore then
		v4 = self.ChatConfigurationStore.getBubbleChatSettings(false)
	else
		v4 = self.state.savedChatSettings
	end

	return v4.TailVisible and not self:shouldRenderPlayerButtons()
end

function extended:shouldRenderCaretNew(p)
	return self.state.savedChatSettings.TailVisible and not self:shouldRenderPlayerButtonsNew(p)
end

function extended:shouldRenderPlayerButtons()
	if not (self.props.voiceEnabled and self.props.isVoiceUIVisible) then
		return false
	end

	local v4

	if Players.LocalPlayer then
		v4 = self.props.userId == tostring(Players.LocalPlayer.UserId)
	else
		v4 = false
	end

	if FFlagExpChatUseProximityStore then
		if v4 and not self.props.testMode then
			return not (VRService.VREnabled or GlobalFlags.ChromeEnabled) and not self.state.selfViewOpen
		end
	elseif v4 then
		return not (VRService.VREnabled or GlobalFlags.ChromeEnabled) and not self.state.selfViewOpen
	end

	return self.props.voiceEnabled and not self.state.voiceTimedOut
end

function extended:shouldRenderPlayerButtonsNew(p)
	if not (self.props.voiceEnabled and self.props.isVoiceUIVisible) then
		return false
	end

	local v4

	if Players.LocalPlayer then
		v4 = self.props.userId == tostring(Players.LocalPlayer.UserId)
	else
		v4 = false
	end

	if v4 then
		return not (VRService.VREnabled or GlobalFlags.ChromeEnabled) and not self.state.selfViewOpen
	elseif p == nil then
		return self.props.voiceEnabled and not self.state.voiceTimedOut
	else
		return self.props.voiceEnabled and not p
	end
end

local function messagesHaveChanged(filteredMessages, filteredMessages2): boolean
	local count = #filteredMessages
	local count2 = #filteredMessages2

	if count == 0 and count2 == 0 then
		return false
	end

	if count ~= count2 then
		return true
	end

	for k, item in filteredMessages do
		if not (item.messageId == filteredMessages2[k].messageId and item.text == filteredMessages2[k].text) then
			return true
		end
	end

	return false
end

local v4 = { filteredMessages = true }
function extended.shouldComponentUpdate(p, p2, p3): boolean
	if
		not FFlagExpChatUseProximityStore
		and p.state.isInsideRenderDistance ~= p3.isInsideRenderDistance
		and not p3.isInsideRenderDistance
	then
		return false
	end

	if messagesHaveChanged(p.state.filteredMessages, p3.filteredMessages) then
		return true
	end

	return not (tutils.shallowEqual(p2, p.props, v4) and tutils.shallowEqual(p3, p.state, v4))
end

function extended:cancelBorderlessDistanceFade()
	if self.borderlessDistanceFadeConnection then
		self.borderlessDistanceFadeConnection:Disconnect()
		self.borderlessDistanceFadeConnection = nil
	end
end

function extended:setBorderlessDistanceVisible(isInsideBorderlessRenderDistance: boolean)
	if self.isInsideBorderlessRenderDistance == isInsideBorderlessRenderDistance then
		return
	end

	self.isInsideBorderlessRenderDistance = isInsideBorderlessRenderDistance
	self:cancelBorderlessDistanceFade()
	local v5 = isInsideBorderlessRenderDistance and 0 or 1

	if self.borderlessBillboardMaxDistance:getValue() == 1e999 then
		local value = self.borderlessDistanceTransparency:getValue()

		if value == v5 then
			return
		end

		if self.state.isShowingBorderlessBubbleChat and not UserGameSettings.ReducedMotion then
			local total = 0
			self.borderlessDistanceFadeConnection = RunService.RenderStepped:Connect(function(dt)
				total += dt
				local v6 = math.min(total / 0.25, 1)
				self.updateBorderlessDistanceTransparency(value + (v5 - value) * v6)

				if v6 == 1 then
					self:cancelBorderlessDistanceFade()
				end
			end)
		else
			self.updateBorderlessDistanceTransparency(v5)
		end
	else
		self.updateBorderlessDistanceTransparency(v5)
		self.updateBorderlessBillboardMaxDistance(1e999)
	end
end

function extended:render()
	local chatSettings

	if FFlagExpChatUseChatConfigStore then
		chatSettings = self.ChatConfigurationStore.getBubbleChatSettings(false)
	else
		chatSettings = self.state.savedChatSettings
	end

	local v5

	if FFlagExpChatUseAdorneeStore then
		v5 = self.adorneeBinding
	else
		v5 = self.props.adornee or self.props.partOrModel
	end

	local adornee

	if FFlagExpChatUseAdorneeStore then
		adornee = self.adorneeBinding:map(function(p)
			return getAdorneeInstance(p, self.state.savedChatSettings.AdorneeName)
		end)
	else
		adornee = getAdorneeInstance(v5, self.state.savedChatSettings.AdorneeName)
	end

	local isLocalPlayer

	if Players.LocalPlayer then
		isLocalPlayer = self.props.userId == tostring(Players.LocalPlayer.UserId)
	else
		isLocalPlayer = false
	end

	if not (FFlagExpChatUseAdorneeStore or adornee) then
		v:trace("No adornee for {}", self.state.shortId)
		return
	end

	local v6 = isBorderlessBubbleChatEnabled() and self.state.isShowingBorderlessBubbleChat == true

	local v7 = v6 and self.borderlessDistanceTransparency:getValue() < 1

	if FFlagExpChatUseProximityStore then
		if self.renderDistanceBinding:getValue() or self.props.testMode or v7 then
			self.setInvisibleCount(0)
		elseif defineFastInt2 < self.invisibleCount:getValue() then
			return
		else
			self.setInvisibleCount(self.invisibleCount:getValue() + 1)
		end
	elseif not (self.state.isInsideRenderDistance or v7) then
		return
	end

	local v8

	if FFlagExpChatUseProximityStore then
		v8 = Roact.joinBindings({
			renderDistance = self.renderDistanceBinding,
			maximizeDistance = self.maximizeDistanceBinding
		}):map(function(p)
			return {
				isInsideMaximizeDistance = p.maximizeDistance,
				isDistant = not p.maximizeDistance
			}
		end)
	end

	local children = {}

	local v9 = self.state.filteredMessages and #self.state.filteredMessages > 0

	local active = self.props.voiceEnabled and not self.state.voiceTimedOut

	if GlobalFlags.AvatarChatEnabled and isLocalPlayer then
		active = active and not self.state.selfViewOpen
	end

	if GlobalFlags.ChromeEnabled and isLocalPlayer then
		active = false
	end

	local v10 = active and not (GlobalFlags.AvatarChatEnabled or GlobalFlags.ChromeEnabled)
	local renderInsert

	if active then
		renderInsert = self.renderInsert
	end

	local insertSize = vector2
	local v11

	if FFlagExpChatUseProximityStore then
		v11 = self.voiceTimedOutBinding:map(function(p)
			local v12 = self.props.voiceEnabled and not p

			if GlobalFlags.AvatarChatEnabled and isLocalPlayer then
				v12 = v12 and not self.state.selfViewOpen
			end

			return not (GlobalFlags.ChromeEnabled and isLocalPlayer) and v12
		end)
	end

	local clientSettings = self.props.clientSettings

	if FFlagExpChatUseProximityStore then
		if self.props.testMode or GlobalFlags.AvatarChatEnabled or GlobalFlags.ChromeEnabled then
			local visible

			if FFlagExpChatUseProximityStore and not self.props.testMode then
				visible = self.voiceTimedOutBinding:map(function(p)
					return self:shouldRenderPlayerButtonsNew(p)
				end)
			else
				visible = self:shouldRenderPlayerButtons()
			end

			local v12 = {
				Visible = visible,
				chatSettings = self.props.chatSettings,
				isInsideMaximizeDistance = v8:map(function(p)
					return p.isInsideMaximizeDistance
				end),
				LayoutOrder = 2,
				isLocalPlayer = isLocalPlayer,
				userId = self.props.userId,
				getIcon = self.props.getIconVoiceIndicator,
				hasCameraPermissions = self.props.hasCameraPermissions,
				hasMicPermissions = self.props.hasMicPermissions,
				onClickedVoiceIndicator = self.wrappedOnClickVoiceIndicator,
				onClickedCameraIndicator = self.props.onClickedCameraIndicator,
				voiceEnabled = self.props.voiceEnabled,
				displayCameraDeniedToast = self.props.displayCameraDeniedToast,
				isCamEnabledForUserAndPlace = self.props.isCamEnabledForUserAndPlace,
				setCameraPermissionStateFromControl = self.props.setCameraPermissionStateFromControl,
				getPermissions = self.props.getPermissions,
				isCameraOnlyUser = self.props.isCameraOnlyUser,
				isVoiceServiceInitialized = self.props.isVoiceServiceInitialized
			}

			children.PlayerButtons = Roact.createElement(PlayerButtons, v12)

			children.listLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				Padding = UDim.new(0, 8)
			})

			children.padding = Roact.createElement("UIPadding", { PaddingBottom = UDim.new(0, 8) })
		elseif active and v9 == false then
			children.VoiceBubble = Roact.createElement(BlankBubble, {
				chatSettings = chatSettings,
				userId = self.props.userId,
				renderInsert = renderInsert,
				insertSize = insertSize,
				isDistant = not self.state.isInsideMaximizeDistance,
				clientSettings = clientSettings
			})
		end
	elseif GlobalFlags.AvatarChatEnabled or GlobalFlags.ChromeEnabled then
		if self:shouldRenderPlayerButtons() then
			local v12 = {
				chatSettings = self.props.chatSettings,
				isInsideMaximizeDistance = self.state.isInsideMaximizeDistance,
				LayoutOrder = 2,
				isLocalPlayer = isLocalPlayer,
				userId = self.props.userId,
				getIcon = self.props.getIconVoiceIndicator,
				hasCameraPermissions = self.props.hasCameraPermissions,
				hasMicPermissions = self.props.hasMicPermissions,
				onClickedVoiceIndicator = self.wrappedOnClickVoiceIndicator,
				onClickedCameraIndicator = self.props.onClickedCameraIndicator,
				voiceEnabled = self.props.voiceEnabled,
				displayCameraDeniedToast = self.props.displayCameraDeniedToast,
				isCamEnabledForUserAndPlace = self.props.isCamEnabledForUserAndPlace,
				setCameraPermissionStateFromControl = self.props.setCameraPermissionStateFromControl,
				getPermissions = self.props.getPermissions,
				isCameraOnlyUser = self.props.isCameraOnlyUser,
				isVoiceServiceInitialized = self.props.isVoiceServiceInitialized
			}

			children.PlayerButtons = Roact.createElement(PlayerButtons, v12)

			children.listLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				Padding = UDim.new(0, 8)
			})

			children.padding = Roact.createElement("UIPadding", { PaddingBottom = UDim.new(0, 8) })
		end
	elseif active and v9 == false then
		children.VoiceBubble = Roact.createElement(BlankBubble, {
			chatSettings = chatSettings,
			userId = self.props.userId,
			renderInsert = renderInsert,
			insertSize = insertSize,
			isDistant = not self.state.isInsideMaximizeDistance,
			clientSettings = clientSettings
		})
	end

	if v6 then
		children.PlayerButtons = nil
	end

	local shouldRenderCaret = self:shouldRenderCaret()

	if FFlagExpChatUseProximityStore then
		local createElement = Roact.createElement
		local v12 = {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Visible = v8:map(function(p)
				return p.isInsideMaximizeDistance or v6
			end)
		}

		local createElement2 = Roact.createElement
		local v13 = {
			userId = self.props.userId,
			isVisible = v8:map(function(p)
				return p.isInsideMaximizeDistance or v6
			end),
			onLastBubbleFadeOut = self.onLastBubbleFadeOut,
			chatSettings = chatSettings,
			renderFirstInsert = 0,
			insertSize = 0,
			messages = 0,
			clientSettings = 0,
			isTextChatServiceOn = 0,
			showCaret = 0,
			isDistant = 0,
			borderlessDistanceTransparency = 0
		}
		local renderFirstInsert

		if v10 then
			renderFirstInsert = renderInsert
		end

		v13.renderFirstInsert = renderFirstInsert
		v13.insertSize = insertSize
		v13.messages = self.state.filteredMessages
		v13.clientSettings = clientSettings
		v13.isTextChatServiceOn = self.props.isTextChatServiceOn
		v13.showCaret = self.voiceTimedOutBinding:map(function(p)
			return self:shouldRenderCaretNew(p)
		end)
		local isDistant

		if isBorderlessBubbleChatEnabled() then
			isDistant = v8:map(function(p)
				return p.isDistant
			end)
		end

		v13.isDistant = isDistant
		local borderlessDistanceTransparency

		if isBorderlessBubbleChatEnabled() then
			borderlessDistanceTransparency = self.borderlessDistanceTransparency
		end

		v13.borderlessDistanceTransparency = borderlessDistanceTransparency
		children.BubbleChatListContainer = createElement("Frame", v12, {
			BubbleChatList = createElement2(BubbleChatList, v13)
		})

		if v9 and not v6 then
			local createElement3 = Roact.createElement
			local v14 = {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Visible = v8:map(function(p): boolean
					return not p.isInsideMaximizeDistance
				end)
			}

			local createElement4 = Roact.createElement
			local v15 = {
				fadingOut = not self.state.filteredMessages or #self.state.filteredMessages == 0,
				onFadeOut = self.onLastBubbleFadeOut,
				chatSettings = chatSettings,
				renderInsert = 0,
				insertSize = 0,
				clientSettings = 0,
				showCaret = 0
			}

			if not v10 then
				renderInsert = nil
			end

			v15.renderInsert = renderInsert
			v15.insertSize = insertSize
			v15.clientSettings = clientSettings
			v15.showCaret = self.voiceTimedOutBinding:map(function(p)
				return self:shouldRenderCaretNew(p)
			end)
			children.DistantBubbleContainer = createElement3("Frame", v14, {
				DistantBubble = createElement4(ChatBubbleDistant, v15)
			})
		end
	elseif self.state.isInsideMaximizeDistance or v6 then
		local createElement = Roact.createElement
		local v12 = {
			userId = self.props.userId,
			isVisible = self.state.isInsideMaximizeDistance or v6,
			onLastBubbleFadeOut = self.onLastBubbleFadeOut,
			chatSettings = chatSettings,
			renderFirstInsert = 0,
			insertSize = 0,
			messages = 0,
			clientSettings = 0,
			isTextChatServiceOn = 0,
			showCaret = 0,
			isDistant = 0,
			borderlessDistanceTransparency = 0
		}

		if not v10 then
			renderInsert = nil
		end

		v12.renderFirstInsert = renderInsert
		v12.insertSize = insertSize
		v12.messages = self.state.filteredMessages
		v12.clientSettings = clientSettings
		v12.isTextChatServiceOn = self.props.isTextChatServiceOn
		v12.showCaret = shouldRenderCaret
		local isDistant

		if isBorderlessBubbleChatEnabled() then
			isDistant = not self.state.isInsideMaximizeDistance
		end

		v12.isDistant = isDistant
		local borderlessDistanceTransparency

		if isBorderlessBubbleChatEnabled() then
			borderlessDistanceTransparency = self.borderlessDistanceTransparency
		end

		v12.borderlessDistanceTransparency = borderlessDistanceTransparency
		children.BubbleChatList = createElement(BubbleChatList, v12)
	elseif v9 then
		local createElement = Roact.createElement
		local v12 = {
			fadingOut = not self.state.filteredMessages or #self.state.filteredMessages == 0,
			onFadeOut = self.onLastBubbleFadeOut,
			chatSettings = chatSettings,
			renderInsert = 0,
			insertSize = 0,
			clientSettings = 0,
			showCaret = 0
		}

		if not v10 then
			renderInsert = nil
		end

		v12.renderInsert = renderInsert
		v12.insertSize = insertSize
		v12.clientSettings = clientSettings
		v12.showCaret = shouldRenderCaret
		children.DistantBubble = createElement(ChatBubbleDistant, v12)
	end

	local localPlayerStudsOffset = isLocalPlayer and chatSettings.LocalPlayerStudsOffset or Vector3.new(0, 1, 0.1)

	if FFlagExpChatUseProximityStore then
		local createElement = Roact.createElement
		local active2

		if GlobalFlags.AvatarChatEnabled then
			active2 = self.voiceTimedOutBinding:map(function(p)
				return self:shouldRenderPlayerButtonsNew(p)
			end)
		else
			active2 = v11:map(function(p)
				return p
			end)
		end

		local v12 = {
			Adornee = adornee,
			Active = active2,
			Size = UDim2.fromOffset(500, 200),
			SizeOffset = Vector2.new(0, 0.5),
			StudsOffset = localPlayerStudsOffset + Vector3.new(0, chatSettings.VerticalStudsOffset, 0),
			StudsOffsetWorldSpace = self.offset,
			ResetOnSpawn = false,
			MaxDistance = 0
		}
		local maxDistance

		if v6 then
			maxDistance = Roact.joinBindings({
				renderDistance = self.renderDistanceBinding,
				borderlessDistanceTransparency = self.borderlessDistanceTransparency,
				borderlessBillboardMaxDistance = self.borderlessBillboardMaxDistance
			}):map(function(data)
				if data.renderDistance or data.borderlessDistanceTransparency < 1 then
					return data.borderlessBillboardMaxDistance
				end

				return 0
			end)
		else
			maxDistance = self.renderDistanceBinding:map(function(p): number
				return if p then 1e999 else 0
			end)
		end

		v12.MaxDistance = maxDistance
		return createElement("BillboardGui", v12, children)
	else
		local createElement = Roact.createElement

		if GlobalFlags.AvatarChatEnabled then
			active = self:shouldRenderPlayerButtons()
		end

		local v12 = {
			Adornee = adornee,
			Active = active,
			Size = UDim2.fromOffset(500, 200),
			SizeOffset = Vector2.new(0, 0.5),
			StudsOffset = localPlayerStudsOffset + Vector3.new(0, chatSettings.VerticalStudsOffset, 0),
			StudsOffsetWorldSpace = self.offset,
			ResetOnSpawn = false,
			MaxDistance = 0
		}
		local maxDistance

		if v6 then
			maxDistance = self.borderlessBillboardMaxDistance
		end

		v12.MaxDistance = maxDistance
		return createElement("BillboardGui", v12, children)
	end
end

function extended:didUpdate(_, p)
	if FFlagExpChatUseProximityStore then
		if
			(not self.state.filteredMessages or #self.state.filteredMessages == 0)
			and not self.renderDistanceBinding:getValue()
		then
			self.onLastBubbleFadeOut()
		end
	elseif
		(not self.state.filteredMessages or #self.state.filteredMessages == 0)
		and not self.state.isInsideRenderDistance
	then
		self.onLastBubbleFadeOut()
	end

	if self.state.filteredMessages and #self.state.filteredMessages > 0 then
		self.isFadingOut = false
	end

	if FFlagExpChatUseProximityStore and self.state.voiceStateCounter ~= p.voiceStateCounter then
		self.setVoiceTimedOutBinding(false)
	end

	self:checkCounterForTimeout(p.voiceStateCounter)
end

function extended:didMount()
	self.isMounted = true

	if self.MessagesStore then
		self.messagesEffect = createEffect(function(p)
			local v5 = self.props.userId

			if not v5 and self.props.partOrModel then
				v5 = self.MessagesStore.getPartOrModelToMockUserId(p)[self.props.partOrModel]
			end

			if not v5 then
				self:setState({ filteredMessages = {} })

				return
			end

			local v6 = self.MessagesStore.getUserBubbleMessages(v5)(p)
			local v7

			if FFlagExpChatUseChatConfigStore then
				v7 = GetChatConfigurationStore(false).getBubbleChatSettings(p)
			else
				v7 = self.props.chatSettings
			end

			local maxBubbles = v7.MaxBubbles
			local v8 = v7.BubbleDuration * 1000
			local filteredMessages

			if isBorderlessBubbleChatEnabled() then
				filteredMessages = getDisplayedBubbleMessages(v6, v8, maxBubbles, getServerTimeNowMillis())
			else
				filteredMessages = getRecentMessages(v6, v8, maxBubbles)
			end

			self:setState({ filteredMessages = filteredMessages })
		end)
	end

	if FFlagExpChatUseChatConfigStore then
		self.chatConfigEffect = createEffect(function(p)
			self:setState({
				savedChatSettings = GetChatConfigurationStore(false).getBubbleChatSettings(p)
			})
		end)
	end

	local verticalOffset = self:getVerticalOffset()
	self.offsetGoal = verticalOffset
	self.offsetMotor:setGoal(Otter.instant(verticalOffset))

	if FFlagExpChatUseAdorneeStore then
		local context = ExpChatShared.context
		local adorneeStore = context and context.adorneeStore
		local v5 = not Players.LocalPlayer and -1 or Players.LocalPlayer.UserId

		if adorneeStore and self.props.userId and createEffect then
			self.adorneeEffect = createEffect(function(p)
				local effectiveAdornee = self:getEffectiveAdornee(p)
				self.updateAdorneeBinding(effectiveAdornee)
			end)

			local v6 = FFlagEasierUnmuting and adorneeStore.getAdornee(v5)

			if v6 then
				self.localAdorneeEffect = createEffect(function(p)
					local v7 = v6(p)
					self.updateLocalAdorneeBinding(v7)
				end)
			end
		end
	end

	if FFlagExpChatUseProximityStore and self.ProximityStore and self.props.userId then
		self.proximityEffect = createEffect(function(p)
			local v5 = self.ProximityStore.getUserProximityState(self.props.userId)(p)

			self.updateRenderDistanceBinding(v5.isInsideRenderDistance)
			self.updateMaximizeDistanceBinding(v5.isInsideMaximizeDistance)
		end)
	end

	self.heartbeatConn = RunService.Heartbeat:Connect(function(dt)
		if self.props.billboardUpdateFrequency > 0 then
			self.lastDistanceUpdate += dt

			if self.lastDistanceUpdate < self.props.billboardUpdateFrequency then
				return
			end

			self.lastDistanceUpdate = 0
		elseif not self.props.tests_skipHeartbeatCheck then
			if self.heartbeatCount < defineFastInt then
				self.heartbeatCount += 1
				return
			end

			self.heartbeatCount = 0
		end

		local attachment

		if FFlagExpChatUseAdorneeStore then
			attachment = getAdorneeInstance(self.adorneeBinding:getValue(), self.state.savedChatSettings.AdorneeName)
		else
			attachment = getAdorneeInstance(
				self.props.adornee or self.props.partOrModel,
				self.state.savedChatSettings.AdorneeName
			)
		end

		if CurrentCamera and attachment then
			local v5

			if attachment:IsA("Attachment") then
				v5 = attachment.WorldPosition
			else
				v5 = attachment.Position
			end

			local magnitude = (CurrentCamera.CFrame.Position - v5).Magnitude
			local isInsideRenderDistance = magnitude < self.state.savedChatSettings.MaxDistance
			local isInsideMaximizeDistance = magnitude < self.state.savedChatSettings.MinimizeDistance

			if FFlagExpChatUseProximityStore and self.ProximityStore then
				if
					not self._lastProximityState
					or self._lastProximityState.isInsideRenderDistance ~= isInsideRenderDistance
					or self._lastProximityState.isInsideMaximizeDistance ~= isInsideMaximizeDistance
				then
					self.ProximityStore.updateProximity(
						self.props.userId,
						isInsideRenderDistance,
						isInsideMaximizeDistance
					)

					self._lastProximityState = {
						isInsideRenderDistance = isInsideRenderDistance,
						isInsideMaximizeDistance = isInsideMaximizeDistance
					}
				end
			elseif
				isInsideMaximizeDistance ~= self.state.isInsideMaximizeDistance
				or isInsideRenderDistance ~= self.state.isInsideRenderDistance
			then
				self:setState({
					isInsideRenderDistance = isInsideRenderDistance,
					isInsideMaximizeDistance = isInsideMaximizeDistance
				})
			end

			if isBorderlessBubbleChatEnabled() then
				self:setBorderlessDistanceVisible(magnitude < getBorderlessBubbleChatRenderDistance(self.state.savedChatSettings))
			end
		end

		local verticalOffset2 = self:getVerticalOffset()

		if math.abs(verticalOffset2 - self.offsetGoal) > 0.5 then
			self.offsetGoal = verticalOffset2
			self.offsetMotor:setGoal(Otter.spring(verticalOffset2, v3))
		end

		local v5

		if isBorderlessBubbleChatEnabled() then
			v5 = getServerTimeNowMillis()
		else
			v5 = workspace:GetServerTimeNow() * 1000
		end

		local v6 = self.state.savedChatSettings.BubbleDuration * 1000

		for _, filteredMessage in self.state.filteredMessages do
			local v7

			if isBorderlessBubbleChatEnabled() then
				v7 = getBubbleDurationInMillis(filteredMessage, v6)
			else
				v7 = v6
			end

			local v8

			if isBorderlessBubbleChatEnabled() then
				v8 = getBubbleChatStartTimeMillis(filteredMessage)
			else
				v8 = filteredMessage.timestamp.UnixTimestampMillis
			end

			if v7 <= v5 - v8 then
				self:setState(function(p)
					local filteredMessages = {}

					for _, filteredMessage2 in ipairs(p.filteredMessages) do
						local v9

						if isBorderlessBubbleChatEnabled() then
							v9 = getBubbleDurationInMillis(filteredMessage2, v6)
						else
							v9 = v6
						end

						local v10

						if isBorderlessBubbleChatEnabled() then
							v10 = getBubbleChatStartTimeMillis(filteredMessage2)
						else
							v10 = filteredMessage2.timestamp.UnixTimestampMillis
						end

						if v5 - v10 < v9 then
							table.insert(filteredMessages, filteredMessage2)
						end
					end

					return { filteredMessages = filteredMessages }
				end)
				break
			end
		end
	end)

	self:checkCounterForTimeout(nil)
end

function extended:willUnmount()
	v:trace("Unmounting billboards for {}", self.state.shortId)
	self.isMounted = false

	if self.characterConn then
		self.characterConn:Disconnect()
		self.characterConn = nil
	end

	if self.heartbeatConn then
		self.heartbeatConn:Disconnect()
		self.heartbeatConn = nil
	end

	if self.humanoidDiedConn then
		self.humanoidDiedConn:Disconnect()
		self.humanoidDiedConn = nil
	end

	if self.selfViewConnection then
		self.selfViewConnection:disconnect()
		self.selfViewConnection = nil
	end

	if self.adorneeEffect then
		self.adorneeEffect()
		self.adorneeEffect = nil
	end

	if self.localAdorneeEffect then
		self.localAdorneeEffect()
		self.localAdorneeEffect = nil
	end

	if FFlagExpChatUseProximityStore and self.proximityEffect then
		self.proximityEffect()
		self.proximityEffect = nil
	end

	if self.messagesEffect then
		self.messagesEffect()
		self.messagesEffect = nil
	end

	if FFlagExpChatUseChatConfigStore and self.chatConfigEffect then
		self.chatConfigEffect()
		self.chatConfigEffect = nil
	end

	if isBorderlessBubbleChatEnabled() then
		self:cancelBorderlessDistanceFade()
	end

	self.offsetMotor:destroy()
end

function extended.getDerivedStateFromProps(data, data2)
	local shortId = "..." .. string.sub(tostring(data.userId), -4)
	local voiceStateCounter, voiceTimedOut, voiceState

	if data2.lastVoiceState ~= data.voiceState then
		voiceStateCounter = (data2.voiceStateCounter or 0) + 1

		voiceState = data.voiceState
		voiceTimedOut = false
	end

	local filteredMessages = data2.filteredMessages
	local isShowingBorderlessBubbleChat

	if isBorderlessBubbleChatEnabled() then
		local filteredMessage = filteredMessages[#filteredMessages]

		if filteredMessage then
			isShowingBorderlessBubbleChat = isBorderlessBubbleChatMessage(filteredMessage)
		else
			isShowingBorderlessBubbleChat = data2.isShowingBorderlessBubbleChat == true
		end
	end

	return {
		savedChatSettings = data.chatSettings,
		shortId = shortId,
		filteredMessages = filteredMessages,
		voiceStateCounter = voiceStateCounter,
		voiceTimedOut = voiceTimedOut,
		lastVoiceState = voiceState,
		isShowingBorderlessBubbleChat = isShowingBorderlessBubbleChat
	}
end

local function mapStateToProps(data, data2)
	local message = data.Messages.messagesBySenderId[data2.userId]
	local v5

	if message ~= nil then
		v5 = message[#message]
	end

	local v6 = not Players.LocalPlayer and "" or tostring(Players.LocalPlayer.UserId)
	local chatSettings

	if data2.isTextChatServiceOn then
		if FFlagExpChatUseChatConfigStore then
			chatSettings = GetChatConfigurationStore(false).getBubbleChatSettings(false)
		else
			chatSettings = data.BubbleChatSettings
		end
	else
		chatSettings = getSettingsForMessage(data.LegacyBubbleChatSettings, v5)
	end

	local adornee

	if not FFlagExpChatUseAdorneeStore then
		adornee = data.Adornees[data2.userId] or data2.partOrModel
	end

	local localAdornee

	if not (FFlagExpChatUseAdorneeStore or not FFlagEasierUnmuting) then
		localAdornee = data.Adornees[v6]
	end

	return {
		chatSettings = chatSettings,
		adornee = adornee,
		localAdornee = localAdornee,
		clientSettings = data.ClientSettings,
		isVoiceUIVisible = data.Voice.isVoiceUIVisible
	}
end

if FFlagExpChatUseAdorneeStore then
	local v5 = RoactRodux.connect(mapStateToProps)(extended)

	if defineFastFlag2 then
		return React.memo(v5)
	end

	return v5
elseif defineFastFlag2 then
	return React.memo(RoactRodux.connect(mapStateToProps)(extended))
else
	return RoactRodux.connect(mapStateToProps)(extended)
end
