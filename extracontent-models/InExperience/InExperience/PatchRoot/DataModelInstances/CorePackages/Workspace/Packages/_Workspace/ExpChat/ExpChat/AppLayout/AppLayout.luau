local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local Chrome = require(parent.Chrome)
local FocusUtils = Chrome.FocusUtils
local Otter = require(parent.Otter)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local Roact = require(parent.Roact)
local Signals = require(parent.Signals)
local SocialUpsell = require(parent.SocialUpsell)
local createEffect = Signals.createEffect
local SharedFlags = require(parent.SharedFlags)
local ExpChatShared = require(parent.ExpChatShared)
local UIBlox = require(parent.UIBlox)
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local SelectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local CursorProvider = UIBlox.App.SelectionCursor.CursorProvider
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider

local Foundation = require(parent.Foundation)
local ChatInput = require(ExpChat.ChatInput)
local ChatWindow = require(ExpChat.ChatWindow)
local ChannelBar = require(ExpChat.ChannelBar)
local Config = require(ExpChat.Config)
local EnableChatButton = require(ExpChat.EnableChatButton)
local FriendsChatMain = require(parent.FriendsChat.FriendsChatMain)
local ChatPlatformProvider = require(ExpChat.ChatPlatform.ChatPlatformProvider)
local FriendsChatDependencyBridge = require(ExpChat.FriendsChatDependencyBridge)
local GetFriendsChatRealtimeStore = require(parent.FriendsChat.GetFriendsChatRealtimeStore)
local PresetChatTray = require(ExpChat.PresetChat.PresetChatTray)
local PresetChatButton = require(ExpChat.PresetChat.PresetChatButton)
local PresetChatFlyOut = require(ExpChat.PresetChat.PresetChatFlyOut)
local PresetChatGate = require(ExpChat.PresetChat.PresetChatGate)
local Constants = require(ExpChat.PresetChat.Constants)

local GetChatConfigurationStore = require(ExpChat.Stores.GetChatConfigurationStore)
local GetChatStatusStore = require(ExpChat.Stores.GetChatStatusStore)
local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)
local GetChatLayoutStore = require(ExpChat.Stores.GetChatLayoutStore)
local Timer = require(ExpChat.Timer)
local SpatialUI = require(ExpChat.SpatialUI)
local ClientSettingsUtility = require(ExpChat.ClientSettings.ClientSettingsUtility)
local canPlatformEnableChat = require(ExpChat.canPlatformEnableChat)
local isChatRegionLocked = require(ExpChat.isChatRegionLocked)
local showChatEnabledUI = require(ExpChat.showChatEnabledUI)

local appChat = parent.AppChat
local GetConversationMessageStore = require(appChat.GetConversationMessageStore)
local GetConversationMessageListStore = require(appChat.GetConversationMessageListStore)
local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)

local getFFlagExpChatConditionallyMountAppLayout = require(ExpChat.Flags.getFFlagExpChatConditionallyMountAppLayout)
local FFlagExpChatEnableV2ChatWindow = require(ExpChat.Flags.FFlagExpChatEnableV2ChatWindow)
local FFlagExpChatKeepV2PoolMounted = require(ExpChat.Flags.FFlagExpChatKeepV2PoolMounted)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local FFlagExpChatCenterMobilePresetButton = require(ExpChat.Flags.FFlagExpChatCenterMobilePresetButton)
local FFlagExpChatPresetFullWidthButtonFixes = require(ExpChat.Flags.FFlagExpChatPresetFullWidthButtonFixes)
local FFlagExpChatPresetChatSendEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatSendEnabled
local FFlagExpChatUniverseChatPresetEnabled = require(ExpChat.Flags.FFlagExpChatUniverseChatPresetEnabled)
local FFlagExpChatPresetButtonGlobalTabFix = require(ExpChat.Flags.FFlagExpChatPresetButtonGlobalTabFix)
local FFlagExpChatPresetChatGamepadEnabled = require(ExpChat.Flags.FFlagExpChatPresetChatGamepadEnabled)
local FFlagLuaSupportMicroGamepadPreferredInput = SharedFlags.FFlagLuaSupportMicroGamepadPreferredInput
local FFlagDebugForceEnableChatButtonOn = require(ExpChat.Flags.FFlagDebugForceEnableChatButtonOn)
local FFlagExpChatUseChatConfigStore = SharedFlags.FFlagExpChatUseChatConfigStore
local FFlagExpChatTabShortcutNav = SharedFlags.FFlagExpChatTabShortcutNav
local FFlagExpChatGenericChatFocus = require(ExpChat.Flags.FFlagExpChatGenericChatFocus)
local FocusNavigationExperiment = require(ExpChat.ShortcutNav.FocusNavigationExperiment)
local InputType = require(parent.InputType)
local FFlagExpChatNewInputBar = require(ExpChat.Flags.FFlagExpChatNewInputBar)
local defineFastFlag = game:DefineFastFlag("ExpChatPresetButtonOldInputBarV2", false)
local defineFastFlag2 = game:DefineFastFlag("ExpChatPresetFixChatHotkey", false)
local defineFastFlag3 = game:DefineFastFlag("ExpChatFixTopPaddingColor", false)
local defineFastFlag4 = game:DefineFastFlag("ExpChatPresetChatFixesEnabled", false)
local FFlagDebugFriendsChat = require(parent.FriendsChat.FFlagDebugFriendsChat)
local FFlagDebugExpChatPerf = require(ExpChat.Flags.FFlagDebugExpChatPerf)
local FStringDebugFriendsChatConversationId = require(parent.FriendsChat.FStringDebugFriendsChatConversationId)

local manuallyInvokeAmpUpsell = SocialUpsell.Utils.manuallyInvokeAmpUpsell
local SharedExperimentDefinition = require(parent.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled
local getFFlagExpChatTriggerWindowStatusEvent = require(ExpChat.Flags.getFFlagExpChatTriggerWindowStatusEvent)
local FFlagExpChatWindowStatusEventFixes = require(ExpChat.Flags.FFlagExpChatWindowStatusEventFixes)
local FFlagExpChatClearStaleSelectionOnClose = require(ExpChat.Flags.FFlagExpChatClearStaleSelectionOnClose)

local v = isInExperienceUIVREnabled
	and {
		DEFAULT = UDim2.fromScale(0.95, 0.94),
		WITH_CHANNEL_BAR = UDim2.fromScale(0.95, 0.78),
		WITH_CHATINPUT_BAR = UDim2.fromScale(0.95, 0.76),
		WITH_CHANNEL_CHATINPUT_BAR = UDim2.fromScale(0.95, 0.6098)
	}
	or nil

local GetFocusNavigationStore = require(ExpChat.Stores.GetFocusNavigationStore)
local GetTransparencyStore = require(ExpChat.Stores.GetTransparencyStore)
local GetChatWindowStatusStore = require(ExpChat.Stores.GetChatWindowStatusStore)

local function PresetChatInputRow(props)
	local v2 = not props.showEnableChatButton and 47 or Config.PresetChat.ButtonWidth
	local v3

	if props.showEnableChatButton then
		v3 = Foundation.Enums.InputSize.Small
	else
		v3 = Foundation.Enums.InputSize.Medium
	end

	local v4 = props.showEnableChatButton and 5 or 3

	local v5 = FFlagExpChatPresetButtonGlobalTabFix and props.isPresetButtonHidden and 0 or v2

	local createElement = Roact.createElement
	local v6 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = 3,
		Size = UDim2.fromScale(1, 0),
		Visible = props.isChatInputBarVisible or props.showEnableChatButton,
		ZIndex = 2
	}

	local children = {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 0)
		}),
		PresetButton = 0,
		FillArea = 0
	}

	local createElement2 = Roact.createElement
	local v7 = {
		BackgroundColor3 = props.backgroundColor3,
		BackgroundTransparency = props.transparencyValue:map(function(p: number)
			return props.backgroundTransparency + p * (1 - props.backgroundTransparency)
		end),
		BorderSizePixel = 0,
		ClipsDescendants = false,
		LayoutOrder = 1,
		Size = UDim2.new(0, v5, 1, 0),
		Visible = 0
	}
	local visible

	if defineFastFlag4 then
		visible = props.isChatWindowVisible or props.isChatInputBarVisible
	end

	v7.Visible = visible

	local createElement3 = Roact.createElement
	local v8 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, v4, 0.5, defineFastFlag4 and 0 or -1),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		GroupTransparency = props.transparencyValue
	}
	local content

	if not (FFlagExpChatPresetButtonGlobalTabFix and props.isPresetButtonHidden) then
		if props.presetLayoutMode == Constants.LayoutMode.Tray then
			local createElement4 = Roact.createElement
			local addTopPadding

			if FFlagExpChatCenterMobilePresetButton then
				addTopPadding = props.isChatWindowVisible
			end

			content = createElement4(PresetChatButton, {
				size = v3,
				isCircular = false,
				addTopPadding = addTopPadding
			})
		else
			content = Roact.createElement(PresetChatFlyOut, {
				addTopPadding = props.isChatWindowVisible,
				textChannel = props.targetTextChannel,
				buttonSize = v3,
				buttonIsCircular = false,
				onSendChat = props.onSendChat,
				onSendGlobalChat = props.onSendGlobalChat
			})
		end
	end

	children.PresetButton = createElement2("Frame", v7, {
		ButtonOrFlyOut = createElement3("CanvasGroup", v8, { Content = content })
	})

	local createElement4 = Roact.createElement
	local v9 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = 2,
		Size = UDim2.new(1, -v5, 0, 0)
	}
	local enableChatButton

	if props.showEnableChatButton then
		enableChatButton = Roact.createElement(EnableChatButton, {
			chatWindowSettings = props.chatWindowSettings,
			transparencyValue = props.transparencyValue,
			addTopPadding = props.isChatWindowVisible,
			onHovered = props.onHovered,
			onUnhovered = props.onUnhovered,
			isSpatialUIEnabled = props.isSpatialUIEnabled,
			visible = props.isChatWindowVisible or props.isChatInputBarVisible,
			onActivated = props.onEnableChatActivated
		})
	end

	local inputBar

	if defineFastFlag2 or props.isChatInputBarVisible then
		inputBar = Roact.createElement(ChatInput, {
			addTopPadding = props.isChatWindowVisible,
			onSendChat = props.onSendChat,
			onSendGlobalChat = props.onSendGlobalChat,
			transparencyValue = props.transparencyValue,
			canLocalUserChat = props.canLocalUserChat,
			resetTargetChannel = props.resetTargetChannel,
			visible = props.isChatInputBarVisible,
			onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
			onAbsolutePositionChanged = props.onAbsolutePositionChanged,
			chatWindowSettings = props.chatWindowSettings,
			isChannelBarVisible = props.isChannelBarVisible,
			isSpatialUIEnabled = props.isSpatialUIEnabled
		})
	end

	children.FillArea = createElement4("Frame", v9, {
		EnableChatButton = enableChatButton,
		InputBar = inputBar
	})
	return createElement("Frame", v6, children)
end

local extended = Roact.PureComponent:extend("AppLayout")
extended.defaultProps = {
	addTopPadding = true,
	canLocalUserChat = false,
	isChatInputBarVisible = true,
	isChatWindowVisible = true,
	isChannelBarVisible = false,
	renderingFriends = false,
	isExperienceChatRendered = true,
	LayoutOrder = 1,
	mutedUserIds = nil,
	onSendChat = nil,
	onSendGlobalChat = nil,
	textTimer = Timer.new(Config.ChatWindowTextFadeOutTime),
	timer = Timer.new(Config.ChatWindowBackgroundFadeOutTime),
	isSpatialUIEnabled = false,
	canPlatformEnableChat = canPlatformEnableChat
}

local v2 = { frequency = 1.25, dampingRatio = 1 }

function extended:init()
	self.state = {}
	local ref

	if FFlagDebugFriendsChat then
		ref = Roact.createRef()
	end

	self.debugContainerRef = ref

	function self.setChatContainerRef(current)
		if FFlagDebugFriendsChat and self.debugContainerRef then
			self.debugContainerRef.current = current
		end

		if FFlagExpChatTabShortcutNav or FFlagExpChatGenericChatFocus then
			GetFocusNavigationStore(false).setChatRoot(current)
		end
	end

	if FFlagDebugFriendsChat or FFlagDebugExpChatPerf then
		self.debugInjectionThread = nil
		self.debugKeybindConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if gameProcessed then
				return
			end

			if input.KeyCode == Enum.KeyCode.K and input:IsModifierKeyDown(Enum.ModifierKey.Ctrl) then
				self:debugInjectFakeMessages()
			elseif FFlagDebugFriendsChat and input.KeyCode == Enum.KeyCode.BackSlash then
				self:debugSeedFocusNavigation()
			end
		end)
	end

	local binding, updateBackgroundTransparency = Roact.createBinding(0)
	self.transparencyValue = binding
	self.updateBackgroundTransparency = updateBackgroundTransparency
	self.backgroundTransparencyMotor = Otter.createSingleMotor(0)
	self.backgroundTransparencyMotor:onStep(self.updateBackgroundTransparency)

	local binding2, updateTextTransparencyValue = Roact.createBinding(0)
	self.textTransparencyValue = binding2
	self.updateTextTransparencyValue = updateTextTransparencyValue
	self.textTransparencyMotor = Otter.createSingleMotor(0)
	self.textTransparencyMotor:onStep(self.updateTextTransparencyValue)

	local transparencyStore = GetTransparencyStore(false)
	local chatWindowStatusStore

	if getFFlagExpChatTriggerWindowStatusEvent() then
		chatWindowStatusStore = GetChatWindowStatusStore(false)
	end

	self.ChatWindowStatusStore = chatWindowStatusStore

	if FFlagExpChatWindowStatusEventFixes then
		local currentChatWindowState = self.ChatWindowStatusStore.getCurrentChatWindowState(false)
		local lastTrackedChatVisible

		if currentChatWindowState ~= "unknown" then
			lastTrackedChatVisible = currentChatWindowState ~= "closed"
		end

		self.lastTrackedChatVisible = lastTrackedChatVisible
	elseif getFFlagExpChatTriggerWindowStatusEvent() then
		self.localPlayerLeavingConnection = Players.PlayerRemoving:Connect(function(player)
			if player == Players.LocalPlayer then
				self.ChatWindowStatusStore.setPreviousChatWindowState(self.ChatWindowStatusStore.getCurrentChatWindowState(false))

				local durationUpdates = self.ChatWindowStatusStore.getDurationUpdates(false)
				TextChatService:SendExpChatWindowStatusChange(
					durationUpdates.closedDuration,
					durationUpdates.openDuration,
					durationUpdates.backgroundIdleDuration,
					durationUpdates.textIdleDuration
				)
			end
		end)
	end

	if FFlagExpChatUseChatConfigStore then
		self.ChatConfigurationStore = GetChatConfigurationStore(false)
	end

	function self.isChatSurfaceVisibleForStatusTracking()
		return self.props.isChatWindowVisible or self.props.isChatInputBarVisible
	end

	function self.stampOpenForStatusTrackingIfNeeded()
		if
			FFlagExpChatWindowStatusEventFixes
			and self:isChatSurfaceVisibleForStatusTracking()
			and self.ChatWindowStatusStore.getCurrentChatWindowState(false) ~= "open"
		then
			self.ChatWindowStatusStore.setOpenTimerStarted(os.clock())
		end
	end

	function self.stampBackgroundIdleForStatusTrackingIfNeeded()
		if
			FFlagExpChatWindowStatusEventFixes
			and self:isChatSurfaceVisibleForStatusTracking()
			and self.ChatWindowStatusStore.getCurrentChatWindowState(false) == "textIdle"
		then
			self.ChatWindowStatusStore.setBackgroundTimerStarted(os.clock())
		end
	end

	function self.resetBackgroundTransparency()
		local isFocused = transparencyStore.getIsFocused(false)

		self.backgroundTransparencyMotor:setGoal(Otter.instant(0))
		self.props.timer:stop()
		self:stampOpenForStatusTrackingIfNeeded()

		if isFocused == false and self.props.isSpatialUIEnabled == false then
			if FFlagExpChatWindowStatusEventFixes and not self:isChatSurfaceVisibleForStatusTracking() then
				return
			end

			self.props.timer:start():andThen(function()
				if FFlagExpChatWindowStatusEventFixes then
					if self:isChatSurfaceVisibleForStatusTracking() then
						self.ChatWindowStatusStore.setBackgroundTimerStarted(os.clock())
					end
				elseif getFFlagExpChatTriggerWindowStatusEvent() then
					self.ChatWindowStatusStore.setBackgroundTimerStarted(os.clock())
				end

				self.backgroundTransparencyMotor:setGoal(Otter.spring(1, v2))
			end)
		end
	end

	function self.resetTextTransparency()
		local isFocused = transparencyStore.getIsFocused(false)

		self.textTransparencyMotor:setGoal(Otter.instant(0))
		self.props.textTimer:stop()
		self:stampBackgroundIdleForStatusTrackingIfNeeded()

		if isFocused == false then
			if FFlagExpChatWindowStatusEventFixes and not self:isChatSurfaceVisibleForStatusTracking() then
				return
			end

			self.props.textTimer:start():andThen(function()
				if FFlagExpChatWindowStatusEventFixes then
					if self:isChatSurfaceVisibleForStatusTracking() then
						self.ChatWindowStatusStore.setTextTimerStarted(os.clock())
					end
				elseif getFFlagExpChatTriggerWindowStatusEvent() then
					self.ChatWindowStatusStore.setTextTimerStarted(os.clock())
				end

				self.textTransparencyMotor:setGoal(Otter.spring(1, v2))
			end)
		end
	end
	self.disposeBackgroundEffect = createEffect(function(p)
		transparencyStore.getLastActivity(p)
		self.resetBackgroundTransparency()
		self.resetTextTransparency()
	end)

	self.disposeTextEffect = createEffect(function(p)
		transparencyStore.getLastMessageActivity(p)
		self.resetTextTransparency()
	end)

	self.disposeChatStatusEffect = createEffect(function(p)
		self:setState({
			chatStatus = GetChatStatusStore(p).getChatStatus(p)
		})
	end)

	if FFlagExpChatPresetChatEnabled then
		self.disposePresetFlyOutAvailableEffect = createEffect(function(p)
			local presetChatStore = GetPresetChatStore(p)
			local isEnabled = presetChatStore.getIsEnabled(p)
			local accessLevel = presetChatStore.getAccessLevel(p)
			local presetLayoutMode = presetChatStore.getLayoutModeOverride(p)

			if presetLayoutMode ~= Constants.LayoutMode.Tray and presetLayoutMode ~= Constants.LayoutMode.FlyOut then
				if
					FFlagExpChatPresetChatGamepadEnabled
					and (UserInputService.PreferredInput == Enum.PreferredInput.Gamepad or FFlagLuaSupportMicroGamepadPreferredInput and UserInputService.PreferredInput == Enum.PreferredInput.MicroGamepad)
				then
					presetLayoutMode = Constants.LayoutMode.FlyOut
				elseif UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
					presetLayoutMode = Constants.LayoutMode.Tray
				else
					presetLayoutMode = Constants.LayoutMode.FlyOut
				end
			end

			local isPresetFlyOutAvailable = isEnabled and FFlagExpChatPresetChatSendEnabled

			if isPresetFlyOutAvailable then
				if accessLevel == Constants.AccessLevel.Enabled then
					isPresetFlyOutAvailable = self.props.targetTextChannel ~= nil
						or FFlagExpChatUniverseChatPresetEnabled
				else
					isPresetFlyOutAvailable = false
				end
			end

			local isPresetChatAvailable

			if FFlagExpChatPresetButtonGlobalTabFix then
				isPresetChatAvailable = isEnabled
					and FFlagExpChatPresetChatSendEnabled
					and accessLevel == Constants.AccessLevel.Enabled
			end

			self:setState({
				isPresetFlyOutAvailable = isPresetFlyOutAvailable,
				isPresetChatAvailable = isPresetChatAvailable,
				presetLayoutMode = presetLayoutMode
			})
		end)
	end

	function self.onAbsolutePositionChanged(p, p2)
		p2.AbsolutePositionWrite = p.AbsolutePosition
	end

	function self.onAbsoluteSizeChanged(p, p2)
		p2.AbsoluteSizeWrite = p.AbsoluteSize
	end

	function self.onChatFrameLayoutChanged(p)
		if FFlagExpChatPresetChatEnabled then
			local v3 = p.AbsolutePosition.Y + p.AbsoluteSize.Y
			GetPresetChatStore(false).setChatWindowBottomY(v3)
		end

		GetChatLayoutStore(false).setChatWindowWidth(p.AbsoluteSize.X)
	end
	self.focusNavigationService = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)

	self.topBorderRef = Roact.createRef()
	function self.onContainerSelectionChanged(ancestor, _, selectedCoreObject, instance)
		local v3

		if instance == nil then
			v3 = false
		else
			v3 = instance:IsDescendantOf(ancestor)
		end

		if v3 then
			transparencyStore.setWindowFocusInput()

			if instance == self.topBorderRef.current then
				if
					FFlagExpChatGenericChatFocus
					and InputType.getInputGroup(UserInputService:GetLastInputType()) ~= InputType.InputTypeConstants.Gamepad
				then
					if selectedCoreObject == nil or not selectedCoreObject:IsDescendantOf(ancestor) then
						selectedCoreObject = nil
					end

					GuiService.SelectedCoreObject = selectedCoreObject
				else
					FocusUtils.FocusOnChrome(function()
						GetFocusNavigationStore(false).unfocusChatInputBar()
					end, "chat")
				end
			end
		else
			GetFocusNavigationStore(false).unfocusChatInputBar()
			transparencyStore.clearWindowFocusInput()
		end
	end
end

function extended:syncChatWindowVisibilityForStatusTracking()
	if not FFlagExpChatWindowStatusEventFixes then
		return
	end

	local chatSurfaceVisibleForStatusTracking = self:isChatSurfaceVisibleForStatusTracking()

	if self.lastTrackedChatVisible == chatSurfaceVisibleForStatusTracking then
		return
	end

	self.lastTrackedChatVisible = chatSurfaceVisibleForStatusTracking

	if chatSurfaceVisibleForStatusTracking then
		self.ChatWindowStatusStore.setOpenTimerStarted(os.clock())
		return
	end

	self.ChatWindowStatusStore.setClosedTimerStarted(os.clock())
	self.props.timer:stop()
	self.props.textTimer:stop()
end

function extended:didMount()
	if FFlagExpChatWindowStatusEventFixes then
		self:syncChatWindowVisibilityForStatusTracking()

		if self:isChatSurfaceVisibleForStatusTracking() then
			self.props.timer:start():andThen(function()
				if self:isChatSurfaceVisibleForStatusTracking() then
					self.ChatWindowStatusStore.setBackgroundTimerStarted(os.clock())
				end

				self.backgroundTransparencyMotor:setGoal(Otter.spring(1, v2))
			end)

			self.props.textTimer:start():andThen(function()
				if self:isChatSurfaceVisibleForStatusTracking() then
					self.ChatWindowStatusStore.setTextTimerStarted(os.clock())
				end

				self.textTransparencyMotor:setGoal(Otter.spring(1, v2))
			end)
		end
	else
		self.props.timer:start():andThen(function()
			if getFFlagExpChatTriggerWindowStatusEvent() then
				self.ChatWindowStatusStore.setBackgroundTimerStarted(os.clock())
			end

			self.backgroundTransparencyMotor:setGoal(Otter.spring(1, v2))
		end)

		self.props.textTimer:start():andThen(function()
			if getFFlagExpChatTriggerWindowStatusEvent() then
				self.ChatWindowStatusStore.setTextTimerStarted(os.clock())
			end

			self.textTransparencyMotor:setGoal(Otter.spring(1, v2))
		end)
	end
end

function extended:didUpdate(data)
	if
		FFlagExpChatClearStaleSelectionOnClose
		and (data.isChatWindowVisible and not self.props.isChatWindowVisible or data.renderingFriends and not self.props.renderingFriends)
	then
		local selectedCoreObject = GuiService.SelectedCoreObject

		if selectedCoreObject == nil or not selectedCoreObject:IsDescendantOf(game) then
			if selectedCoreObject ~= nil then
				GuiService.SelectedCoreObject = nil
			end

			GetTransparencyStore(false).clearWindowFocusInput()
		end
	end

	if not FFlagExpChatWindowStatusEventFixes then
		return
	end

	local isChatWindowVisible = data.isChatWindowVisible or data.isChatInputBarVisible
	local chatSurfaceVisibleForStatusTracking = self:isChatSurfaceVisibleForStatusTracking()

	if isChatWindowVisible == chatSurfaceVisibleForStatusTracking then
		return
	end

	self:syncChatWindowVisibilityForStatusTracking()

	if chatSurfaceVisibleForStatusTracking then
		self.resetBackgroundTransparency()
		self.resetTextTransparency()
	end
end

function extended.render(props)
	if FocusNavigationExperiment.isBackupExposureLoggingEnabled and props.isChatSurfaceVisibleForStatusTracking() then
		FocusNavigationExperiment.logExposure()
	end

	if getFFlagExpChatTriggerWindowStatusEvent() and not FFlagExpChatWindowStatusEventFixes then
		if props.props.isChatWindowVisible or props.props.isChatInputBarVisible then
			props.ChatWindowStatusStore.setOpenTimerStarted(os.clock())
		else
			props.ChatWindowStatusStore.setClosedTimerStarted(os.clock())
		end
	end

	local chatWindowSettings

	if FFlagExpChatUseChatConfigStore and props.ChatConfigurationStore then
		chatWindowSettings = props.ChatConfigurationStore.getChatWindowSettings(false)
	else
		chatWindowSettings = props.props.chatWindowSettings
	end

	local backgroundTransparency = ClientSettingsUtility.getBackgroundTransparency(
		chatWindowSettings,
		props.props.clientSettings
	)
	local backgroundColor = ClientSettingsUtility.getBackgroundColor(chatWindowSettings, props.props.clientSettings)
	local v3 = nil

	local renderingFriends = props.props.renderingFriends
	local isExperienceChatRendered = props.props.isExperienceChatRendered

	local isChatInputBarVisible = props.props.isChatInputBarVisible
	local chatStatus = props.state.chatStatus
	local v4 = isChatInputBarVisible and showChatEnabledUI(chatStatus)

	if isInExperienceUIVREnabled then
		if props.props.isSpatialUIEnabled then
			local isChannelBarVisible = getFFlagExpChatConditionallyMountAppLayout() and props.props.isChannelBarVisible

			if isChannelBarVisible and v4 then
				v3 = v.WITH_CHANNEL_CHATINPUT_BAR
			elseif isChannelBarVisible and not v4 then
				v3 = v.WITH_CHANNEL_BAR
			elseif isChannelBarVisible or not v4 then
				v3 = v.DEFAULT
			else
				v3 = v.WITH_CHATINPUT_BAR
			end
		else
			v3 = UDim2.fromScale(
				Config.ChatWindowSize.X.Scale * chatWindowSettings.WidthScale,
				Config.ChatWindowSize.Y.Scale * chatWindowSettings.HeightScale
			)
		end
	end

	local showEnableChatButton = FFlagDebugForceEnableChatButtonOn
		or not isChatRegionLocked() and props.props.canPlatformEnableChat() and chatStatus == "AgeVerificationRequired"

	local v5 = defineFastFlag and FFlagExpChatPresetChatEnabled and props.state.isPresetFlyOutAvailable

	local fullWidthButton = FFlagExpChatPresetChatEnabled
		and props.state.isPresetFlyOutAvailable
		and not (showEnableChatButton or v4)
	local v6

	if FFlagExpChatPresetButtonGlobalTabFix then
		if props.state.isPresetChatAvailable == true then
			v6 = props.props.targetTextChannel ~= nil or FFlagExpChatUniverseChatPresetEnabled
		else
			v6 = false
		end
	else
		v6 = nil
	end

	if FFlagExpChatPresetButtonGlobalTabFix then
		v5 = defineFastFlag and FFlagExpChatPresetChatEnabled and props.state.isPresetChatAvailable == true
		fullWidthButton = FFlagExpChatPresetChatEnabled and v6 and not (showEnableChatButton or v4)
	end

	local function fn(selectionImageObject)
		local createElement = Roact.createElement
		local v7 = {
			["AnchorPoint"] = props.props.chatLayoutAlignment.AnchorPoint,
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 1,
			Position = props.props.chatLayoutAlignment.Position,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			SelectionGroup = true
		}
		local size

		if isInExperienceUIVREnabled then
			size = v3
		elseif props.props.isSpatialUIEnabled then
			size = UDim2.fromScale(0.95, 0.68)
		else
			size = UDim2.fromScale(
				Config.ChatWindowSize.X.Scale * chatWindowSettings.WidthScale,
				Config.ChatWindowSize.Y.Scale * chatWindowSettings.HeightScale
			)
		end

		v7.Size = size

		v7[Roact.Change.AbsoluteSize] = props.onChatFrameLayoutChanged
		local absolutePosition = Roact.Change.AbsolutePosition
		local v8

		if FFlagExpChatPresetChatEnabled then
			v8 = props.onChatFrameLayoutChanged
		end

		v7[absolutePosition] = v8

		v7[Roact.Event.SelectionChanged] = props.onContainerSelectionChanged
		local ref = Roact.Ref
		local v9

		if FFlagDebugFriendsChat or FFlagExpChatTabShortcutNav or FFlagExpChatGenericChatFocus then
			v9 = props.setChatContainerRef
		end

		v7[ref] = v9

		local createElement2 = Roact.createElement
		local maxSize

		if props.props.isSpatialUIEnabled then
			maxSize = Vector2.new(1e999, 1e999)
		else
			maxSize = Vector2.new(Config.ChatWindowMaxWidth, 1e999)
		end

		local children = {
			uiSizeConstraint = createElement2("UISizeConstraint", { MaxSize = maxSize }),
			layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = props.props.chatLayoutAlignment.UIListLayoutVerticalAlignment
			}),
			topBorder = Roact.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Image = "rbxasset://textures/ui/TopRoundedRect8px.png",
				ImageColor3 = backgroundColor,
				ImageTransparency = props.transparencyValue:map(function(p: number)
					return backgroundTransparency + p * (1 - backgroundTransparency)
				end),
				LayoutOrder = 1,
				SelectionImageObject = selectionImageObject,
				Selectable = true,
				ScaleType = Enum.ScaleType.Slice,
				Size = UDim2.new(1, 0, 0, 8),
				SliceCenter = Rect.new(8, 8, 24, 32),
				Visible = (props.props.isChatWindowVisible or props.props.isChatInputBarVisible) and not props.props.isChannelBarVisible,
				[Roact.Event.MouseEnter] = props.props.onHovered,
				[Roact.Event.MouseLeave] = props.props.onUnhovered,
				[Roact.Ref] = props.topBorderRef
			}, {
				uiSizeConstraint = Roact.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(Config.ChatWindowMaxWidth, 1e999)
				})
			}),
			topPadding = 0,
			chatWindow = 0,
			presetChatTray = 0,
			chatInputBar = 0,
			friendsChat = 0,
			enableChatButton = 0,
			chatInputRow = 0,
			channelBar = 0,
			bottomBorder = 0
		}

		local createElement3 = Roact.createElement
		local size2

		if renderingFriends then
			size2 = UDim2.fromScale(1, 0)
		else
			size2 = UDim2.new(1, 0, 0, 8)
		end

		local v10 = {
			["LayoutOrder"] = nil,
			["LayoutOrder"] = nil,
			["LayoutOrder"] = nil,
			["LayoutOrder"] = nil,
			["LayoutOrder"] = nil,
			LayoutOrder = 1,
			Size = size2,
			Visible = props.props.isChannelBarVisible,
			BackgroundTransparency = props.transparencyValue:map(function(p: number)
				return backgroundTransparency + p * (1 - backgroundTransparency)
			end)
		}
		local backgroundColor2

		if defineFastFlag3 then
			backgroundColor2 = backgroundColor
		else
			backgroundColor2 = chatWindowSettings.BackgroundColor3
		end

		v10.BackgroundColor3 = backgroundColor2

		v10.BorderSizePixel = 0
		v10[Roact.Event.MouseEnter] = props.props.onHovered
		v10[Roact.Event.MouseLeave] = props.props.onUnhovered
		v10.ZIndex = 0
		children.topPadding = createElement3("Frame", v10)
		local chatWindow

		if isExperienceChatRendered then
			chatWindow = ((not getFFlagExpChatConditionallyMountAppLayout() or FFlagExpChatEnableV2ChatWindow and FFlagExpChatKeepV2PoolMounted) and true or props.props.isChatWindowVisible)
				and Roact.createElement(ChatWindow, {
					LayoutOrder = 2,
					size = UDim2.fromScale(1, 1),
					transparencyValue = props.transparencyValue,
					textTransparency = props.textTransparencyValue,
					onHovered = props.props.onHovered,
					onUnhovered = props.props.onUnhovered,
					mutedUserIds = props.props.mutedUserIds,
					activateWhisperMode = props.props.activateWhisperMode,
					resetTargetChannel = props.props.resetTargetChannel,
					visible = props.props.isChatWindowVisible,
					onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
					onAbsolutePositionChanged = props.onAbsolutePositionChanged,
					chatWindowSettings = chatWindowSettings,
					showTranslationButton = props.props.showTranslationButton,
					isChannelBarVisible = props.props.isChannelBarVisible,
					isSpatialUIEnabled = props.props.isSpatialUIEnabled
				})
		end

		children.chatWindow = chatWindow
		local presetChatTray

		if isExperienceChatRendered and FFlagExpChatPresetChatEnabled and FFlagExpChatPresetChatSendEnabled then
			presetChatTray = Roact.createElement(
				PresetChatGate,
				{
					layoutMode = Constants.LayoutMode.Tray,
					targetTextChannel = props.props.targetTextChannel
				},
				{
					Tray = Roact.createElement(PresetChatTray, {
						textChannel = props.props.targetTextChannel,
						onSendChat = props.props.onSendChat,
						onSendGlobalChat = props.props.onSendGlobalChat
					})
				}
			)
		end

		children.presetChatTray = presetChatTray
		local chatInputBar

		if isExperienceChatRendered and not FFlagExpChatNewInputBar then
			if v5 then
				local createElement4 = Roact.createElement
				local v11 = {
					transparencyValue = props.transparencyValue,
					backgroundColor3 = backgroundColor,
					backgroundTransparency = backgroundTransparency,
					isChatWindowVisible = props.props.isChatWindowVisible,
					isChatInputBarVisible = v4,
					targetTextChannel = props.props.targetTextChannel,
					onSendChat = props.props.onSendChat,
					onSendGlobalChat = props.props.onSendGlobalChat,
					resetTargetChannel = props.props.resetTargetChannel,
					onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
					onAbsolutePositionChanged = props.onAbsolutePositionChanged,
					chatWindowSettings = chatWindowSettings,
					isChannelBarVisible = props.props.isChannelBarVisible,
					isSpatialUIEnabled = props.props.isSpatialUIEnabled,
					showEnableChatButton = showEnableChatButton,
					onHovered = props.props.onHovered,
					onUnhovered = props.props.onUnhovered,
					onEnableChatActivated = function()
						manuallyInvokeAmpUpsell("InExperienceTextChatUpsell")
					end,
					presetLayoutMode = props.state.presetLayoutMode,
					isPresetButtonHidden = 0
				}
				local isPresetButtonHidden

				if FFlagExpChatPresetButtonGlobalTabFix then
					isPresetButtonHidden = not v6
				end

				v11.isPresetButtonHidden = isPresetButtonHidden
				chatInputBar = createElement4(PresetChatInputRow, v11)
			else
				chatInputBar = Roact.createElement(ChatInput, {
					LayoutOrder = 3,
					addTopPadding = props.props.isChatWindowVisible,
					onSendChat = props.props.onSendChat,
					onSendGlobalChat = props.props.onSendGlobalChat,
					transparencyValue = props.transparencyValue,
					resetTargetChannel = props.props.resetTargetChannel,
					visible = v4,
					onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
					onAbsolutePositionChanged = props.onAbsolutePositionChanged,
					chatWindowSettings = chatWindowSettings,
					isChannelBarVisible = props.props.isChannelBarVisible,
					isSpatialUIEnabled = props.props.isSpatialUIEnabled
				})
			end
		end

		children.chatInputBar = chatInputBar
		local friendsChat

		if renderingFriends and props.props.isChatWindowVisible then
			friendsChat = Roact.createElement(FriendsChatDependencyBridge, {}, {
				friendsChatMain = Roact.createElement(FriendsChatMain, {
					parentLayoutOrder = 2,
					chatWindowSettings = chatWindowSettings,
					transparencyValue = props.transparencyValue,
					textTransparency = props.textTransparencyValue,
					isSpatialUIEnabled = props.props.isSpatialUIEnabled,
					isChannelBarVisible = props.props.isChannelBarVisible,
					onHovered = props.props.onHovered,
					onUnhovered = props.props.onUnhovered,
					onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
					onAbsolutePositionChanged = props.onAbsolutePositionChanged
				})
			})
		end

		children.friendsChat = friendsChat
		local enableChatButton

		if isExperienceChatRendered and not FFlagExpChatNewInputBar and not v5 and showEnableChatButton then
			enableChatButton = Roact.createElement(EnableChatButton, {
				chatWindowSettings = chatWindowSettings,
				transparencyValue = props.transparencyValue,
				addTopPadding = props.props.isChatWindowVisible,
				onHovered = props.props.onHovered,
				onUnhovered = props.props.onUnhovered,
				isSpatialUIEnabled = props.props.isSpatialUIEnabled,
				LayoutOrder = 3,
				visible = props.props.isChatWindowVisible or props.props.isChatInputBarVisible,
				onActivated = function()
					manuallyInvokeAmpUpsell("InExperienceTextChatUpsell")
				end
			})
		end

		children.enableChatButton = enableChatButton
		local chatInputRow

		if isExperienceChatRendered and FFlagExpChatNewInputBar then
			local createElement4 = Roact.createElement
			local v11 = {
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = backgroundColor,
				BackgroundTransparency = props.transparencyValue:map(function(p: number)
					return backgroundTransparency + p * (1 - backgroundTransparency)
				end),
				BorderSizePixel = 0,
				LayoutOrder = 3,
				Size = UDim2.fromScale(1, 0),
				Visible = not FFlagExpChatPresetChatEnabled or (props.props.isChatWindowVisible or props.props.isChatInputBarVisible),
				ZIndex = 2,
				[Roact.Event.MouseEnter] = props.props.onHovered,
				[Roact.Event.MouseLeave] = props.props.onUnhovered
			}
			local v12 = {
				UIListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, 8),
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				UIPadding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 8),
					PaddingRight = UDim.new(0, 8)
				}),
				presetFlyOutWrapper = 0,
				fillArea = 0
			}
			local presetFlyOutWrapper

			if FFlagExpChatPresetChatEnabled then
				local v13

				if FFlagExpChatPresetButtonGlobalTabFix then
					v13 = v6
				else
					v13 = props.state.isPresetFlyOutAvailable
				end

				if v13 then
					local createElement5 = Roact.createElement
					local v14 = {
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						GroupTransparency = props.transparencyValue,
						LayoutOrder = 1,
						Size = 0,
						Visible = 0
					}
					local size3

					if fullWidthButton then
						size3 = UDim2.fromScale(1, 0)
					else
						size3 = UDim2.fromOffset(Config.PresetChat.ButtonWidth, 0)
					end

					v14.Size = size3
					local visible

					if defineFastFlag4 then
						visible = props.props.isChatWindowVisible or props.props.isChatInputBarVisible
					end

					v14.Visible = visible
					local presetEntry

					if props.state.presetLayoutMode == Constants.LayoutMode.Tray then
						local createElement6 = Roact.createElement
						local v15 = {
							baseTransparency = 0,
							targetTextChannel = props.props.targetTextChannel,
							addTopPadding = 0,
							fullWidth = 0
						}
						local addTopPadding

						if FFlagExpChatCenterMobilePresetButton then
							addTopPadding = props.props.isChatWindowVisible
						end

						v15.addTopPadding = addTopPadding
						local fullWidth

						if FFlagExpChatPresetFullWidthButtonFixes then
							fullWidth = fullWidthButton
						end

						v15.fullWidth = fullWidth
						presetEntry = createElement6(PresetChatButton, v15)
					else
						presetEntry = Roact.createElement(PresetChatFlyOut, {
							addTopPadding = props.props.isChatWindowVisible,
							fullWidthButton = fullWidthButton,
							textChannel = props.props.targetTextChannel,
							onSendChat = props.props.onSendChat,
							onSendGlobalChat = props.props.onSendGlobalChat
						})
					end

					presetFlyOutWrapper = createElement5("CanvasGroup", v14, {
						PresetEntry = presetEntry
					})
				end
			end

			v12.presetFlyOutWrapper = presetFlyOutWrapper
			local fillArea

			if defineFastFlag2 or not fullWidthButton then
				local createElement5 = Roact.createElement
				local automaticSize

				if defineFastFlag2 and fullWidthButton then
					automaticSize = Enum.AutomaticSize.None
				else
					automaticSize = Enum.AutomaticSize.Y
				end

				local udim

				if defineFastFlag2 and fullWidthButton then
					udim = UDim2.new(0, 0, 0, 0)
				else
					local v13

					if FFlagExpChatPresetButtonGlobalTabFix then
						v13 = v6
					else
						v13 = props.state.isPresetFlyOutAvailable
					end

					udim = UDim2.new(1, not v13 and 0 or -(Config.PresetChat.ButtonWidth + 8), 0, 0)
				end

				local visible

				if defineFastFlag2 then
					visible = not fullWidthButton
				end

				local enableChatButton2

				if showEnableChatButton then
					enableChatButton2 = Roact.createElement(EnableChatButton, {
						chatWindowSettings = chatWindowSettings,
						transparencyValue = props.transparencyValue,
						addTopPadding = props.props.isChatWindowVisible,
						onHovered = props.props.onHovered,
						onUnhovered = props.props.onUnhovered,
						isSpatialUIEnabled = props.props.isSpatialUIEnabled,
						visible = props.props.isChatWindowVisible or props.props.isChatInputBarVisible,
						onActivated = function()
							manuallyInvokeAmpUpsell("InExperienceTextChatUpsell")
						end
					})
				end

				local chatInputBar2

				if defineFastFlag2 or v4 then
					local createElement6 = Roact.createElement
					local v13 = {
						addTopPadding = props.props.isChatWindowVisible,
						onSendChat = props.props.onSendChat,
						onSendGlobalChat = props.props.onSendGlobalChat,
						transparencyValue = props.transparencyValue,
						resetTargetChannel = props.props.resetTargetChannel,
						visible = 0,
						onAbsoluteSizeChanged = 0,
						onAbsolutePositionChanged = 0,
						chatWindowSettings = 0,
						isChannelBarVisible = 0,
						isSpatialUIEnabled = 0,
						onHovered = 0,
						onUnhovered = 0,
						suppressOuterBackground = true
					}
					local visible2

					if defineFastFlag2 then
						visible2 = v4
					end

					v13.visible = visible2
					v13.onAbsoluteSizeChanged = props.onAbsoluteSizeChanged
					v13.onAbsolutePositionChanged = props.onAbsolutePositionChanged
					v13.chatWindowSettings = chatWindowSettings
					v13.isChannelBarVisible = props.props.isChannelBarVisible
					v13.isSpatialUIEnabled = props.props.isSpatialUIEnabled
					v13.onHovered = props.props.onHovered
					v13.onUnhovered = props.props.onUnhovered
					chatInputBar2 = createElement6(ChatInput, v13)
				end

				fillArea = createElement5("Frame", {
					AutomaticSize = automaticSize,
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = udim,
					Visible = visible
				}, { enableChatButton = enableChatButton2, chatInputBar = chatInputBar2 })
			end

			v12.fillArea = fillArea
			chatInputRow = createElement4("Frame", v11, v12)
		end

		children.chatInputRow = chatInputRow

		children.channelBar = (not getFFlagExpChatConditionallyMountAppLayout() or props.props.isChannelBarVisible)
			and Roact.createElement(ChannelBar, {
				LayoutOrder = renderingFriends and 100 or 4,
				size = UDim2.fromScale(1, 1),
				transparencyValue = props.transparencyValue,
				onHovered = props.props.onHovered,
				onUnhovered = props.props.onUnhovered,
				chatWindowSettings = chatWindowSettings,
				visible = props.props.isChannelBarVisible,
				topBorderRef = props.topBorderRef
			})
		local bottomBorder

		if not renderingFriends then
			bottomBorder = Roact.createElement("ImageLabel", {
				Name = "bottomBorder",
				BackgroundTransparency = 1,
				Image = "rbxasset://textures/ui/BottomRoundedRect8px.png",
				ImageColor3 = backgroundColor,
				ImageTransparency = props.transparencyValue:map(function(p: number)
					return backgroundTransparency + p * (1 - backgroundTransparency)
				end),
				LayoutOrder = 5,
				ScaleType = Enum.ScaleType.Slice,
				Size = UDim2.new(1, 0, 0, 8),
				SliceCenter = Rect.new(8, 0, 24, 16),
				Visible = props.props.isChatWindowVisible or props.props.isChatInputBarVisible,
				[Roact.Event.MouseEnter] = props.props.onHovered,
				[Roact.Event.MouseLeave] = props.props.onUnhovered
			}, {
				uiSizeConstraint = Roact.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(Config.ChatWindowMaxWidth, 1e999)
				})
			})
		end

		children.bottomBorder = bottomBorder
		local element = createElement("Frame", v7, children)

		return Roact.createElement(SpatialUI.Provider, {
			value = { isSpatialUIEnabled = props.props.isSpatialUIEnabled }
		}, {
			appLayout = Roact.createElement(ChatPlatformProvider, {}, { appLayout = element })
		})
	end

	return Roact.createElement(
		ReactFocusNavigation.FocusNavigationContext.Provider,
		{ value = props.focusNavigationService },
		{
			CursorProvider = Roact.createElement(SelectionCursorProvider, {}, {
				NewCursorProvider = Roact.createElement(CursorProvider, {}, {
					withSelectionCursorProvider(function(callback)
						return fn(callback(CursorKind.Invisible))
					end)
				})
			})
		}
	)
end

function extended:debugInjectFakeMessages()
	if self.debugInjectionThread ~= nil then
		task.cancel(self.debugInjectionThread)
		self.debugInjectionThread = nil
	end

	local renderingFriends = self.props.renderingFriends
	local v3 = GetFriendsChatRealtimeStore(false).getActiveConversationId(false)
		or FStringDebugFriendsChatConversationId

	if renderingFriends and (v3 == nil or v3 == "") then
		return
	end

	self.debugInjectionThread = task.spawn(function()
		local v4

		if renderingFriends then
			v4 = GetConversationMessageStore(false)
		end

		local v5

		if renderingFriends then
			v5 = GetConversationMessageListStore(false)
		end

		local v6

		if not renderingFriends then
			v6 = GetMessagesStore(false)
		end

		for i = 1, 50 do
			if renderingFriends then
				local formatted = `debug-fake-{tostring(os.clock())}-{i}`
				v4.upsertMessages({
					[formatted] = {
						id = formatted,
						type = "user",
						content = `Fake friends-chat debug message #{i}`,
						created_at = DateTime.now():ToIsoDate(),
						sender_user_id = (i - 1) % 5 + 1
					}
				})

				v5.prependMessages(v3, { formatted })
			elseif v6 ~= nil then
				v6.addSystemMessage(`Fake exp-chat debug message #{i}`, "RBXGeneral", nil, nil, false)
			end

			if i < 50 then
				task.wait(0.1)
			end
		end

		self.debugInjectionThread = nil
	end)
end

local function isVisibleWithin(guiObject, current): boolean
	while guiObject ~= nil do
		if guiObject:IsA("GuiObject") and not guiObject.Visible then
			return false
		end

		if guiObject == current then
			break
		end

		guiObject = guiObject.Parent
	end

	return true
end

function extended:debugSeedFocusNavigation()
	local current

	if self.debugContainerRef then
		current = self.debugContainerRef.current
	end

	if current == nil then
		return
	end

	local current2

	if self.topBorderRef then
		current2 = self.topBorderRef.current
	end

	for _, guiObject in current:GetDescendants() do
		if
			guiObject:IsA("GuiObject")
			and guiObject.Selectable
			and guiObject ~= current2
			and isVisibleWithin(guiObject, current)
		then
			GuiService.SelectedCoreObject = guiObject
			break
		end
	end
end

function extended:willUnmount()
	if FFlagExpChatWindowStatusEventFixes then
		self.props.timer:stop()
		self.props.textTimer:stop()

		if self.ChatWindowStatusStore.getCurrentChatWindowState(false) ~= "closed" then
			self.ChatWindowStatusStore.setClosedTimerStarted(os.clock())
		end
	end

	if self.debugKeybindConnection then
		self.debugKeybindConnection:Disconnect()
		self.debugKeybindConnection = nil
	end

	if self.debugInjectionThread ~= nil then
		task.cancel(self.debugInjectionThread)
		self.debugInjectionThread = nil
	end

	self.disposeBackgroundEffect()
	self.disposeTextEffect()

	self.textTransparencyMotor:destroy()
	self.backgroundTransparencyMotor:destroy()

	if getFFlagExpChatTriggerWindowStatusEvent() and self.localPlayerLeavingConnection then
		self.localPlayerLeavingConnection:Disconnect()
	end

	if FFlagExpChatUseChatConfigStore and self.disposeChatWindowSettingsEffect then
		self.disposeChatWindowSettingsEffect()
	end

	if FFlagExpChatUseChatConfigStore and self.disposeChatInputBarSettingsEffect then
		self.disposeChatInputBarSettingsEffect()
	end

	if self.disposeChatStatusEffect then
		self.disposeChatStatusEffect()
	end

	if FFlagExpChatPresetChatEnabled and self.disposePresetFlyOutAvailableEffect then
		self.disposePresetFlyOutAvailableEffect()
	end
end

return extended
