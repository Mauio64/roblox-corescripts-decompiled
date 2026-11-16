local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local EnumScreens = require(AppChat.EnumScreens)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local SearchRow = require(parent.SocialCommon.SearchRow)

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local useSignalBinding = SignalsReact.useSignalBinding
local useSignalState = SignalsReact.useSignalState
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local ChatLandingTelemetryLayer = require(AppChat.Telemetry.Layers.ChatLandingTelemetryLayer)
local ChatLandingTelemetryEvents = require(AppChat.Components.ChatLanding.ChatLandingTelemetryEvents)

local function getFilterText(p)
	return GetTopBarStore(p).getScreenTopBar(EnumScreens.ChatLanding)(p).filterText or ""
end

local function getShouldAutoFocus(p)
	return GetTopBarStore(p).getScreenTopBar(EnumScreens.ChatLanding)(p).shouldAutoFocusCenter or false
end

local function ChatLandingSearchRow(props)
	local hasExit = props.hasExit ~= false
	local reportFocusAsSearchEntry = props.reportFocusAsSearchEntry
	local setScreenTopBar = GetTopBarStore(false).setScreenTopBar

	local text = useSignalBinding(getFilterText)
	local shouldAutoFocus = useSignalState(getShouldAutoFocus)

	local v = useTelemetry(ChatLandingTelemetryLayer.Context)
	local v2 = useLocalization({
		cancelText = "Feature.Chat.Action.Cancel",
		placeholder = "Feature.Chat.Label.SearchWord"
	})

	React.useEffect(function()
		if shouldAutoFocus then
			setScreenTopBar(EnumScreens.ChatLanding, { shouldAutoFocusCenter = false })
		end
	end, { shouldAutoFocus, setScreenTopBar })

	local onChanged = React.useCallback(function(filterText: string)
		setScreenTopBar(EnumScreens.ChatLanding, { filterText = filterText })
	end, { setScreenTopBar })

	local onExit = React.useCallback(function()
		setScreenTopBar(EnumScreens.ChatLanding, { shouldRenderCenter = false, filterText = "" })
	end, { setScreenTopBar })

	local onFocusGained = React.useCallback(function()
		v.emit(ChatLandingTelemetryEvents.ChatLandingSearchBtnClicked, {})
	end, { v })

	local createElement = React.createElement
	local v3 = {
		text = text,
		placeholder = v2.placeholder,
		onChanged = onChanged,
		onExit = 0,
		exitVariant = 0,
		cancelText = 0,
		shouldAutoFocus = 0,
		onFocusGained = 0,
		height = 0,
		paddingHorizontal = 0,
		LayoutOrder = 0,
		testId = 0,
		exitTestId = "ChatLandingSearch"
	}

	if not hasExit then
		onExit = nil
	end

	v3.onExit = onExit
	v3.exitVariant = props.exitVariant
	v3.cancelText = v2.cancelText
	v3.shouldAutoFocus = shouldAutoFocus

	if not reportFocusAsSearchEntry then
		onFocusGained = nil
	end

	v3.onFocusGained = onFocusGained
	v3.height = props.height
	v3.paddingHorizontal = props.paddingHorizontal
	v3.LayoutOrder = props.LayoutOrder
	v3.testId = props.testId or "ChatSearchField"
	return createElement(SearchRow, v3)
end

return ChatLandingSearchRow
