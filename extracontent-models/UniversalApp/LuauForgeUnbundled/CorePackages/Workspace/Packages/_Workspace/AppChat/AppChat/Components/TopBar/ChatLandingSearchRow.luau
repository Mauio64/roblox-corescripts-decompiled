local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local GetTopBarStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetTopBarStore")
local SearchRow = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialCommon/SearchRow")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")
local useSignalBinding = SignalsReact.useSignalBinding
local useSignalState = SignalsReact.useSignalState
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization

local useTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/useTelemetry")
local ChatConversationTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatConversationTelemetryLayer")
local ChatLandingTelemetryEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ChatLandingTelemetryEvents")

local function getFilterText(p2)
	return GetTopBarStore(p2).getScreenTopBar(EnumScreens.ChatLanding)(p2).filterText or ""
end

local function getShouldAutoFocus(p2)
	return GetTopBarStore(p2).getScreenTopBar(EnumScreens.ChatLanding)(p2).shouldAutoFocusCenter or false
end

local function ChatLandingSearchRow(props)
	local hasExit = props.hasExit ~= false
	local reportFocusAsSearchEntry = props.reportFocusAsSearchEntry
	local setScreenTopBar = GetTopBarStore(false).setScreenTopBar

	local v5 = useSignalBinding(getFilterText)
	local v6 = useSignalState(getShouldAutoFocus)

	local v7 = useTelemetry(ChatConversationTelemetryLayer.Context)
	local v8 = useLocalization({
		cancelText = "Feature.Chat.Action.Cancel",
		placeholder = "Feature.Chat.Label.SearchWord"
	})

	React.useEffect(function()
		if v6 then
			setScreenTopBar(EnumScreens.ChatLanding, { shouldAutoFocusCenter = false })
		end
	end, { v6, setScreenTopBar })

	local v9 = React.useCallback(function(p2)
		setScreenTopBar(EnumScreens.ChatLanding, { filterText = p2 })
	end, { setScreenTopBar })

	local v10 = React.useCallback(function()
		setScreenTopBar(EnumScreens.ChatLanding, {
			shouldRenderCenter = false,
			filterText = ""
		})
	end, { setScreenTopBar })

	local v11 = React.useCallback(function()
		v7.emit(ChatLandingTelemetryEvents.ChatLandingSearchBtnClicked, {})
	end, { v7 })

	local createElement = React.createElement
	local v13 = {
		text = v5,
		placeholder = v8.placeholder,
		onChanged = v9,
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
		v10 = nil
	end

	v13.onExit = v10
	v13.exitVariant = props.exitVariant
	v13.cancelText = v8.cancelText
	v13.shouldAutoFocus = v6

	if not reportFocusAsSearchEntry then
		v11 = nil
	end

	v13.onFocusGained = v11
	v13.height = props.height
	v13.paddingHorizontal = props.paddingHorizontal
	v13.LayoutOrder = props.LayoutOrder
	v13.testId = props.testId or "ChatSearchField"
	return createElement(SearchRow, v13)
end

return ChatLandingSearchRow
