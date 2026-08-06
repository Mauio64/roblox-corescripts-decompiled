local TextChatService = game:GetService("TextChatService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local SignalsReact = require(ExpChatParent.SignalsReact)
local Dictionary = require(ExpChatParent.llama).Dictionary
local List = require(ExpChatParent.llama).List
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local Config = require(ExpChat.Config)
local useInterpolatedClientSettings = require(ExpChat.ClientSettings.useInterpolatedClientSettings)
local GetChatStatusStore = require(ExpChat.Stores.GetChatStatusStore)
local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)
local GetGlobalChatTooltipStore = require(ExpChat.Stores.GetGlobalChatTooltipStore)
local GetChatTooltipStore = require(ExpChat.Stores.GetChatTooltipStore)
local UI = script:FindFirstAncestor("UI")
local ScrollingView = require(UI.ScrollingView)
local TranslatedTextMessage = require(UI.TranslatedTextMessage)
local TopBanner = require(UI.TopBanner)
local GlobalChatTooltip = require(UI.GlobalChatTooltip)
local isChatRegionLocked = require(ExpChat.isChatRegionLocked)
local showChatEnabledUI = require(ExpChat.showChatEnabledUI)
local useUserExperiment = require(ExpChatParent.RoactAppExperiment).useUserExperiment
local v23 = require(ExpChatParent.UserProfiles).Stores.VerifiedBadgeDisplayStore.get()
local FStringReportingIXPLayer = require(ExpChatParent.SharedFlags).FStringReportingIXPLayer
local GetFFlagEnableChatLineReporting = require(ExpChatParent.SharedFlags).GetFFlagEnableChatLineReporting
local GetFFlagMemoizeChatReportingMenu = require(ExpChatParent.SharedFlags).GetFFlagMemoizeChatReportingMenu
local getFFlagChatWindowUseCallbackOptimizations = require(ExpChat.Flags.getFFlagChatWindowUseCallbackOptimizations)
local FFlagExpChatEnableV2ChatWindow = require(ExpChat.Flags.FFlagExpChatEnableV2ChatWindow)
local FFlagAEGIS2EnableGatesForExpChat = require(ExpChat.Flags.FFlagAEGIS2EnableGatesForExpChat)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local FFlagExpChatTopBannerForPresetChatAccess = require(ExpChat.Flags.FFlagExpChatTopBannerForPresetChatAccess)
local useIsARButtonVisible = require(ExpChat.useIsARButtonVisible)
local FFlagEnableVerifiedBadgeStore = require(ExpChatParent.SharedFlags).FFlagEnableVerifiedBadgeStore
local EngineFeature = game:GetEngineFeature("EnableInExpChatRewrite")
local FFlagExpChatPerfTracking = require(ExpChatParent.SharedFlags).FFlagExpChatPerfTracking
local FFlagExpChatWindowMessageSourceRefactor = require(ExpChatParent.SharedFlags).FFlagExpChatWindowMessageSourceRefactor
local FFlagExpChatEnableFriendsTab = require(ExpChatParent.SharedFlags).FFlagExpChatEnableFriendsTab
local FFlagExpChatChannelTabRefactor = require(ExpChatParent.SharedFlags).FFlagExpChatChannelTabRefactor
local ExpChatPerfTracker = require(ExpChatParent.ChatUIPrimitives).Telemetry.ExpChatPerfTracker
local FFlagExpChatPerfTrackerTabName = require(ExpChatParent.ChatUIPrimitives).Flags.FFlagExpChatPerfTrackerTabName
local FFlagExpChatRewriteInline = require(ExpChat.Flags.FFlagExpChatRewriteInline)
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local FFlagExpChatUseUnifiedTooltipStore = ExpChatShared.Flags.FFlagExpChatUseUnifiedTooltipStore
local t1 = {
	LayoutOrder = 1,
	showTranslationButton = false,
	size = UDim2.fromScale(1, 1),
	messages = if not FFlagExpChatEnableV2ChatWindow then {} else nil,
	transparencyValue = if not GetFFlagMemoizeChatReportingMenu() then Config.ChatWindowBackgroundTransparency else React.createBinding(Config.ChatWindowBackgroundTransparency),
	textTransparency = React.createBinding(0),
	mutedUserIds = {},
	verifiedUserIds = {}
}

return (React.memo(function(p1) -- line: 68
	-- upvalues: Dictionary (copy), t1 (copy), useInterpolatedClientSettings (copy), FFlagExpChatPresetChatEnabled (copy), FFlagExpChatTopBannerForPresetChatAccess (copy), useIsARButtonVisible (copy), FFlagAEGIS2EnableGatesForExpChat (copy), GetChatStatusStore (copy), SignalsReact (copy), showChatEnabledUI (copy), FFlagExpChatUseUnifiedTooltipStore (copy), GetChatTooltipStore (copy), GetGlobalChatTooltipStore (copy), React (copy), GetFFlagMemoizeChatReportingMenu (copy), FFlagExpChatEnableV2ChatWindow (copy), GetMessagesStore (copy), List (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), GetFFlagEnableChatLineReporting (copy), useUserExperiment (copy), FStringReportingIXPLayer (copy), getFFlagChatWindowUseCallbackOptimizations (copy), FFlagExpChatWindowMessageSourceRefactor (copy), FFlagEnableVerifiedBadgeStore (copy), v23 (copy), TranslatedTextMessage (copy), EngineFeature (copy), FFlagExpChatRewriteInline (copy), FFlagExpChatPerfTracking (copy), FFlagExpChatChannelTabRefactor (copy), FFlagExpChatPerfTrackerTabName (copy), ExpChatPerfTracker (copy), Config (copy), FFlagExpChatEnableFriendsTab (copy), isChatRegionLocked (copy), TopBanner (copy), ScrollingView (copy), TextChatService (copy), GlobalChatTooltip (copy)
	local v46 = Dictionary.join(t1, p1)
	local chatWindowSettings = v46.chatWindowSettings
	local BackgroundTransparency = useInterpolatedClientSettings(chatWindowSettings).BackgroundTransparency
	local BackgroundColor3 = useInterpolatedClientSettings(chatWindowSettings).BackgroundColor3
	local v50 = nil
	local v51 = true

	if FFlagExpChatPresetChatEnabled and FFlagExpChatTopBannerForPresetChatAccess then
		v51 = useIsARButtonVisible()
	elseif FFlagAEGIS2EnableGatesForExpChat then
		local v52 = GetChatStatusStore(false)

		v50 = SignalsReact.useSignalState(v52.getChatStatus)
		v51 = showChatEnabledUI(v50)
	end

	local v54

	if FFlagExpChatUseUnifiedTooltipStore then
		local v53 = GetChatTooltipStore(false)

		v54 = SignalsReact.useSignalState(v53.getIsEligible("GlobalChatTooltip"))
	else
		local v55 = GetGlobalChatTooltipStore(false)

		v54 = SignalsReact.useSignalState(v55.getIsGlobalChatTooltipEligible)
	end

	if FFlagExpChatUseUnifiedTooltipStore then
		local setIsChatWindowOpen = GetChatTooltipStore(false).setIsChatWindowOpen

		React.useEffect(function() -- line: 97
			-- upvalues: setIsChatWindowOpen (copy), v46 (copy)
			setIsChatWindowOpen(v46.visible)

			return function() -- line: 99
				-- upvalues: setIsChatWindowOpen (copy)
				setIsChatWindowOpen(false)
			end
		end, {
			v46.visible,
			setIsChatWindowOpen
		})
	end

	local v57 = nil
	local u58 = nil

	if GetFFlagMemoizeChatReportingMenu() and not FFlagExpChatEnableV2ChatWindow then
		u58 = React.useRef(if not FFlagExpChatEnableV2ChatWindow then v46.messages else nil)
		React.useEffect(function() -- line: 109
			-- upvalues: u58 (ref), FFlagExpChatEnableV2ChatWindow (copy), v46 (copy)
			u58.current = if not FFlagExpChatEnableV2ChatWindow then v46.messages else nil
		end, { if not FFlagExpChatEnableV2ChatWindow then v46.messages else nil })
		v57 = React.useCallback(function() -- line: 113
			-- upvalues: u58 (ref)
			return u58.current
		end, {})
	end

	if FFlagExpChatEnableV2ChatWindow then
		v57 = React.useCallback(function() -- line: 119
			-- upvalues: GetMessagesStore (copy), v46 (copy), List (copy), GetFFlagTextChatEnableUniverseChatTabs (copy)
			local v69 = GetMessagesStore(false)
			local t2 = {
				windowMessagesInOrderByTabId = v69.getWindowMessagesInOrderByTabId(false),
				byMessageId = v69.getByMessageId(false),
				windowMessagesInOrder = v69.getWindowMessagesInOrder(false)
			}

			if not v46.isChannelBarVisible then
				return List.map(t2.windowMessagesInOrder, function(p2) -- line: 128
					-- upvalues: t2 (copy)
					return t2.byMessageId[p2]
				end)
			end

			if GetFFlagTextChatEnableUniverseChatTabs() then
				local selectedChannelName = v46.selectedChannelName

				if v46.targetTextChannel and t2.windowMessagesInOrderByTabId[v46.targetTextChannel.Name] then
					selectedChannelName = v46.targetTextChannel.Name
				end

				if selectedChannelName then
					return List.map(t2.windowMessagesInOrderByTabId[selectedChannelName] or {}, function(p3) -- line: 143
						-- upvalues: t2 (copy)
						return t2.byMessageId[p3]
					end)
				end

				return {}
			end

			if v46.targetTextChannel then
				return List.map(t2.windowMessagesInOrderByTabId[v46.targetTextChannel.Name] or {}, function(p4) -- line: 151
					-- upvalues: t2 (copy)
					return t2.byMessageId[p4]
				end)
			end

			return {}
		end, {
			v46.isChannelBarVisible,
			v46.targetTextChannel,
			if not GetFFlagTextChatEnableUniverseChatTabs() then nil else v46.selectedChannelName
		})
	end

	local v59 = not not GetFFlagEnableChatLineReporting() and useUserExperiment({ FStringReportingIXPLayer }, function(p5) -- line: 169
		-- upvalues: FStringReportingIXPLayer (copy)
		return (p5[FStringReportingIXPLayer] or {}).EnableChatLineReporting
	end)
	local v60 = React.useCallback(function(p6, p7) -- line: 175
		-- upvalues: v46 (copy)
		if type(p7) == "number" then
			return v46.transparencyValue
		end

		return p7:map(function(n1: number) -- line: 180
			-- upvalues: p6 (copy)
			return p6 + n1 * (1 - p6)
		end)
	end, if not getFFlagChatWindowUseCallbackOptimizations() then nil else { v46.transparencyValue })
	local v61 = React.useCallback(function(p8) -- line: 186
		-- upvalues: v46 (copy)
		v46.resetTargetChannel()

		local num = tonumber(p8.userId)

		if num then
			v46.activateWhisperMode(num)
		end
	end, if not getFFlagChatWindowUseCallbackOptimizations() then nil else {
		v46.resetTargetChannel,
		v46.activateWhisperMode
	})
	local v62 = if not FFlagExpChatEnableV2ChatWindow and not FFlagExpChatWindowMessageSourceRefactor then React.useCallback(function(p9) -- line: 206
		-- upvalues: Dictionary (copy), FFlagEnableVerifiedBadgeStore (copy), v23 (copy), v46 (copy), React (copy), TranslatedTextMessage (copy), EngineFeature (copy), v61 (copy), FFlagExpChatRewriteInline (copy)
		local v78 = Dictionary.map(p9, function(p10, p11) -- line: 207
			-- upvalues: FFlagEnableVerifiedBadgeStore (copy), v23 (copy), Dictionary (copy), v46 (copy), React (copy), TranslatedTextMessage (copy), EngineFeature (copy), v61 (copy), FFlagExpChatRewriteInline (copy)
			if p10.isVisibleInChatWindow then
				local v94 = if not FFlagEnableVerifiedBadgeStore then not not p10.userId and Dictionary.has(v46.verifiedUserIds, p10.userId) else not not p10.userId and v23.isBadgeVisible((tonumber(p10.userId)))

				return React.createElement(TranslatedTextMessage, {
					message = p10,
					LayoutOrder = p11,
					isUserVerified = v94,
					textTransparency = v46.textTransparency,
					transparencyValue = if not EngineFeature then nil else v46.transparencyValue,
					onTextMessageLabelButtonActivated = v61,
					chatWindowSettings = v46.chatWindowSettings,
					showTranslationButton = v46.showTranslationButton,
					isSpatialUIEnabled = v46.isSpatialUIEnabled,
					onToggle = function() -- line: 229
					end,
					chatWindowTransparencyBindable = if not FFlagExpChatRewriteInline then nil else v46.transparencyValue
				}), p10.messageId
			end

			return nil, nil
		end)

		v78["$layout"] = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder
		})

		return v78
	end, if not getFFlagChatWindowUseCallbackOptimizations() then nil else {
		v46.messages,
		v46.textTransparency,
		v46.verifiedUserIds,
		v46.chatWindowSettings,
		v46.showTranslationButton
	}) else nil

	if FFlagExpChatPerfTracking then
		local v63 = if not FFlagExpChatChannelTabRefactor then not v46.targetTextChannel and "UNKNOWN_TAB" or v46.targetTextChannel.Name else v46.selectedChannelName or "UNKNOWN_TAB"
		local v64 = if not FFlagExpChatPerfTrackerTabName then nil else {
			tabName = v63
		}

		React.useEffect(function() -- line: 262
			-- upvalues: ExpChatPerfTracker (copy), v64 (copy)
			ExpChatPerfTracker.finish(ExpChatPerfTracker.Events.ChatWindowMountTTI, {}, v64)

			return function() -- line: 264
				-- upvalues: ExpChatPerfTracker (copy)
				ExpChatPerfTracker.cancelAll()
			end
		end, {})
		React.useEffect(function() -- line: 268
			-- upvalues: ExpChatPerfTracker (copy), v63 (copy), v64 (copy)
			ExpChatPerfTracker.finish(ExpChatPerfTracker.Events.ChatWindowTabSwitchTTI, {
				tabId = v63
			}, v64)
		end, { v63 })
	end

	local t3 = {}

	if FFlagExpChatEnableV2ChatWindow then
		t3 = {
			showTranslationButton = v46.showTranslationButton,
			chatWindowSettings = v46.chatWindowSettings,
			textTransparency = v46.textTransparency,
			onTextMessageLabelButtonActivated = v61,
			isSpatialUIEnabled = v46.isSpatialUIEnabled,
			chatWindowTransparencyBindable = if not FFlagExpChatRewriteInline then nil else v46.transparencyValue,
			visible = v46.visible,
			selectedChannelName = if not GetFFlagTextChatEnableUniverseChatTabs() then nil else v46.selectedChannelName
		}
	end

	if FFlagExpChatWindowMessageSourceRefactor then
		t3.messageComponentsSignal = v46.messageComponentsSignal
	end

	local v66 = v46.textTransparency:map(function(n2: number) -- line: 293
		-- upvalues: Config (copy)
		return n2 < Config.ChatWindowMessageHideRootFadeThreshold
	end)
	local v67 = if FFlagExpChatEnableFriendsTab and v46.disableLineReporting or (isChatRegionLocked() or (not v51 or not v59)) then nil else React.createElement(TopBanner, {
		backgroundColor3 = BackgroundColor3,
		backgroundTransparency = BackgroundTransparency,
		iconTransparency = if not GetFFlagMemoizeChatReportingMenu() then v60(BackgroundTransparency, v46.transparencyValue) else v46.transparencyValue,
		onFocus = v46.onFocus,
		onUnfocus = v46.onUnfocus,
		getMessages = if not GetFFlagMemoizeChatReportingMenu() then nil else v57,
		messages = if GetFFlagMemoizeChatReportingMenu() then nil else v46.messages
	})
	local v68 = React.createElement(ScrollingView, Dictionary.join({
		size = v46.size,
		targetTextChannel = v46.targetTextChannel,
		isChannelBarVisible = v46.isChannelBarVisible,
		scrollResetKey = if not FFlagExpChatChannelTabRefactor then nil else v46.scrollResetKey,
		onCanvasPositionChanged = if not FFlagExpChatEnableFriendsTab then nil else v46.onCanvasPositionChanged,
		contentTopPadding = if not FFlagExpChatEnableFriendsTab then nil else v46.contentTopPadding
	}, t3), if not FFlagExpChatEnableV2ChatWindow and not FFlagExpChatWindowMessageSourceRefactor then v62(v46.messages) else nil)

	return React.createElement("Frame", {
		BackgroundColor3 = BackgroundColor3,
		BorderSizePixel = 0,
		LayoutOrder = v46.LayoutOrder,
		Size = v46.size,
		Visible = v46.visible,
		BackgroundTransparency = if not FFlagExpChatEnableFriendsTab or not v46.suppressBackground then v60(BackgroundTransparency, v46.transparencyValue) else 1,
		[React.Change.AbsoluteSize] = not getFFlagChatWindowUseCallbackOptimizations() and function(p12) -- line: 349
			-- upvalues: TextChatService (copy), v46 (copy)
			local ChatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")

			if ChatWindowConfiguration and v46.onAbsoluteSizeChanged then
				v46.onAbsoluteSizeChanged(p12, ChatWindowConfiguration)
			end
		end or React.useCallback(function(p13) -- line: 343
			-- upvalues: TextChatService (copy), v46 (copy)
			local ChatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")

			if ChatWindowConfiguration and v46.onAbsoluteSizeChanged then
				v46.onAbsoluteSizeChanged(p13, ChatWindowConfiguration)
			end
		end, {
			TextChatService,
			v46.onAbsoluteSizeChanged
		}),
		[React.Change.AbsolutePosition] = not getFFlagChatWindowUseCallbackOptimizations() and function(p14) -- line: 362
			-- upvalues: TextChatService (copy), v46 (copy)
			local ChatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")

			if ChatWindowConfiguration and v46.onAbsoluteSizeChanged then
				v46.onAbsolutePositionChanged(p14, ChatWindowConfiguration)
			end
		end or React.useCallback(function(p15) -- line: 356
			-- upvalues: TextChatService (copy), v46 (copy)
			local ChatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")

			if ChatWindowConfiguration and v46.onAbsoluteSizeChanged then
				v46.onAbsolutePositionChanged(p15, ChatWindowConfiguration)
			end
		end, {
			TextChatService,
			v46.onAbsolutePositionChanged
		})
	}, {
		hoverLayer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			[React.Event.MouseEnter] = v46.onHovered,
			[React.Event.MouseLeave] = v46.onUnhovered
		}),
		uiSizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = if not v46.isSpatialUIEnabled then Vector2.new(Config.ChatWindowMaxWidth, Config.ChatWindowMaxHeight) else Vector2.new(1e999, 400)
		}),
		contentFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Visible = v66
		}, {
			TopBanner = v67,
			scrollingView = v68
		}),
		GlobalChatTooltip = if not v54 then nil else React.createElement(GlobalChatTooltip, {
			visible = v46.visible,
			targetTextChannel = v46.targetTextChannel,
			chatStatus = v50
		})
	})
end))
