local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local FocusUtils = require(ExpChatParent.Chrome).FocusUtils
local Otter = require(ExpChatParent.Otter)
local ReactFocusNavigation = require(ExpChatParent.ReactFocusNavigation)
local Roact = require(ExpChatParent.Roact)
local Signals = require(ExpChatParent.Signals)
local SocialUpsell = require(ExpChatParent.SocialUpsell)
local createEffect = Signals.createEffect
local SharedFlags = require(ExpChatParent.SharedFlags)
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local UIBlox = require(ExpChatParent.UIBlox)
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local SelectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local CursorProvider = UIBlox.App.SelectionCursor.CursorProvider
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local Foundation = require(ExpChatParent.Foundation)
local ChatInput = require(ExpChat.ChatInput)
local ChatWindow = require(ExpChat.ChatWindow)
local ChannelBar = require(ExpChat.ChannelBar)
local Config = require(ExpChat.Config)
local EnableChatButton = require(ExpChat.EnableChatButton)
local FriendsChatMain = require(ExpChatParent.FriendsChat.FriendsChatMain)
local ChatPlatformProvider = require(ExpChat.ChatPlatform.ChatPlatformProvider)
local FriendsChatDependencyBridge = require(ExpChat.FriendsChatDependencyBridge)
local GetFriendsChatRealtimeStore = require(ExpChatParent.FriendsChat.GetFriendsChatRealtimeStore)
local PresetChatTray = require(ExpChat.PresetChat.PresetChatTray)
local PresetChatButton = require(ExpChat.PresetChat.PresetChatButton)
local PresetChatFlyOut = require(ExpChat.PresetChat.PresetChatFlyOut)
local PresetChatGate = require(ExpChat.PresetChat.PresetChatGate)
local Constants = require(ExpChat.PresetChat.Constants)
local GetChatConfigurationStore = require(ExpChat.Stores.GetChatConfigurationStore)
local GetChatStatusStore = require(ExpChat.Stores.GetChatStatusStore)
local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)
local Timer = require(ExpChat.Timer)
local SpatialUI = require(ExpChat.SpatialUI)
local ClientSettingsUtility = require(ExpChat.ClientSettings.ClientSettingsUtility)
local canPlatformEnableChat = require(ExpChat.canPlatformEnableChat)
local isChatRegionLocked = require(ExpChat.isChatRegionLocked)
local showChatEnabledUI = require(ExpChat.showChatEnabledUI)
local AppChat = ExpChatParent.AppChat
local GetConversationMessageStore = require(AppChat.GetConversationMessageStore)
local GetConversationMessageListStore = require(AppChat.GetConversationMessageListStore)
local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)
local FFlagExpChatEnableFocusNavigation = require(ExpChat.Flags.FFlagExpChatEnableFocusNavigation)
local FFlagExpChatFocusChannelBarSupport = require(ExpChat.Flags.FFlagExpChatFocusChannelBarSupport)
local FFlagExpChatTransparentFocusSupport = require(ExpChat.Flags.FFlagExpChatTransparentFocusSupport)
local FFlagExpChatDictationFadeOverride = require(ExpChat.Flags.FFlagExpChatDictationFadeOverride)
local getFFlagExpChatEnableChannelTabsUI = require(ExpChat.Flags.getFFlagExpChatEnableChannelTabsUI)
local getFFlagExpChatConditionallyMountAppLayout = require(ExpChat.Flags.getFFlagExpChatConditionallyMountAppLayout)
local FFlagExpChatEnableV2ChatWindow = require(ExpChat.Flags.FFlagExpChatEnableV2ChatWindow)
local FFlagExpChatKeepV2PoolMounted = require(ExpChat.Flags.FFlagExpChatKeepV2PoolMounted)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local FFlagExpChatPresetChatSendEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatSendEnabled
local FFlagExpChatUniverseChatPresetEnabled = require(ExpChat.Flags.FFlagExpChatUniverseChatPresetEnabled)
local FFlagExpChatPresetChatGamepadEnabled = require(ExpChat.Flags.FFlagExpChatPresetChatGamepadEnabled)
local FFlagAEGIS2EnableGatesForExpChat = require(ExpChat.Flags.FFlagAEGIS2EnableGatesForExpChat)
local FFlagDebugForceEnableChatButtonOn = require(ExpChat.Flags.FFlagDebugForceEnableChatButtonOn)
local FFlagExpChatUseMessagesStore = SharedFlags.FFlagExpChatUseMessagesStore
local FFlagExpChatUseChatConfigStore = SharedFlags.FFlagExpChatUseChatConfigStore
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab
local FFlagExpChatNewInputBar = require(ExpChat.Flags.FFlagExpChatNewInputBar)
local v66 = game:DefineFastFlag("ExpChatPresetButtonOldInputBarV2", false)
local v67 = game:DefineFastFlag("ExpChatPresetFixChatHotkey", false)
local v68 = game:DefineFastFlag("ExpChatFixTopPaddingColor", false)
local v69 = game:DefineFastFlag("ExpChatPresetChatFixesEnabled", false)
local FFlagDebugFriendsChat = require(ExpChatParent.FriendsChat.FFlagDebugFriendsChat)
local FFlagDebugExpChatPerf = require(ExpChat.Flags.FFlagDebugExpChatPerf)
local FStringDebugFriendsChatConversationId = require(ExpChatParent.FriendsChat.FStringDebugFriendsChatConversationId)
local manuallyInvokeAmpUpsell = SocialUpsell.Utils.manuallyInvokeAmpUpsell
local isInExperienceUIVREnabled = require(ExpChatParent.SharedExperimentDefinition).isInExperienceUIVREnabled
local getFFlagExpChatTriggerWindowStatusEvent = require(ExpChat.Flags.getFFlagExpChatTriggerWindowStatusEvent)
local v76 = if not isInExperienceUIVREnabled then nil else {
	DEFAULT = UDim2.fromScale(0.95, 0.94),
	WITH_CHANNEL_BAR = UDim2.fromScale(0.95, 0.78),
	WITH_CHATINPUT_BAR = UDim2.fromScale(0.95, 0.76),
	WITH_CHANNEL_CHATINPUT_BAR = UDim2.fromScale(0.95, 0.6098)
}
local GetFocusNavigationStore = require(ExpChat.Stores.GetFocusNavigationStore)
local GetTransparencyStore = require(ExpChat.Stores.GetTransparencyStore)
local GetChatWindowStatusStore = require(ExpChat.Stores.GetChatWindowStatusStore)

local function PresetChatInputRow(p1) -- line: 107
	-- upvalues: Config (copy), Foundation (copy), Roact (copy), v69 (copy), Constants (copy), PresetChatButton (copy), PresetChatFlyOut (copy), EnableChatButton (copy), v67 (copy), ChatInput (copy)
	local v84 = not p1.showEnableChatButton and 47 or Config.PresetChat.ButtonWidth
	local v85 = if not p1.showEnableChatButton then Foundation.Enums.InputSize.Medium else Foundation.Enums.InputSize.Small
	local v86 = not p1.showEnableChatButton and 3 or 5

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = 3,
		ZIndex = 2,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		Visible = p1.isChatInputBarVisible or p1.showEnableChatButton
	}, {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 0)
		}),
		PresetButton = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			ClipsDescendants = false,
			LayoutOrder = 1,
			BackgroundColor3 = p1.backgroundColor3,
			BackgroundTransparency = p1.transparencyValue:map(function(n1: number) -- line: 131
				-- upvalues: p1 (copy)
				return p1.backgroundTransparency + n1 * (1 - p1.backgroundTransparency)
			end),
			Size = UDim2.new(0, v84, 1, 0),
			Visible = if not v69 then nil else p1.isChatWindowVisible or p1.isChatInputBarVisible
		}, {
			ButtonOrFlyOut = Roact.createElement("CanvasGroup", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, v86, 0.5, not v69 and -1 or 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				GroupTransparency = p1.transparencyValue
			}, {
				Content = if p1.presetLayoutMode ~= Constants.LayoutMode.Tray then Roact.createElement(PresetChatFlyOut, {
					buttonIsCircular = false,
					addTopPadding = p1.isChatWindowVisible,
					textChannel = p1.targetTextChannel,
					buttonSize = v85
				}) else Roact.createElement(PresetChatButton, {
					isCircular = false,
					size = v85
				})
			})
		}),
		FillArea = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, -v84, 0, 0)
		}, {
			EnableChatButton = if not p1.showEnableChatButton then nil else Roact.createElement(EnableChatButton, {
				chatWindowSettings = p1.chatWindowSettings,
				transparencyValue = p1.transparencyValue,
				addTopPadding = p1.isChatWindowVisible,
				onHovered = p1.onHovered,
				onUnhovered = p1.onUnhovered,
				isSpatialUIEnabled = p1.isSpatialUIEnabled,
				visible = p1.isChatWindowVisible or p1.isChatInputBarVisible,
				onActivated = p1.onEnableChatActivated
			}),
			InputBar = if not v67 and not p1.isChatInputBarVisible then nil else Roact.createElement(ChatInput, {
				addTopPadding = p1.isChatWindowVisible,
				onSendChat = p1.onSendChat,
				onSendGlobalChat = p1.onSendGlobalChat,
				transparencyValue = p1.transparencyValue,
				canLocalUserChat = p1.canLocalUserChat,
				resetTargetChannel = p1.resetTargetChannel,
				visible = p1.isChatInputBarVisible,
				onAbsoluteSizeChanged = p1.onAbsoluteSizeChanged,
				onAbsolutePositionChanged = p1.onAbsolutePositionChanged,
				chatWindowSettings = p1.chatWindowSettings,
				isChannelBarVisible = p1.isChannelBarVisible,
				isSpatialUIEnabled = p1.isSpatialUIEnabled
			})
		})
	})
end

local v81 = Roact.PureComponent:extend("AppLayout")

v81.defaultProps = {
	addTopPadding = true,
	canLocalUserChat = false,
	isChatInputBarVisible = true,
	isChatWindowVisible = true,
	isChannelBarVisible = false,
	LayoutOrder = 1,
	mutedUserIds = nil,
	onSendChat = nil,
	onSendGlobalChat = nil,
	isSpatialUIEnabled = false,
	textTimer = Timer.new(Config.ChatWindowTextFadeOutTime),
	timer = Timer.new(Config.ChatWindowBackgroundFadeOutTime),
	canPlatformEnableChat = canPlatformEnableChat
}

local t1 = {
	frequency = 1.25,
	dampingRatio = 1
}

function v81.init(p2) -- line: 228
	-- upvalues: FFlagDebugFriendsChat (copy), FFlagDebugExpChatPerf (copy), UserInputService (copy), Roact (copy), Otter (copy), GetTransparencyStore (copy), getFFlagExpChatTriggerWindowStatusEvent (copy), GetChatWindowStatusStore (copy), Players (copy), TextChatService (copy), FFlagExpChatUseChatConfigStore (copy), GetChatConfigurationStore (copy), FFlagExpChatTransparentFocusSupport (copy), FFlagExpChatDictationFadeOverride (copy), t1 (copy), createEffect (copy), FFlagAEGIS2EnableGatesForExpChat (copy), GetChatStatusStore (copy), FFlagExpChatPresetChatEnabled (copy), GetPresetChatStore (copy), Constants (copy), FFlagExpChatPresetChatGamepadEnabled (copy), FFlagExpChatPresetChatSendEnabled (copy), FFlagExpChatUniverseChatPresetEnabled (copy), FFlagExpChatEnableFocusNavigation (copy), ReactFocusNavigation (copy), FFlagExpChatFocusChannelBarSupport (copy), GetFocusNavigationStore (copy), FocusUtils (copy)
	p2.state = {}

	if FFlagDebugFriendsChat or FFlagDebugExpChatPerf then
		p2.debugInjectionThread = nil
		p2.debugKeybindConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed) -- line: 236
			-- upvalues: p2 (copy)
			if gameProcessed then
				return
			end

			if input.KeyCode == Enum.KeyCode.K and input:IsModifierKeyDown(Enum.ModifierKey.Ctrl) then
				p2:debugInjectFakeMessages()
			end
		end)
	end

	local v88, v89 = Roact.createBinding(0)

	p2.transparencyValue = v88
	p2.updateBackgroundTransparency = v89
	p2.backgroundTransparencyMotor = Otter.createSingleMotor(0)
	p2.backgroundTransparencyMotor:onStep(p2.updateBackgroundTransparency)

	local v90, v91 = Roact.createBinding(0)

	p2.textTransparencyValue = v90
	p2.updateTextTransparencyValue = v91
	p2.textTransparencyMotor = Otter.createSingleMotor(0)
	p2.textTransparencyMotor:onStep(p2.updateTextTransparencyValue)

	local v92 = GetTransparencyStore(false)

	p2.ChatWindowStatusStore = if not getFFlagExpChatTriggerWindowStatusEvent() then nil else GetChatWindowStatusStore(false)

	if getFFlagExpChatTriggerWindowStatusEvent() then
		p2.localPlayerLeavingConnection = Players.PlayerRemoving:Connect(function(player) -- line: 260
			-- upvalues: Players (copy), p2 (copy), TextChatService (copy)
			if player == Players.LocalPlayer then
				p2.ChatWindowStatusStore.setPreviousChatWindowState(p2.ChatWindowStatusStore.getCurrentChatWindowState(false))

				local v116 = p2.ChatWindowStatusStore.getDurationUpdates(false)

				TextChatService:SendExpChatWindowStatusChange(v116.closedDuration, v116.openDuration, v116.backgroundIdleDuration, v116.textIdleDuration)
			end
		end)
	end

	if FFlagExpChatUseChatConfigStore then
		p2.ChatConfigurationStore = GetChatConfigurationStore(false)
	end

	function p2.resetBackgroundTransparency() -- line: 283
		-- upvalues: FFlagExpChatTransparentFocusSupport (copy), FFlagExpChatDictationFadeOverride (copy), v92 (copy), p2 (copy), Otter (copy), getFFlagExpChatTriggerWindowStatusEvent (copy), t1 (copy)
		local v117 = if not FFlagExpChatTransparentFocusSupport and not FFlagExpChatDictationFadeOverride then v92.getIsTextBoxFocused(false) else v92.getIsFocused(false)

		p2.backgroundTransparencyMotor:setGoal(Otter.instant(0))
		p2.props.timer:stop()

		if v117 == false and p2.props.isSpatialUIEnabled == false then
			p2.props.timer:start():andThen(function() -- line: 292
				-- upvalues: getFFlagExpChatTriggerWindowStatusEvent (copy), p2 (copy), Otter (copy), t1 (copy)
				if getFFlagExpChatTriggerWindowStatusEvent() then
					p2.ChatWindowStatusStore.setBackgroundTimerStarted(os.clock())
				end

				p2.backgroundTransparencyMotor:setGoal(Otter.spring(1, t1))
			end)
		end
	end
	function p2.resetTextTransparency() -- line: 301
		-- upvalues: FFlagExpChatTransparentFocusSupport (copy), FFlagExpChatDictationFadeOverride (copy), v92 (copy), p2 (copy), Otter (copy), getFFlagExpChatTriggerWindowStatusEvent (copy), t1 (copy)
		local v118 = if not FFlagExpChatTransparentFocusSupport and not FFlagExpChatDictationFadeOverride then v92.getIsTextBoxFocused(false) else v92.getIsFocused(false)

		p2.textTransparencyMotor:setGoal(Otter.instant(0))
		p2.props.textTimer:stop()

		if v118 == false then
			p2.props.textTimer:start():andThen(function() -- line: 310
				-- upvalues: getFFlagExpChatTriggerWindowStatusEvent (copy), p2 (copy), Otter (copy), t1 (copy)
				if getFFlagExpChatTriggerWindowStatusEvent() then
					p2.ChatWindowStatusStore.setTextTimerStarted(os.clock())
				end

				p2.textTransparencyMotor:setGoal(Otter.spring(1, t1))
			end)
		end
	end

	p2.disposeBackgroundEffect = createEffect(function(p3) -- line: 318
		-- upvalues: v92 (copy), p2 (copy)
		v92.getLastActivity(p3)
		p2.resetBackgroundTransparency()
		p2.resetTextTransparency()
	end)
	p2.disposeTextEffect = createEffect(function(p4) -- line: 324
		-- upvalues: v92 (copy), p2 (copy)
		v92.getLastMessageActivity(p4)
		p2.resetTextTransparency()
	end)

	if FFlagAEGIS2EnableGatesForExpChat then
		p2.disposeChatStatusEffect = createEffect(function(p5) -- line: 330
			-- upvalues: GetChatStatusStore (copy), p2 (copy)
			local v122 = GetChatStatusStore(p5).getChatStatus(p5)

			p2:setState({
				chatStatus = v122
			})
		end)
	end

	if FFlagExpChatPresetChatEnabled then
		p2.disposePresetFlyOutAvailableEffect = createEffect(function(p6) -- line: 341
			-- upvalues: GetPresetChatStore (copy), Constants (copy), FFlagExpChatPresetChatGamepadEnabled (copy), UserInputService (copy), p2 (copy), FFlagExpChatPresetChatSendEnabled (copy), FFlagExpChatUniverseChatPresetEnabled (copy)
			local v124 = GetPresetChatStore(p6)
			local v125 = v124.getIsEnabled(p6)
			local v126 = v124.getAccessLevel(p6)
			local v127 = v124.getLayoutModeOverride(p6)
			local v128 = if v127 ~= Constants.LayoutMode.Tray and v127 ~= Constants.LayoutMode.FlyOut then if not FFlagExpChatPresetChatGamepadEnabled or UserInputService.PreferredInput ~= Enum.PreferredInput.Gamepad then if not UserInputService.TouchEnabled or UserInputService.MouseEnabled then Constants.LayoutMode.FlyOut else Constants.LayoutMode.Tray else Constants.LayoutMode.FlyOut else v127

			p2:setState({
				isPresetFlyOutAvailable = v125 and (FFlagExpChatPresetChatSendEnabled and (v126 == Constants.AccessLevel.Enabled and (p2.props.targetTextChannel ~= nil or FFlagExpChatUniverseChatPresetEnabled))),
				presetLayoutMode = v128
			})
		end)
	end

	function p2.onAbsolutePositionChanged(p7, p8) -- line: 374
		p8.AbsolutePositionWrite = p7.AbsolutePosition
	end
	function p2.onAbsoluteSizeChanged(p9, p10) -- line: 378
		p10.AbsoluteSizeWrite = p9.AbsoluteSize
	end

	p2.onChatFrameLayoutChanged = if not FFlagExpChatPresetChatEnabled then nil else function(p11) -- line: 383
		-- upvalues: GetPresetChatStore (copy)
		local v134 = p11.AbsolutePosition.Y + p11.AbsoluteSize.Y

		GetPresetChatStore(false).setChatWindowBottomY(v134)
	end

	if FFlagExpChatEnableFocusNavigation then
		p2.focusNavigationService = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
		p2.topBorderRef = if not FFlagExpChatFocusChannelBarSupport then nil else Roact.createRef()

		function p2.onContainerSelectionChanged(p12, _, _, p15) -- line: 395
			-- upvalues: GetFocusNavigationStore (copy), FFlagExpChatTransparentFocusSupport (copy), v92 (copy), FFlagExpChatFocusChannelBarSupport (copy), p2 (copy), FocusUtils (copy)
			if p15 == nil or not p15:IsDescendantOf(p12) then
				GetFocusNavigationStore(false).unfocusChatInputBar()

				if FFlagExpChatTransparentFocusSupport then
					v92.clearWindowFocusInput()

					return
				end
			else
				if FFlagExpChatTransparentFocusSupport then
					v92.setWindowFocusInput()
				end

				if FFlagExpChatFocusChannelBarSupport and p15 == p2.topBorderRef.current then
					FocusUtils.FocusOnChrome(function() -- line: 409
						-- upvalues: GetFocusNavigationStore (copy)
						GetFocusNavigationStore(false).unfocusChatInputBar()
					end, "chat")
				end
			end
		end

		if not FFlagExpChatFocusChannelBarSupport then
			function p2.onBorderSelectionChanged(_, p17, _, _) -- line: 418
				-- upvalues: FocusUtils (copy), GetFocusNavigationStore (copy)
				if p17 then
					FocusUtils.FocusOnChrome(function() -- line: 420
						-- upvalues: GetFocusNavigationStore (copy)
						GetFocusNavigationStore(false).unfocusChatInputBar()
					end, "chat")
				end
			end
		end
	end
end
function v81.didMount(p20) -- line: 429
	-- upvalues: getFFlagExpChatTriggerWindowStatusEvent (copy), Otter (copy), t1 (copy)
	p20.props.timer:start():andThen(function() -- line: 430
		-- upvalues: getFFlagExpChatTriggerWindowStatusEvent (copy), p20 (copy), Otter (copy), t1 (copy)
		if getFFlagExpChatTriggerWindowStatusEvent() then
			p20.ChatWindowStatusStore.setBackgroundTimerStarted(os.clock())
		end

		p20.backgroundTransparencyMotor:setGoal(Otter.spring(1, t1))
	end)
	p20.props.textTimer:start():andThen(function() -- line: 437
		-- upvalues: getFFlagExpChatTriggerWindowStatusEvent (copy), p20 (copy), Otter (copy), t1 (copy)
		if getFFlagExpChatTriggerWindowStatusEvent() then
			p20.ChatWindowStatusStore.setTextTimerStarted(os.clock())
		end

		p20.textTransparencyMotor:setGoal(Otter.spring(1, t1))
	end)
end
function v81.render(p21) -- line: 445
	-- upvalues: getFFlagExpChatTriggerWindowStatusEvent (copy), FFlagExpChatUseChatConfigStore (copy), ClientSettingsUtility (copy), FFlagExpChatEnableFriendsTab (copy), FFlagAEGIS2EnableGatesForExpChat (copy), showChatEnabledUI (copy), isInExperienceUIVREnabled (copy), getFFlagExpChatConditionallyMountAppLayout (copy), getFFlagExpChatEnableChannelTabsUI (copy), v76 (copy), Config (copy), FFlagDebugForceEnableChatButtonOn (copy), isChatRegionLocked (copy), v66 (copy), FFlagExpChatPresetChatEnabled (copy), Roact (copy), FFlagExpChatEnableFocusNavigation (copy), FFlagExpChatFocusChannelBarSupport (copy), v68 (copy), FFlagExpChatEnableV2ChatWindow (copy), FFlagExpChatKeepV2PoolMounted (copy), ChatWindow (copy), FFlagExpChatUseMessagesStore (copy), FFlagExpChatPresetChatSendEnabled (copy), PresetChatGate (copy), Constants (copy), PresetChatTray (copy), FFlagExpChatNewInputBar (copy), PresetChatInputRow (copy), manuallyInvokeAmpUpsell (copy), ChatInput (copy), FriendsChatDependencyBridge (copy), FriendsChatMain (copy), EnableChatButton (copy), v69 (copy), PresetChatButton (copy), PresetChatFlyOut (copy), v67 (copy), ChannelBar (copy), SpatialUI (copy), ChatPlatformProvider (copy), ReactFocusNavigation (copy), SelectionCursorProvider (copy), CursorProvider (copy), withSelectionCursorProvider (copy), CursorKind (copy)
	if getFFlagExpChatTriggerWindowStatusEvent() then
		if p21.props.isChatWindowVisible or p21.props.isChatInputBarVisible then
			p21.ChatWindowStatusStore.setOpenTimerStarted(os.clock())
		else
			p21.ChatWindowStatusStore.setClosedTimerStarted(os.clock())
		end
	end

	local v95 = if not FFlagExpChatUseChatConfigStore or not p21.ChatConfigurationStore then p21.props.chatWindowSettings else p21.ChatConfigurationStore.getChatWindowSettings(false)
	local v96 = ClientSettingsUtility.getBackgroundTransparency(v95, p21.props.clientSettings)
	local v97 = ClientSettingsUtility.getBackgroundColor(v95, p21.props.clientSettings)
	local u98 = nil
	local v99 = FFlagExpChatEnableFriendsTab and p21.props.selectedTabType == "FriendsChat"
	local v100 = not v99
	local chatStatus = nil
	local isChatInputBarVisible = p21.props.isChatInputBarVisible

	if FFlagAEGIS2EnableGatesForExpChat then
		chatStatus = p21.state.chatStatus
		isChatInputBarVisible = isChatInputBarVisible and showChatEnabledUI(chatStatus)
	end

	if isInExperienceUIVREnabled then
		if p21.props.isSpatialUIEnabled then
			local v103 = getFFlagExpChatConditionallyMountAppLayout() and (getFFlagExpChatEnableChannelTabsUI() and p21.props.isChannelBarVisible)

			u98 = if not v103 or not isChatInputBarVisible then if not v103 or isChatInputBarVisible then if v103 or not isChatInputBarVisible then v76.DEFAULT else v76.WITH_CHATINPUT_BAR else v76.WITH_CHANNEL_BAR else v76.WITH_CHANNEL_CHATINPUT_BAR
		else
			u98 = UDim2.fromScale(Config.ChatWindowSize.X.Scale * v95.WidthScale, Config.ChatWindowSize.Y.Scale * v95.HeightScale)
		end
	end

	local v104 = FFlagDebugForceEnableChatButtonOn or FFlagAEGIS2EnableGatesForExpChat and (not isChatRegionLocked() and (p21.props.canPlatformEnableChat() and chatStatus == "AgeVerificationRequired"))
	local v105 = v66 and (FFlagExpChatPresetChatEnabled and p21.state.isPresetFlyOutAvailable)
	local v106 = FFlagExpChatPresetChatEnabled and (p21.state.isPresetFlyOutAvailable and (not v104 and not isChatInputBarVisible))

	local function v107(p22) -- line: 518
		-- upvalues: Roact (copy), p21 (copy), FFlagExpChatEnableFocusNavigation (copy), isInExperienceUIVREnabled (copy), u98 (ref), Config (copy), v95 (copy), FFlagExpChatPresetChatEnabled (copy), v97 (copy), v96 (copy), getFFlagExpChatEnableChannelTabsUI (copy), FFlagExpChatFocusChannelBarSupport (copy), v99 (copy), v68 (copy), v100 (copy), getFFlagExpChatConditionallyMountAppLayout (copy), FFlagExpChatEnableV2ChatWindow (copy), FFlagExpChatKeepV2PoolMounted (copy), ChatWindow (copy), FFlagExpChatUseMessagesStore (copy), FFlagExpChatPresetChatSendEnabled (copy), PresetChatGate (copy), Constants (copy), PresetChatTray (copy), FFlagExpChatNewInputBar (copy), v105 (copy), PresetChatInputRow (copy), isChatInputBarVisible (ref), v104 (copy), manuallyInvokeAmpUpsell (copy), ChatInput (copy), FriendsChatDependencyBridge (copy), FriendsChatMain (copy), EnableChatButton (copy), v106 (copy), v69 (copy), PresetChatButton (copy), PresetChatFlyOut (copy), v67 (copy), ChannelBar (copy), SpatialUI (copy), FFlagExpChatEnableFriendsTab (copy), ChatPlatformProvider (copy)
		local v144 = Roact.createElement("Frame", {
			AnchorPoint = p21.props.chatLayoutAlignment.AnchorPoint,
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 1,
			Position = p21.props.chatLayoutAlignment.Position,
			SelectionBehaviorDown = if not FFlagExpChatEnableFocusNavigation then nil else Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = if not FFlagExpChatEnableFocusNavigation then nil else Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = if not FFlagExpChatEnableFocusNavigation then nil else Enum.SelectionBehavior.Stop,
			SelectionBehaviorUp = if not FFlagExpChatEnableFocusNavigation then nil else Enum.SelectionBehavior.Stop,
			SelectionGroup = not not FFlagExpChatEnableFocusNavigation or nil,
			Size = if not isInExperienceUIVREnabled then if not p21.props.isSpatialUIEnabled then UDim2.fromScale(Config.ChatWindowSize.X.Scale * v95.WidthScale, Config.ChatWindowSize.Y.Scale * v95.HeightScale) else UDim2.fromScale(0.95, 0.68) else u98,
			[Roact.Change.AbsoluteSize] = if not FFlagExpChatPresetChatEnabled then nil else p21.onChatFrameLayoutChanged,
			[Roact.Change.AbsolutePosition] = if not FFlagExpChatPresetChatEnabled then nil else p21.onChatFrameLayoutChanged,
			[Roact.Event.SelectionChanged] = p21.onContainerSelectionChanged
		}, {
			uiSizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = if not p21.props.isSpatialUIEnabled then Vector2.new(Config.ChatWindowMaxWidth, 1e999) else Vector2.new(1e999, 1e999)
			}),
			layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = p21.props.chatLayoutAlignment.UIListLayoutVerticalAlignment
			}),
			topBorder = Roact.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Image = "rbxasset://textures/ui/TopRoundedRect8px.png",
				ImageColor3 = v97,
				ImageTransparency = p21.transparencyValue:map(function(n2: number) -- line: 560
					-- upvalues: v96 (copy)
					local v152 = v96

					return v152 + n2 * (1 - v152)
				end),
				LayoutOrder = 1,
				SelectionImageObject = p22,
				Selectable = not not FFlagExpChatEnableFocusNavigation or nil,
				ScaleType = Enum.ScaleType.Slice,
				Size = UDim2.new(1, 0, 0, 8),
				SliceCenter = Rect.new(8, 8, 24, 32),
				Visible = if not getFFlagExpChatEnableChannelTabsUI() then p21.props.isChatWindowVisible or p21.props.isChatInputBarVisible else (p21.props.isChatWindowVisible or p21.props.isChatInputBarVisible) and not p21.props.isChannelBarVisible,
				[Roact.Event.MouseEnter] = p21.props.onHovered,
				[Roact.Event.MouseLeave] = p21.props.onUnhovered,
				[Roact.Event.SelectionChanged] = if not FFlagExpChatFocusChannelBarSupport then p21.onBorderSelectionChanged else nil,
				[Roact.Ref] = if not FFlagExpChatFocusChannelBarSupport then nil else p21.topBorderRef
			}, {
				uiSizeConstraint = Roact.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(Config.ChatWindowMaxWidth, 1e999)
				})
			}),
			topPadding = Roact.createElement("Frame", {
				LayoutOrder = 1,
				Size = if not v99 then UDim2.new(1, 0, 0, 8) else UDim2.fromScale(1, 0),
				Visible = not not getFFlagExpChatEnableChannelTabsUI() and p21.props.isChannelBarVisible,
				BackgroundTransparency = p21.transparencyValue:map(function(n3: number) -- line: 593
					-- upvalues: v96 (copy)
					local v154 = v96

					return v154 + n3 * (1 - v154)
				end),
				BackgroundColor3 = if not v68 then v95.BackgroundColor3 else v97,
				BorderSizePixel = 0,
				[Roact.Event.MouseEnter] = p21.props.onHovered,
				[Roact.Event.MouseLeave] = p21.props.onUnhovered,
				ZIndex = 0
			}),
			chatWindow = if v100 then (not getFFlagExpChatConditionallyMountAppLayout() or (not not FFlagExpChatEnableV2ChatWindow and FFlagExpChatKeepV2PoolMounted and true or p21.props.isChatWindowVisible)) and Roact.createElement(ChatWindow, {
				LayoutOrder = 2,
				size = UDim2.fromScale(1, 1),
				transparencyValue = p21.transparencyValue,
				textTransparency = p21.textTransparencyValue,
				onHovered = p21.props.onHovered,
				onUnhovered = p21.props.onUnhovered,
				mutedUserIds = p21.props.mutedUserIds,
				canLocalUserChat = if not FFlagExpChatUseMessagesStore then p21.props.canLocalUserChat else nil,
				activateWhisperMode = p21.props.activateWhisperMode,
				resetTargetChannel = p21.props.resetTargetChannel,
				visible = p21.props.isChatWindowVisible,
				onAbsoluteSizeChanged = p21.onAbsoluteSizeChanged,
				onAbsolutePositionChanged = p21.onAbsolutePositionChanged,
				chatWindowSettings = v95,
				showTranslationButton = p21.props.showTranslationButton,
				isChannelBarVisible = not not getFFlagExpChatEnableChannelTabsUI() and p21.props.isChannelBarVisible,
				isSpatialUIEnabled = p21.props.isSpatialUIEnabled
			}) else nil,
			presetChatTray = if not not v100 and (not not FFlagExpChatPresetChatEnabled and FFlagExpChatPresetChatSendEnabled) then Roact.createElement(PresetChatGate, {
				layoutMode = Constants.LayoutMode.Tray,
				targetTextChannel = p21.props.targetTextChannel
			}, {
				Tray = Roact.createElement(PresetChatTray, {
					textChannel = p21.props.targetTextChannel
				})
			}) else nil,
			chatInputBar = if not not v100 and not FFlagExpChatNewInputBar then if not v105 then Roact.createElement(ChatInput, {
				LayoutOrder = 3,
				addTopPadding = p21.props.isChatWindowVisible,
				onSendChat = p21.props.onSendChat,
				onSendGlobalChat = p21.props.onSendGlobalChat,
				transparencyValue = p21.transparencyValue,
				canLocalUserChat = if not FFlagExpChatUseMessagesStore then p21.props.canLocalUserChat else nil,
				resetTargetChannel = p21.props.resetTargetChannel,
				visible = isChatInputBarVisible,
				onAbsoluteSizeChanged = p21.onAbsoluteSizeChanged,
				onAbsolutePositionChanged = p21.onAbsolutePositionChanged,
				chatWindowSettings = v95,
				isChannelBarVisible = not not getFFlagExpChatEnableChannelTabsUI() and p21.props.isChannelBarVisible,
				isSpatialUIEnabled = p21.props.isSpatialUIEnabled
			}) else Roact.createElement(PresetChatInputRow, {
				transparencyValue = p21.transparencyValue,
				backgroundColor3 = v97,
				backgroundTransparency = v96,
				isChatWindowVisible = p21.props.isChatWindowVisible,
				isChatInputBarVisible = isChatInputBarVisible,
				targetTextChannel = p21.props.targetTextChannel,
				onSendChat = p21.props.onSendChat,
				onSendGlobalChat = p21.props.onSendGlobalChat,
				canLocalUserChat = if not FFlagExpChatUseMessagesStore then p21.props.canLocalUserChat else nil,
				resetTargetChannel = p21.props.resetTargetChannel,
				onAbsoluteSizeChanged = p21.onAbsoluteSizeChanged,
				onAbsolutePositionChanged = p21.onAbsolutePositionChanged,
				chatWindowSettings = v95,
				isChannelBarVisible = not not getFFlagExpChatEnableChannelTabsUI() and p21.props.isChannelBarVisible,
				isSpatialUIEnabled = p21.props.isSpatialUIEnabled,
				showEnableChatButton = v104,
				onHovered = p21.props.onHovered,
				onUnhovered = p21.props.onUnhovered,
				onEnableChatActivated = function() -- line: 669
					-- upvalues: manuallyInvokeAmpUpsell (copy)
					manuallyInvokeAmpUpsell("InExperienceTextChatUpsell")
				end,
				presetLayoutMode = p21.state.presetLayoutMode
			}) else nil,
			friendsChat = if not v99 or not p21.props.isChatWindowVisible then nil else Roact.createElement(FriendsChatDependencyBridge, {}, {
				friendsChatMain = Roact.createElement(FriendsChatMain, {
					parentLayoutOrder = 2,
					chatWindowSettings = v95,
					transparencyValue = p21.transparencyValue,
					textTransparency = p21.textTransparencyValue,
					isSpatialUIEnabled = p21.props.isSpatialUIEnabled,
					isChannelBarVisible = p21.props.isChannelBarVisible,
					onHovered = p21.props.onHovered,
					onUnhovered = p21.props.onUnhovered,
					onAbsoluteSizeChanged = p21.onAbsoluteSizeChanged,
					onAbsolutePositionChanged = p21.onAbsolutePositionChanged
				})
			}),
			enableChatButton = if not not v100 and (not FFlagExpChatNewInputBar and (not v105 and v104)) then Roact.createElement(EnableChatButton, {
				LayoutOrder = 3,
				chatWindowSettings = v95,
				transparencyValue = p21.transparencyValue,
				addTopPadding = p21.props.isChatWindowVisible,
				onHovered = p21.props.onHovered,
				onUnhovered = p21.props.onUnhovered,
				isSpatialUIEnabled = p21.props.isSpatialUIEnabled,
				visible = p21.props.isChatWindowVisible or p21.props.isChatInputBarVisible,
				onActivated = function() -- line: 731
					-- upvalues: manuallyInvokeAmpUpsell (copy)
					manuallyInvokeAmpUpsell("InExperienceTextChatUpsell")
				end
			}) else nil,
			chatInputRow = if not not v100 and FFlagExpChatNewInputBar then Roact.createElement("Frame", {
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = v97,
				BackgroundTransparency = p21.transparencyValue:map(function(n4: number) -- line: 740
					-- upvalues: v96 (copy)
					return v96 + n4 * (1 - v96)
				end),
				BorderSizePixel = 0,
				LayoutOrder = 3,
				Size = UDim2.fromScale(1, 0),
				Visible = not FFlagExpChatPresetChatEnabled or (p21.props.isChatWindowVisible or p21.props.isChatInputBarVisible),
				ZIndex = 2,
				[Roact.Event.MouseEnter] = p21.props.onHovered,
				[Roact.Event.MouseLeave] = p21.props.onUnhovered
			}, {
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
				presetFlyOutWrapper = if not FFlagExpChatPresetChatEnabled or not p21.state.isPresetFlyOutAvailable then nil else Roact.createElement("CanvasGroup", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					GroupTransparency = p21.transparencyValue,
					Size = if not v106 then UDim2.fromOffset(Config.PresetChat.ButtonWidth, 0) else UDim2.fromScale(1, 0),
					Visible = if not v69 then nil else p21.props.isChatWindowVisible or p21.props.isChatInputBarVisible
				}, {
					PresetEntry = if p21.state.presetLayoutMode ~= Constants.LayoutMode.Tray then Roact.createElement(PresetChatFlyOut, {
						addTopPadding = p21.props.isChatWindowVisible,
						fullWidthButton = v106,
						textChannel = p21.props.targetTextChannel
					}) else Roact.createElement(PresetChatButton, {
						baseTransparency = 0,
						targetTextChannel = p21.props.targetTextChannel
					})
				}),
				fillArea = if not v67 and v106 then nil else Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					AutomaticSize = if not v67 or not v106 then Enum.AutomaticSize.Y else Enum.AutomaticSize.None,
					Size = if not v67 or not v106 then UDim2.new(1, not p21.state.isPresetFlyOutAvailable and 0 or -(Config.PresetChat.ButtonWidth + 8), 0, 0) else UDim2.new(0, 0, 0, 0),
					Visible = if not v67 then nil else not v106
				}, {
					enableChatButton = if not v104 then nil else Roact.createElement(EnableChatButton, {
						chatWindowSettings = v95,
						transparencyValue = p21.transparencyValue,
						addTopPadding = p21.props.isChatWindowVisible,
						onHovered = p21.props.onHovered,
						onUnhovered = p21.props.onUnhovered,
						isSpatialUIEnabled = p21.props.isSpatialUIEnabled,
						visible = p21.props.isChatWindowVisible or p21.props.isChatInputBarVisible,
						onActivated = function() -- line: 819
							-- upvalues: manuallyInvokeAmpUpsell (copy)
							manuallyInvokeAmpUpsell("InExperienceTextChatUpsell")
						end
					}),
					chatInputBar = if not v67 and not isChatInputBarVisible then nil else Roact.createElement(ChatInput, {
						suppressOuterBackground = true,
						addTopPadding = p21.props.isChatWindowVisible,
						onSendChat = p21.props.onSendChat,
						onSendGlobalChat = p21.props.onSendGlobalChat,
						transparencyValue = p21.transparencyValue,
						canLocalUserChat = if not FFlagExpChatUseMessagesStore then p21.props.canLocalUserChat else nil,
						resetTargetChannel = p21.props.resetTargetChannel,
						visible = if not v67 then nil else isChatInputBarVisible,
						onAbsoluteSizeChanged = p21.onAbsoluteSizeChanged,
						onAbsolutePositionChanged = p21.onAbsolutePositionChanged,
						chatWindowSettings = v95,
						isChannelBarVisible = not not getFFlagExpChatEnableChannelTabsUI() and p21.props.isChannelBarVisible,
						isSpatialUIEnabled = p21.props.isSpatialUIEnabled,
						onHovered = p21.props.onHovered,
						onUnhovered = p21.props.onUnhovered
					})
				})
			}) else nil,
			channelBar = (not getFFlagExpChatConditionallyMountAppLayout() or p21.props.isChannelBarVisible) and Roact.createElement(ChannelBar, {
				LayoutOrder = not v99 and 4 or 100,
				size = UDim2.fromScale(1, 1),
				transparencyValue = p21.transparencyValue,
				onHovered = p21.props.onHovered,
				onUnhovered = p21.props.onUnhovered,
				chatWindowSettings = v95,
				visible = not not getFFlagExpChatEnableChannelTabsUI() and p21.props.isChannelBarVisible,
				topBorderRef = if not FFlagExpChatFocusChannelBarSupport then nil else p21.topBorderRef
			}),
			bottomBorder = if not v99 then Roact.createElement("ImageLabel", {
				Name = "bottomBorder",
				BackgroundTransparency = 1,
				Image = "rbxasset://textures/ui/BottomRoundedRect8px.png",
				ImageColor3 = v97,
				ImageTransparency = p21.transparencyValue:map(function(n5: number) -- line: 872
					-- upvalues: v96 (copy)
					local v157 = v96

					return v157 + n5 * (1 - v157)
				end),
				LayoutOrder = 5,
				ScaleType = Enum.ScaleType.Slice,
				Size = UDim2.new(1, 0, 0, 8),
				SliceCenter = Rect.new(8, 0, 24, 16),
				Visible = p21.props.isChatWindowVisible or p21.props.isChatInputBarVisible,
				[Roact.Event.MouseEnter] = p21.props.onHovered,
				[Roact.Event.MouseLeave] = p21.props.onUnhovered
			}, {
				uiSizeConstraint = Roact.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(Config.ChatWindowMaxWidth, 1e999)
				})
			}) else nil
		})

		return Roact.createElement(SpatialUI.Provider, {
			value = {
				isSpatialUIEnabled = p21.props.isSpatialUIEnabled
			}
		}, {
			appLayout = if not FFlagExpChatEnableFriendsTab then v144 else Roact.createElement(ChatPlatformProvider, {}, {
				appLayout = v144
			})
		})
	end

	if FFlagExpChatEnableFocusNavigation then
		return Roact.createElement(ReactFocusNavigation.FocusNavigationContext.Provider, {
			value = p21.focusNavigationService
		}, {
			CursorProvider = Roact.createElement(SelectionCursorProvider, {}, {
				NewCursorProvider = Roact.createElement(CursorProvider, {}, { withSelectionCursorProvider(function(p23) -- line: 911
					-- upvalues: v107 (copy), CursorKind (copy)
					return v107(p23(CursorKind.Invisible))
				end) })
			})
		})
	end

	return v107(nil)
end
function v81.debugInjectFakeMessages(p24) -- line: 929
	-- upvalues: FFlagExpChatEnableFriendsTab (copy), GetFriendsChatRealtimeStore (copy), FStringDebugFriendsChatConversationId (copy), GetConversationMessageStore (copy), GetConversationMessageListStore (copy), FFlagExpChatUseMessagesStore (copy), GetMessagesStore (copy)
	if p24.debugInjectionThread ~= nil then
		task.cancel(p24.debugInjectionThread)
		p24.debugInjectionThread = nil
	end

	local v109 = FFlagExpChatEnableFriendsTab and p24.props.selectedTabType == "FriendsChat"
	local v110 = GetFriendsChatRealtimeStore(false).getActiveConversationId(false) or FStringDebugFriendsChatConversationId

	if v109 and (v110 == nil or v110 == "") then
		return
	end

	p24.debugInjectionThread = task.spawn(function() -- line: 942
		-- upvalues: v109 (copy), GetConversationMessageStore (copy), GetConversationMessageListStore (copy), FFlagExpChatUseMessagesStore (copy), GetMessagesStore (copy), v110 (copy), p24 (copy)
		local v146 = if not v109 then nil else GetConversationMessageStore(false)
		local v147 = if not v109 then nil else GetConversationMessageListStore(false)
		local v148 = if v109 or not FFlagExpChatUseMessagesStore then nil else GetMessagesStore(false)

		for i = 1, 50 do
			if v109 then
				local v150 = `debug-fake-{ tostring(os.clock()) }-{ i }`

				v146.upsertMessages({
					[v150] = {
						type = "user",
						id = v150,
						content = `Fake friends-chat debug message #{ i }`,
						created_at = DateTime.now():ToIsoDate(),
						sender_user_id = (i - 1) % 5 + 1
					}
				})
				v147.prependMessages(v110, { v150 })
			elseif v148 ~= nil then
				v148.addSystemMessage(`Fake exp-chat debug message #{ i }`, "RBXGeneral", nil, nil, false)
			end

			if i < 50 then
				task.wait(0.1)
			end
		end

		p24.debugInjectionThread = nil
	end)
end
function v81.willUnmount(p25) -- line: 976
	-- upvalues: getFFlagExpChatTriggerWindowStatusEvent (copy), FFlagExpChatUseChatConfigStore (copy), FFlagAEGIS2EnableGatesForExpChat (copy), FFlagExpChatPresetChatEnabled (copy)
	if p25.debugKeybindConnection then
		p25.debugKeybindConnection:Disconnect()
		p25.debugKeybindConnection = nil
	end

	if p25.debugInjectionThread ~= nil then
		task.cancel(p25.debugInjectionThread)
		p25.debugInjectionThread = nil
	end

	p25.disposeBackgroundEffect()
	p25.disposeTextEffect()
	p25.textTransparencyMotor:destroy()
	p25.backgroundTransparencyMotor:destroy()

	if getFFlagExpChatTriggerWindowStatusEvent() and p25.localPlayerLeavingConnection then
		p25.localPlayerLeavingConnection:Disconnect()
	end

	if FFlagExpChatUseChatConfigStore and p25.disposeChatWindowSettingsEffect then
		p25.disposeChatWindowSettingsEffect()
	end

	if FFlagExpChatUseChatConfigStore and p25.disposeChatInputBarSettingsEffect then
		p25.disposeChatInputBarSettingsEffect()
	end

	if FFlagAEGIS2EnableGatesForExpChat and p25.disposeChatStatusEffect then
		p25.disposeChatStatusEffect()
	end

	if FFlagExpChatPresetChatEnabled and p25.disposePresetFlyOutAvailableEffect then
		p25.disposePresetFlyOutAvailableEffect()
	end
end

return v81
