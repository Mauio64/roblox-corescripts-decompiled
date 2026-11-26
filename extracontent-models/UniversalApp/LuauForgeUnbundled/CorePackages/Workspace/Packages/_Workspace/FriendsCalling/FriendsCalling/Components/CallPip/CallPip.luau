local CallingService = game:GetService("CallingService")
local FriendsCallingService = game:GetService("FriendsCallingService")

local FloatingWindow = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/FloatingWindow")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/RoactUtils")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/Responsive")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/RobloxAppEnums")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/RobloxAppHooks")
local FFlagFriendsCallingServiceLuaMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/SharedFlags/FFlagFriendsCallingServiceLuaMigration")

require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/FriendsCalling/Components/CallParticipant/CallParticipantCard")
local CollapsedCallOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/FriendsCalling/Components/CallPip/CollapsedCallOverlay")
local ExpandedCallOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/FriendsCalling/Components/CallPip/ExpandedCallOverlay")
local resolveGeometry = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/FriendsCalling/Components/CallPip/resolveGeometry")
local useCallPipViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/FriendsCalling/Components/CallPip/useCallPipViewModel")

local colorMode = Foundation.Enums.ColorMode
local deviceOrientationMode = RobloxAppEnums.DeviceOrientationMode
local foundationProvider = Foundation.FoundationProvider
local useSelectedTheme = RoactUtils.Hooks.useSelectedTheme
local useDeviceInsets = Responsive.useDeviceInsets
local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation
local useTokens = Foundation.Hooks.useTokens

local udim = UDim2.fromOffset(120, 160)

local function noop() end

local frozen = table.freeze({ Compact = "Compact", Expanded = "Expanded" })

local function CallPipSession(props)
	local host = props.host
	local v5 = useTokens()
	local v6 = useDeviceInsets()
	local v7 = useDeviceOrientation() ~= deviceOrientationMode.Landscape

	local state, setState = React.useState(props.initialPresentation or frozen.Compact)
	local state2, setState2 = React.useState(nil)
	local v8 = React.useCallback(function(p2)
		setState2(p2)
	end, {})
	local v9 = React.useCallback(function()
		setState(frozen.Expanded)
	end, {})
	local ref = React.useRef(props.expandCount)
	React.useEffect(function()
		if props.expandCount > ref.current then
			ref.current = props.expandCount
			v9()
		end
	end, { props.expandCount, v9 })
	local v10 = React.useCallback(function()
		setState(frozen.Compact)
	end, {})
	local v11 = React.useCallback(function()
		local callId = props.callId or ""

		if FFlagFriendsCallingServiceLuaMigration then
			FriendsCallingService:EndCall(callId, "LuaEndAction")
		else
			CallingService:EndCall(callId, "LuaEndAction")
		end
	end, { props.callId })

	local v12 = state == frozen.Expanded
	local v13 = resolveGeometry({
		deviceInsets = v6,
		exposesTopSafeArea = host.exposesTopSafeArea,
		isPortrait = v7,
		margin = v5.Padding.Medium
	})
	local v14

	if v12 then
		v14 = React.createElement(ExpandedCallOverlay, {
			connectedAt = props.connectedAt,
			participant = props.participant,
			hasRoundedCorners = v13.expanded.hasRoundedCorners,
			isMicrophoneMuted = props.isMicrophoneMuted,
			onCollapse = v10,
			onDragInputTarget = v8,
			onEndCall = v11,
			onOpenChat = noop,
			onToggleConversationAudio = noop,
			onToggleMicrophone = noop,
			topPadding = v13.expanded.topPadding
		})
	else
		v14 = React.createElement(CollapsedCallOverlay, {
			participant = props.participant,
			isMicrophoneMuted = props.isMicrophoneMuted,
			onDragInputTarget = v8,
			onToggleConversationAudio = noop,
			onToggleMicrophone = noop
		})
	end

	local createElement = React.createElement
	local window = FloatingWindow.Window
	local v15 = {
		behavior = FloatingWindow.Behaviors.Contained,
		boundsInsets = 0,
		children = 0,
		displayOrder = 0,
		dragInputTarget = 0,
		enabled = 0,
		draggable = 0,
		initialCenter = 0,
		onActivated = 0,
		screenInsets = 0,
		size = 0,
		testId = "friends-calling-pip"
	}
	local v16 = if v12 then v13.expanded.boundsInsets else v13.collapsed.boundsInsets
	v15.boundsInsets = v16
	v15.children = v14
	v15.displayOrder = host.displayOrder
	v15.dragInputTarget = state2
	v15.enabled = props.enabled

	v15.draggable = not (v12 and v7)
	v15.initialCenter = UDim2.fromScale(0.85, 0.2)

	v15.onActivated = if not v12 then v9 else nil
	v15.screenInsets = host.screenInsets
	local v18 = if v12 then v13.expanded.size else udim
	v15.size = v18
	return createElement(window, v15)
end

local function CallPipWindow(props)
	local v5 = useCallPipViewModel()

	return React.createElement(CallPipSession, {
		key = tostring(v5.session),
		callId = v5.callId,
		connectedAt = v5.connectedAt,
		enabled = v5.enabled,
		expandCount = v5.expandCount,
		host = props.host,
		participant = v5.participant,
		isMicrophoneMuted = props.isMicrophoneMuted,
		initialPresentation = props.initialPresentation
	})
end

local function CallPip(p2)
	local v5 = useSelectedTheme()
	local v6 = if p2.host.followsAppColorMode and v5 == "light" then colorMode.Light else colorMode.Dark

	return React.createElement(foundationProvider, { colorMode = v6 }, {
		Window = React.createElement(CallPipWindow, p2)
	})
end

return CallPip
