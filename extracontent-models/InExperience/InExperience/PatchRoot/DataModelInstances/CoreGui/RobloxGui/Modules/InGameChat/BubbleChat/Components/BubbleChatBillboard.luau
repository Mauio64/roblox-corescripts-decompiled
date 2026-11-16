local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local StarterGui = game:GetService("StarterGui")
local VRService = game:GetService("VRService")

local Logger = require(script.Parent.Parent.Logger)
local logger = Logger(script.Name)

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
local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local Enabled = Chrome.Enabled
local Constants2 = require(RobloxGui.Modules.VoiceChat.Constants)

local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default
local GetFFlagMicConnectingToast = require(RobloxGui.Modules.Flags.GetFFlagMicConnectingToast)
local GetFFlagBubbleChatInexistantAdorneeFix = require(RobloxGui.Modules.Flags.GetFFlagBubbleChatInexistantAdorneeFix)
local publicApi = require(RobloxGui.Modules.SelfView.publicApi)

local defineFastInt = game:DefineFastInt("BubbleVoiceTimeoutMillis", 1000)

local defineFastFlag = game:DefineFastFlag("DebugAllowControlButtonsNoVoiceChat", false)

local IxpServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper)
local IXPServiceWrapper = IxpServiceWrapper.IXPServiceWrapper
local defineFastFlag2 = game:DefineFastFlag("EasierUnmuting3", false)
local defineFastFlag3 = game:DefineFastFlag("EasierUnmutingBasedOnCamera", false)
local defineFastFlag4 = game:DefineFastFlag("EasierUnmutingHideIfMuted", false)
local defineFastInt2 = game:DefineFastInt("EasierUnmutingDisplayDistance", 20)
local defineFastString = game:DefineFastString("EasierUnmutingIXPLayerName", "Voice.UserAgency")
local defineFastString2 = game:DefineFastString("EasierUnmutingIXPLayerValue", "VoiceUserAgencyEnabled")

local extended = Roact.PureComponent:extend("BubbleChatBillboard")

local v = { dampingRatio = 1, frequency = 4 }

extended.validateProps = t.strictInterface({
	userId = t.string,
	onFadeOut = t.optional(t.callback),
	voiceEnabled = t.optional(t.boolean),
	bubbleChatEnabled = t.optional(t.boolean),
	chatSettings = Types.IChatSettings,
	messageIds = t.optional(t.array(t.string)),
	lastMessage = t.optional(Types.IMessage),
	voiceState = t.optional(t.string)
})

function getEasierUnmutingDistance(p)
	if not p then
		return nil
	end

	local humanoidRootPart = Players.LocalPlayer
		and Players.LocalPlayer.Character
		and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

	local position = humanoidRootPart and humanoidRootPart.CFrame and humanoidRootPart.CFrame.Position

	local position2 = workspace.CurrentCamera and workspace.CurrentCamera.CFrame.Position

	if defineFastFlag3 or not position then
		if position2 then
			return (p - position2).Magnitude
		end

		return nil
	end

	return (p - position).Magnitude
end

function extended:init()
	local selfViewIsOpenAndVisible = publicApi.getSelfViewIsOpenAndVisible()
	local coreGuiEnabled = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.SelfView)

	self:setState({
		adornee = nil,
		isInsideRenderDistance = false,
		isInsideMaximizeDistance = false,
		savedChatSettings = self.props.chatSettings,
		voiceTimedOut = false,
		voiceStateCounter = 0,
		lastVoiceState = nil,
		selfViewOpen = selfViewIsOpenAndVisible,
		selfViewEnabled = coreGuiEnabled,
		isInsideEasierUnmutingDistance = not defineFastFlag2 and nil,
		isMuted = not (defineFastFlag2 and defineFastFlag4) and nil,
		isInEasierUnmutingTreatment = not defineFastFlag2 and nil,
		haveLoggedUserExposure = not defineFastFlag2 and nil
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

	function self.onSelfViewVisibilityUpdated()
		self:setState({
			selfViewOpen = publicApi.getSelfViewIsOpenAndVisible()
		})
	end

	function self.onLastBubbleFadeOut()
		if self.props.onFadeOut and not self.isFadingOut then
			self.isFadingOut = true
			self.props.onFadeOut(self.props.userId)
		end

		if self.state.hasMessage and self.isMounted then
			self:setState({ hasMessage = false })
		end
	end

	if self.props.voiceEnabled then
		local onClicked

		if self.props.userId == tostring(Players.LocalPlayer.UserId) then
			onClicked = function()
				if self.props.voiceState == Constants.VOICE_STATE.ERROR then
					default:RejoinPreviousChannel()
				elseif GetFFlagMicConnectingToast() and self.props.voiceState == Constants.VOICE_STATE.CONNECTING then
					default:ShowVoiceChatLoadingMessage()
				else
					default:ToggleMic("LegacyBubbleChat")
				end
			end
		else
			onClicked = function()
				local userId = tonumber(self.props.userId)
				local v2

				if self:isShowingDueToEasierUnmuting() then
					v2 = Constants2.VOICE_CONTEXT_TYPE.EASIER_UNMUTING
				else
					v2 = Constants2.VOICE_CONTEXT_TYPE.BUBBLE_CHAT
				end

				default:ToggleMutePlayer(userId, v2)
			end
		end

		local userId = self.props.userId

		local iconStyle = userId == tostring(Players.LocalPlayer.UserId) and "MicDark" or "SpeakerDark"

		function self.renderInsert()
			return Roact.createElement(VoiceIndicator, {
				onClicked = onClicked,
				userId = userId,
				iconStyle = iconStyle
			})
		end

		self.insertSize = Vector2.new(28, 28)
	end

	function self.onCoreGuiChanged()
		local coreGuiEnabled2 = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.SelfView)

		if self.state.selfViewOpen ~= coreGuiEnabled2 then
			self:setState({ selfViewOpen = coreGuiEnabled2 })
		end
	end

	self.selfViewVisibilityUpdatedSignal = selfViewVisibilityUpdatedSignal:connect(function()
		self:setState({
			selfViewOpen = publicApi.getSelfViewIsOpenAndVisible()
		})
	end)

	if defineFastFlag2 then
		local success, result = pcall(function()
			return IXPServiceWrapper:GetLayerData(defineFastString)
		end)

		if success and result and result[defineFastString2] then
			self:setState({ isInEasierUnmutingTreatment = true })
		end
	end

	if defineFastFlag2 and self.state.isInEasierUnmutingTreatment and defineFastFlag4 then
		self.participantsUpdateConnection = default.participantsUpdate.Event:Connect(function(p)
			local v2 = p[self.props.userId]

			if not v2 then
				return
			end

			if v2.isMuted ~= self.state.isMuted then
				self:setState({ isMuted = v2.isMuted })
			end
		end)
	end
end

function extended:isShowingDueToEasierUnmuting()
	local v2 = defineFastFlag2 and self.state.isInEasierUnmutingTreatment

	if not v2 then
		return v2
	end

	if self.props.voiceState == Constants.VOICE_STATE.LOCAL_MUTED then
		v2 = self.state.isInsideEasierUnmutingDistance

		if v2 then
			local isMuted = defineFastFlag4 and self.state.isMuted
			return not isMuted
		end
	else
		return false
	end

	return v2
end

function extended:checkCounterForTimeout(p)
	if
		self.props.userId ~= tostring(Players.LocalPlayer.UserId)
		and self.state.lastVoiceState ~= Constants.VOICE_STATE.TALKING
		and self.state.voiceStateCounter ~= p
	then
		local voiceStateCounter = self.state.voiceStateCounter
		delay(defineFastInt / 1000, function()
			if self.state.voiceStateCounter == voiceStateCounter and self.isMounted then
				self:setState({ voiceTimedOut = true })
			end
		end)
	end
end

function extended:checkCounterForTimeoutWithEasierUnmuting(p)
	local voiceStateCounter

	if p then
		voiceStateCounter = p.voiceStateCounter
	end

	if not (defineFastFlag2 and self.state.isInEasierUnmutingTreatment) then
		return self:checkCounterForTimeout(voiceStateCounter)
	end

	local v2 = self.props.userId ~= tostring(Players.LocalPlayer.UserId)
	local v3 = self.state.voiceStateCounter ~= voiceStateCounter
	local v4

	if self.state.lastVoiceState == Constants.VOICE_STATE.TALKING then
		v4 = false
	else
		v4 = self.state.lastVoiceState ~= Constants.VOICE_STATE.LOCAL_MUTED
	end

	if v2 and v3 and v4 then
		local voiceStateCounter2 = self.state.voiceStateCounter

		delay(defineFastInt / 1000, function()
			if self.state.voiceStateCounter == voiceStateCounter2 and self.isMounted then
				self:setState({ voiceTimedOut = true })
			end
		end)
	end
end

function extended:didMount()
	self.isMounted = true
	local adornee = self.props.lastMessage and self.props.lastMessage.adornee
	self:setState({ adornee = adornee })

	local verticalOffset = self:getVerticalOffset(adornee)
	self.offsetGoal = verticalOffset
	self.offsetMotor:setGoal(Otter.instant(verticalOffset))

	local v2 = nil

	if adornee then
		v2 = Players:GetPlayerFromCharacter(adornee)
	elseif tonumber(self.props.userId) then
		v2 = Players:GetPlayerByUserId(self.props.userId)
	end

	if v2 then
		if v2.Character then
			coroutine.wrap(function()
				self:onCharacterAdded(v2, v2.Character)
			end)()
		end

		self.characterConn = v2.CharacterAdded:Connect(function(character)
			self:onCharacterAdded(v2, character)
		end)
	end

	self.heartbeatConn = RunService.Heartbeat:Connect(function()
		local attachment = self:getAdorneeInstance(self.state.adornee)

		if workspace.CurrentCamera and attachment then
			local worldPosition = attachment:IsA("Attachment") and attachment.WorldPosition or attachment.Position
			local magnitude = (workspace.CurrentCamera.CFrame.Position - worldPosition).Magnitude
			local isInsideRenderDistance = magnitude < self.state.savedChatSettings.MaxDistance
			local isInsideMaximizeDistance = magnitude < self.state.savedChatSettings.MinimizeDistance
			local isInsideEasierUnmutingDistance = false

			if defineFastFlag2 and self.state.isInEasierUnmutingTreatment then
				local easierUnmutingDistance = getEasierUnmutingDistance(worldPosition)

				if easierUnmutingDistance ~= nil then
					isInsideEasierUnmutingDistance = easierUnmutingDistance < defineFastInt2
				end
			end

			if
				isInsideMaximizeDistance ~= self.state.isInsideMaximizeDistance
				or isInsideRenderDistance ~= self.state.isInsideRenderDistance
				or defineFastFlag2
				and self.state.isInEasierUnmutingTreatment
				and isInsideEasierUnmutingDistance ~= self.state.isInsideEasierUnmutingDistance
			then
				self:setState({
					isInsideRenderDistance = isInsideRenderDistance,
					isInsideMaximizeDistance = isInsideMaximizeDistance,
					isInsideEasierUnmutingDistance = isInsideEasierUnmutingDistance
				})
			end
		end

		local verticalOffset2 = self:getVerticalOffset(self.state.adornee)

		if math.abs(verticalOffset2 - self.offsetGoal) > Constants.BILLBOARD_OFFSET_EPSILON then
			self.offsetGoal = verticalOffset2
			self.offsetMotor:setGoal(Otter.spring(verticalOffset2, v))
		end
	end)

	if defineFastFlag2 and self.state.isInEasierUnmutingTreatment then
		self:checkCounterForTimeoutWithEasierUnmuting(nil)
	else
		self:checkCounterForTimeout(nil)
	end
end

function extended:willUnmount()
	logger:trace("Unmounting billboards for {}", self.state.shortId)
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

	self.offsetMotor:destroy()

	if self.selfViewVisibilityUpdatedSignal then
		self.selfViewVisibilityUpdatedSignal:disconnect()
		self.selfViewVisibilityUpdatedSignal = nil
	end

	if
		defineFastFlag2
		and self.state.isInEasierUnmutingTreatment
		and defineFastFlag4
		and self.participantsUpdateConnection
	then
		self.participantsUpdateConnection:Disconnect()
		self.participantsUpdateConnection = nil
	end
end

local function waitForFirst(...)
	local bindableEvent = Instance.new("BindableEvent")
	local connections = { ... }

	local function fire(...)
		for i = 1, #connections do
			connections[i]:Disconnect()
		end

		return bindableEvent:Fire(...)
	end

	for i = 1, #connections do
		connections[i] = connections[i]:Connect(fire)
	end

	return bindableEvent.Event:Wait()
end

local function findFirstChildByNameAndClass(instance, p, className)
	for _, child in ipairs(instance:GetChildren()) do
		if child.Name == p and child:IsA(className) then
			return child
		end
	end
end

function extended:onCharacterAdded(player, instance)
	if not instance.Parent then
		waitForFirst(instance.AncestryChanged, player.CharacterAdded)
	end

	if player.Character ~= instance or not instance.Parent then
		logger:debug("Mismatched or unparented character in onCharacterAdded for {}", self.state.shortId)
		return
	end

	local humanoid = instance:FindFirstChildOfClass("Humanoid")

	while instance:IsDescendantOf(game) and not humanoid do
		waitForFirst(instance.ChildAdded, instance.AncestryChanged, player.CharacterAdded)
		humanoid = instance:FindFirstChildOfClass("Humanoid")
	end

	if player.Character ~= instance or not instance:IsDescendantOf(game) then
		logger:debug("Mismatched or unparented character in onCharacterAdded for {}", self.state.shortId)
		return
	end

	local v2

	if GetFFlagBubbleChatInexistantAdorneeFix() then
		v2 = instance.PrimaryPart
	else
		v2 = instance:FindFirstChild("HumanoidRootPart")
	end

	while instance:IsDescendantOf(game) and not v2 do
		waitForFirst(instance.ChildAdded, instance.AncestryChanged, player.CharacterAdded)

		if GetFFlagBubbleChatInexistantAdorneeFix() then
			v2 = instance.PrimaryPart
		else
			v2 = instance:FindFirstChild("HumanoidRootPart")
		end
	end

	if v2 and instance:IsDescendantOf(game) and player.Character == instance and self.isMounted then
		local firstChildByNameAndClass = findFirstChildByNameAndClass(instance, "Head", "BasePart")
		self:setState({
			adornee = humanoid.Health == 0 and firstChildByNameAndClass or instance
		})

		if self.humanoidDiedConn then
			self.humanoidDiedConn:Disconnect()
			self.humanoidDiedConn = nil
		end

		self.humanoidDiedConn = humanoid.Died:Connect(function()
			self:setState({
				adornee = findFirstChildByNameAndClass(instance, "Head", "BasePart") or instance
			})
		end)
	end
end

function extended:getVerticalOffset(instance)
	if instance and instance:IsA("Model") then
		local boundingBox, v2 = instance:GetBoundingBox()
		local part = self:getAdorneeInstance(instance)

		if not part then
			return v2.Y / 2
		end

		if not part:IsA("BasePart") then
			return 0
		end

		local pointToObjectSpace = boundingBox:PointToObjectSpace(part.Position)
		return v2.Y / 2 - pointToObjectSpace.Y
	elseif instance and instance:IsA("BasePart") then
		return instance.Size.Y / 2
	else
		return 0
	end
end

function extended:getAdorneeInstance(instance)
	if not instance then
		return
	end

	if instance:IsA("Model") then
		local instance2 = instance:FindFirstChild(self.state.savedChatSettings.AdorneeName, true)

		if GetFFlagBubbleChatInexistantAdorneeFix() then
			instance2 = instance2 or instance.PrimaryPart
		end

		if not instance2 or instance2:IsA("BasePart") or instance2:IsA("Attachment") then
			return instance2
		end
	elseif instance:IsA("BasePart") or instance:IsA("Attachment") then
		return instance
	end
end

function extended:getRenderVoiceAndCameraBubble()
	if not (self.props.voiceEnabled or defineFastFlag) then
		return false
	end

	if self.props.userId ~= tostring(Players.LocalPlayer.UserId) then
		return self.props.voiceEnabled and not self.state.voiceTimedOut
	end

	return not (VRService.VREnabled or Enabled()) and not self.state.selfViewOpen
end

function extended:shouldRenderCarat()
	return self.props.chatSettings.TailVisible and not self:getRenderVoiceAndCameraBubble()
end

function extended:render()
	local adorneeInstance = self:getAdorneeInstance(self.state.adornee)
	local v2 = self.props.userId == tostring(Players.LocalPlayer.UserId)
	local savedChatSettings = self.state.savedChatSettings

	if not adorneeInstance then
		logger:trace("No adornee for {}", self.state.shortId)
		return
	end

	if not self.state.isInsideRenderDistance then
		logger:trace("Not in range for {}", self.state.shortId)
		return
	end

	if
		defineFastFlag2
		and self.state.isInEasierUnmutingTreatment
		and self.props.voiceState == Constants.VOICE_STATE.LOCAL_MUTED
		and (not self.state.isInsideEasierUnmutingDistance or defineFastFlag4 and self.state.isMuted)
	then
		logger:trace("Unmute toggle not applicable for {}", self.state.shortId)
		return
	end

	local children = {}

	local active = self.props.voiceEnabled and not self.state.voiceTimedOut

	if (VRService.VREnabled or Enabled()) and v2 then
		active = false
	end

	if active and (not self.props.bubbleChatEnabled or not self.props.messageIds or #self.props.messageIds == 0) then
		children.VoiceBubble = Roact.createElement(VoiceBubble, {
			chatSettings = savedChatSettings,
			renderInsert = self.renderInsert,
			insertSize = self.insertSize,
			isDistant = not self.state.isInsideMaximizeDistance
		})
	end

	if self.state.hasMessage then
		if self.state.isInsideMaximizeDistance then
			local createElement = Roact.createElement
			local v3 = {
				userId = self.props.userId,
				isVisible = self.state.isInsideMaximizeDistance,
				onLastBubbleFadeOut = self.onLastBubbleFadeOut,
				chatSettings = savedChatSettings,
				renderFirstInsert = 0,
				insertSize = 0,
				showCarat = 0
			}
			local renderFirstInsert

			if active then
				renderFirstInsert = self.renderInsert
			end

			v3.renderFirstInsert = renderFirstInsert

			v3.insertSize = self.insertSize
			v3.showCarat = self:shouldRenderCarat()
			children.BubbleChatList = createElement(BubbleChatList, v3)
		else
			children.DistantBubble = Roact.createElement(ChatBubbleDistant, {
				fadingOut = not self.props.messageIds or #self.props.messageIds == 0,
				onFadeOut = self.onLastBubbleFadeOut,
				chatSettings = savedChatSettings,
				renderInsert = active and self.renderInsert,
				insertSize = self.insertSize
			})
		end
	end

	local localPlayerStudsOffset = v2 and savedChatSettings.LocalPlayerStudsOffset or Vector3.new(0, 1, 0.1)
	return Roact.createElement("BillboardGui", {
		Adornee = adorneeInstance,
		Active = active,
		Size = UDim2.fromOffset(500, 200),
		SizeOffset = Vector2.new(0, 0.5),
		StudsOffset = localPlayerStudsOffset + Vector3.new(0, savedChatSettings.VerticalStudsOffset, 0),
		StudsOffsetWorldSpace = self.offset,
		ResetOnSpawn = false
	}, children)
end

function extended:didUpdate(_, p)
	if (not self.props.messageIds or #self.props.messageIds == 0) and not self.state.isInsideRenderDistance then
		self.onLastBubbleFadeOut()
	end

	if self.props.messageIds and #self.props.messageIds > 0 then
		self.isFadingOut = false
	end

	if defineFastFlag2 and self.state.isInEasierUnmutingTreatment then
		self:checkCounterForTimeoutWithEasierUnmuting(p)
	else
		self:checkCounterForTimeout(p.voiceStateCounter)
	end

	local v2 = self.props.userId == tostring(Players.LocalPlayer.UserId)

	if
		defineFastFlag2
		and v2
		and not self.state.haveLoggedUserExposure
		and (self.props.voiceState == Constants.VOICE_STATE.INACTIVE or self.props.voiceState == Constants.VOICE_STATE.TALKING or self.props.voiceState == Constants.VOICE_STATE.MUTED)
	then
		IXPServiceWrapper:LogUserLayerExposure(defineFastString)
		self:setState({ haveLoggedUserExposure = true })
	end
end

function extended.getDerivedStateFromProps(data, data2)
	local shortId = "..." .. string.sub(tostring(data.userId), -4)

	local v2 = not data2.hasMessage and data.messageIds and #data.messageIds > 0
	local voiceStateCounter, voiceTimedOut, voiceState

	if data2.lastVoiceState ~= data.voiceState then
		voiceStateCounter = (data2.voiceStateCounter or 0) + 1

		voiceState = data.voiceState
		voiceTimedOut = false
	end

	return {
		hasMessage = v2 or nil,
		savedChatSettings = data.lastMessage and data.chatSettings,
		shortId = shortId,
		voiceStateCounter = voiceStateCounter,
		voiceTimedOut = voiceTimedOut,
		lastVoiceState = voiceState
	}
end

local function mapStateToProps(data, p)
	local userMessage = data.userMessages[p.userId]
	local v2

	if userMessage then
		if #userMessage >= 1 then
			v2 = userMessage[#userMessage]
		else
			v2 = false
		end
	else
		v2 = userMessage
	end

	local lastMessage = v2 and data.messages[v2]
	local voiceState = data.voiceState[p.userId]
	return {
		chatSettings = getSettingsForMessage(data.chatSettings, lastMessage),
		messageIds = userMessage,
		lastMessage = lastMessage,
		voiceState = voiceState
	}
end

return RoactRodux.connect(mapStateToProps)(extended)
