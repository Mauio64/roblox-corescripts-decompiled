local TextChatService = game:GetService("TextChatService")

local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local llama = require(parent.llama)
local dictionary = llama.Dictionary
local llama2 = require(parent.llama)
local list = llama2.List
local ExpChatShared = require(parent.ExpChatShared)

local Config = require(ExpChat.Config)
local useInterpolatedClientSettings = require(ExpChat.ClientSettings.useInterpolatedClientSettings)

local GetChatStatusStore = require(ExpChat.Stores.GetChatStatusStore)
local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)
local GetGlobalChatTooltipStore = require(ExpChat.Stores.GetGlobalChatTooltipStore)
local GetChatTooltipStore = require(ExpChat.Stores.GetChatTooltipStore)

local ui = script:FindFirstAncestor("UI")
local ScrollingView = require(ui.ScrollingView)
local TopBanner = require(ui.TopBanner)
local GlobalChatTooltip = require(ui.GlobalChatTooltip)
local isChatRegionLocked = require(ExpChat.isChatRegionLocked)
local showChatEnabledUI = require(ExpChat.showChatEnabledUI)

local RoactAppExperiment = require(parent.RoactAppExperiment)
local useUserExperiment = RoactAppExperiment.useUserExperiment
local SharedFlags = require(parent.SharedFlags)
local FStringReportingIXPLayer = SharedFlags.FStringReportingIXPLayer
local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagEnableChatLineReporting = SharedFlags2.GetFFlagEnableChatLineReporting
local SharedFlags3 = require(parent.SharedFlags)
local GetFFlagMemoizeChatReportingMenu = SharedFlags3.GetFFlagMemoizeChatReportingMenu

local getFFlagChatWindowUseCallbackOptimizations = require(ExpChat.Flags.getFFlagChatWindowUseCallbackOptimizations)
local FFlagExpChatEnableV2ChatWindow = require(ExpChat.Flags.FFlagExpChatEnableV2ChatWindow)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local FFlagExpChatTopBannerForPresetChatAccess = require(ExpChat.Flags.FFlagExpChatTopBannerForPresetChatAccess)
local useIsARButtonVisible = require(ExpChat.useIsARButtonVisible)
local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local ExpChatPerfTracker = ChatUIPrimitives.Telemetry.ExpChatPerfTracker
local ChatUIPrimitives2 = require(parent.ChatUIPrimitives)
local FFlagExpChatPerfTrackerTabName = ChatUIPrimitives2.Flags.FFlagExpChatPerfTrackerTabName
local FFlagExpChatRewriteInline = require(ExpChat.Flags.FFlagExpChatRewriteInline)
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local FFlagExpChatUseUnifiedTooltipStore = ExpChatShared.Flags.FFlagExpChatUseUnifiedTooltipStore
local FFlagExpChatRenderHistoricalMessages = require(ExpChat.Flags.FFlagExpChatRenderHistoricalMessages)

local v = {
	LayoutOrder = 1,
	size = UDim2.fromScale(1, 1),
	messages = not FFlagExpChatEnableV2ChatWindow and {} or nil,
	transparencyValue = 0,
	textTransparency = 0,
	mutedUserIds = 0,
	verifiedUserIds = 0,
	showTranslationButton = false
}
local transparencyValue

if GetFFlagMemoizeChatReportingMenu() then
	transparencyValue = React.createBinding(Config.ChatWindowBackgroundTransparency)
else
	transparencyValue = Config.ChatWindowBackgroundTransparency
end

v.transparencyValue = transparencyValue

v.textTransparency = React.createBinding(0)
v.mutedUserIds = {}
v.verifiedUserIds = {}

return (React.memo(function(p)
	local joined = dictionary.join(v, p)
	local chatWindowSettings = joined.chatWindowSettings
	local backgroundTransparency = useInterpolatedClientSettings(chatWindowSettings).BackgroundTransparency
	local backgroundColor3 = useInterpolatedClientSettings(chatWindowSettings).BackgroundColor3
	local chatStatus = nil
	local v2

	if FFlagExpChatPresetChatEnabled and FFlagExpChatTopBannerForPresetChatAccess then
		v2 = useIsARButtonVisible()
	else
		local chatStatusStore = GetChatStatusStore(false)
		chatStatus = SignalsReact.useSignalState(chatStatusStore.getChatStatus)
		v2 = showChatEnabledUI(chatStatus)
	end

	local v3

	if FFlagExpChatUseUnifiedTooltipStore then
		local chatTooltipStore = GetChatTooltipStore(false)
		v3 = SignalsReact.useSignalState(chatTooltipStore.getIsEligible("GlobalChatTooltip"))
	else
		local globalChatTooltipStore = GetGlobalChatTooltipStore(false)
		v3 = SignalsReact.useSignalState(globalChatTooltipStore.getIsGlobalChatTooltipEligible)
	end

	if FFlagExpChatUseUnifiedTooltipStore then
		local setIsChatWindowOpen = GetChatTooltipStore(false).setIsChatWindowOpen
		React.useEffect(function()
			setIsChatWindowOpen(joined.visible)
			return function()
				setIsChatWindowOpen(false)
			end
		end, { joined.visible, setIsChatWindowOpen })
	end

	local getMessages

	if GetFFlagMemoizeChatReportingMenu() and not FFlagExpChatEnableV2ChatWindow then
		local useRef = React.useRef
		local v4

		if not FFlagExpChatEnableV2ChatWindow then
			v4 = joined.messages
		end

		local v5 = useRef(v4)
		local useEffect = React.useEffect
		local function fn()
			local current

			if not FFlagExpChatEnableV2ChatWindow then
				current = joined.messages
			end

			v5.current = current
		end

		local v6

		if not FFlagExpChatEnableV2ChatWindow then
			v6 = joined.messages
		end

		useEffect(fn, { v6 })

		getMessages = React.useCallback(function()
			return v5.current
		end, {})
	end

	if FFlagExpChatEnableV2ChatWindow then
		local useCallback = React.useCallback
		local function fn()
			local messagesStore = GetMessagesStore(false)
			local v4 = {
				windowMessagesInOrderByTabId = messagesStore.getWindowMessagesInOrderByTabId(false),
				byMessageId = messagesStore.getByMessageId(false),
				windowMessagesInOrder = messagesStore.getWindowMessagesInOrder(false)
			}

			if not joined.isChannelBarVisible then
				return list.map(v4.windowMessagesInOrder, function(p2)
					return v4.byMessageId[p2]
				end)
			end

			if GetFFlagTextChatEnableUniverseChatTabs() then
				local v5 = joined.selectedChannelName

				if joined.targetTextChannel and v4.windowMessagesInOrderByTabId[joined.targetTextChannel.Name] then
					v5 = joined.targetTextChannel.Name
				end

				if v5 then
					return list.map(v4.windowMessagesInOrderByTabId[v5] or {}, function(p2)
						return v4.byMessageId[p2]
					end)
				end

				return {}
			elseif joined.targetTextChannel then
				return list.map(v4.windowMessagesInOrderByTabId[joined.targetTextChannel.Name] or {}, function(p2)
					return v4.byMessageId[p2]
				end)
			else
				return {}
			end
		end

		local isChannelBarVisible = joined.isChannelBarVisible
		local targetTextChannel = joined.targetTextChannel
		local v4

		if GetFFlagTextChatEnableUniverseChatTabs() then
			v4 = joined.selectedChannelName
		end

		getMessages = useCallback(fn, { isChannelBarVisible, targetTextChannel, v4 })
	end

	local v4

	if GetFFlagEnableChatLineReporting() then
		v4 = useUserExperiment({ FStringReportingIXPLayer }, function(p2)
			return (p2[FStringReportingIXPLayer] or {}).EnableChatLineReporting
		end)
	else
		v4 = false
	end

	local v5 = React.useCallback(function(p2, value)
		if type(value) == "number" then
			return joined.transparencyValue
		end

		return value:map(function(p3: number)
			return p2 + p3 * (1 - p2)
		end)
	end, getFFlagChatWindowUseCallbackOptimizations() and { joined.transparencyValue } or nil)

	local onTextMessageLabelButtonActivated = React.useCallback(function(p2)
		joined.resetTargetChannel()

		local userId = tonumber(p2.userId)

		if userId then
			joined.activateWhisperMode(userId)
		end
	end, getFFlagChatWindowUseCallbackOptimizations() and { joined.resetTargetChannel, joined.activateWhisperMode } or nil)

	local selectedChannelName = joined.selectedChannelName or "UNKNOWN_TAB"
	local v6 = FFlagExpChatPerfTrackerTabName and { tabName = selectedChannelName } or nil
	React.useEffect(function()
		ExpChatPerfTracker.finish(ExpChatPerfTracker.Events.ChatWindowMountTTI, {}, v6)
		return function()
			ExpChatPerfTracker.cancelAll()
		end
	end, {})
	React.useEffect(function()
		ExpChatPerfTracker.finish(ExpChatPerfTracker.Events.ChatWindowTabSwitchTTI, {
			tabId = selectedChannelName
		}, v6)
	end, { selectedChannelName })
	local v7

	if FFlagExpChatEnableV2ChatWindow then
		v7 = {
			showTranslationButton = joined.showTranslationButton,
			chatWindowSettings = joined.chatWindowSettings,
			textTransparency = joined.textTransparency,
			onTextMessageLabelButtonActivated = onTextMessageLabelButtonActivated,
			isSpatialUIEnabled = joined.isSpatialUIEnabled,
			chatWindowTransparencyBindable = 0,
			visible = 0,
			selectedChannelName = 0,
			historicalMessageCountSignal = 0
		}
		local chatWindowTransparencyBindable

		if FFlagExpChatRewriteInline then
			chatWindowTransparencyBindable = joined.transparencyValue
		end

		v7.chatWindowTransparencyBindable = chatWindowTransparencyBindable
		v7.visible = joined.visible
		local selectedChannelName2

		if GetFFlagTextChatEnableUniverseChatTabs() then
			selectedChannelName2 = joined.selectedChannelName
		end

		v7.selectedChannelName = selectedChannelName2
		local historicalMessageCountSignal

		if FFlagExpChatRenderHistoricalMessages then
			historicalMessageCountSignal = GetMessagesStore(false).getHistoricalWindowMessageCount
		end

		v7.historicalMessageCountSignal = historicalMessageCountSignal
	else
		v7 = {}
	end

	v7.messageComponentsSignal = joined.messageComponentsSignal

	local mapped = joined.textTransparency:map(function(p2: number): boolean
		return p2 < Config.ChatWindowMessageHideRootFadeThreshold
	end)
	local topBanner

	if not (joined.disableLineReporting or isChatRegionLocked() or not (v2 and v4)) then
		local createElement = React.createElement
		local iconTransparency

		if GetFFlagMemoizeChatReportingMenu() then
			iconTransparency = joined.transparencyValue
		else
			iconTransparency = v5(backgroundTransparency, joined.transparencyValue)
		end

		local v8 = {
			backgroundColor3 = backgroundColor3,
			backgroundTransparency = backgroundTransparency,
			iconTransparency = iconTransparency,
			onFocus = joined.onFocus,
			onUnfocus = joined.onUnfocus,
			getMessages = 0,
			messages = 0
		}

		if not GetFFlagMemoizeChatReportingMenu() then
			getMessages = nil
		end

		v8.getMessages = getMessages
		local messages

		if not GetFFlagMemoizeChatReportingMenu() then
			messages = joined.messages
		end

		v8.messages = messages
		topBanner = createElement(TopBanner, v8)
	end

	local element = React.createElement(ScrollingView, dictionary.join({
		size = joined.size,
		isChannelBarVisible = joined.isChannelBarVisible,
		scrollResetKey = joined.scrollResetKey,
		scrollToTopOnReset = joined.scrollToTopOnReset,
		onCanvasPositionChanged = joined.onCanvasPositionChanged,
		contentTopPadding = joined.contentTopPadding
	}, v7))

	local createElement = React.createElement
	local v8 = {
		["BackgroundColor3"] = backgroundColor3,
		BorderSizePixel = 0,
		LayoutOrder = joined.LayoutOrder,
		Size = joined.size,
		Visible = joined.visible,
		BackgroundTransparency = joined.suppressBackground and 1 or v5(backgroundTransparency, joined.transparencyValue)
	}
	local absoluteSize = React.Change.AbsoluteSize
	local v9

	if getFFlagChatWindowUseCallbackOptimizations() then
		v9 = React.useCallback(function(p2)
			local chatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")

			if chatWindowConfiguration and joined.onAbsoluteSizeChanged then
				joined.onAbsoluteSizeChanged(p2, chatWindowConfiguration)
			end
		end, { TextChatService, joined.onAbsoluteSizeChanged })
	else
		v9 = function(p2)
			local chatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")

			if chatWindowConfiguration and joined.onAbsoluteSizeChanged then
				joined.onAbsoluteSizeChanged(p2, chatWindowConfiguration)
			end
		end
	end

	v8[absoluteSize] = v9

	local absolutePosition = React.Change.AbsolutePosition
	local v10

	if getFFlagChatWindowUseCallbackOptimizations() then
		v10 = React.useCallback(function(p2)
			local chatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")

			if chatWindowConfiguration and joined.onAbsoluteSizeChanged then
				joined.onAbsolutePositionChanged(p2, chatWindowConfiguration)
			end
		end, { TextChatService, joined.onAbsolutePositionChanged })
	else
		v10 = function(p2)
			local chatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")

			if chatWindowConfiguration and joined.onAbsoluteSizeChanged then
				joined.onAbsolutePositionChanged(p2, chatWindowConfiguration)
			end
		end
	end

	v8[absolutePosition] = v10

	local children = {
		hoverLayer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			[React.Event.MouseEnter] = joined.onHovered,
			[React.Event.MouseLeave] = joined.onUnhovered
		}),
		uiSizeConstraint = 0,
		contentFrame = 0,
		GlobalChatTooltip = 0
	}

	local createElement2 = React.createElement
	local maxSize

	if joined.isSpatialUIEnabled then
		maxSize = Vector2.new(1e999, 400)
	else
		maxSize = Vector2.new(Config.ChatWindowMaxWidth, Config.ChatWindowMaxHeight)
	end

	children.uiSizeConstraint = createElement2("UISizeConstraint", { MaxSize = maxSize })

	children.contentFrame = React.createElement(
		"Frame",
		{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Visible = mapped },
		{ TopBanner = topBanner, scrollingView = element }
	)
	local globalChatTooltip

	if v3 then
		globalChatTooltip = React.createElement(GlobalChatTooltip, {
			visible = joined.visible,
			targetTextChannel = joined.targetTextChannel,
			chatStatus = chatStatus
		})
	end

	children.GlobalChatTooltip = globalChatTooltip
	return createElement("Frame", v8, children)
end))
