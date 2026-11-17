local FriendsCalling = script:FindFirstAncestor("FriendsCalling")
local parent = FriendsCalling.Parent

local CallingService = game:GetService("CallingService")
local FriendsCallingService = game:GetService("FriendsCallingService")

local FloatingWindow = require(parent.FloatingWindow)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local Responsive = require(parent.Responsive)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local FFlagFriendsCallingServiceLuaMigration = require(parent.SharedFlags.FFlagFriendsCallingServiceLuaMigration)

require(FriendsCalling.Components.CallParticipant.CallParticipantCard)
local CollapsedCallOverlay = require(script.Parent.CollapsedCallOverlay)
local ExpandedCallOverlay = require(script.Parent.ExpandedCallOverlay)
local resolveGeometry = require(script.Parent.resolveGeometry)
local useCallPipViewModel = require(script.Parent.useCallPipViewModel)

local ColorMode = Foundation.Enums.ColorMode
local DeviceOrientationMode = RobloxAppEnums.DeviceOrientationMode
local FoundationProvider = Foundation.FoundationProvider
local useSelectedTheme = RoactUtils.Hooks.useSelectedTheme
local useDeviceInsets = Responsive.useDeviceInsets
local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation
local useTokens = Foundation.Hooks.useTokens

local udim = UDim2.fromOffset(120, 160)

local function noop() end

local frozen = table.freeze({ Compact = "Compact", Expanded = "Expanded" })

local function CallPipSession(props)
	local host = props.host
	local v = useTokens()
	local deviceInsets = useDeviceInsets()
	local isPortrait = useDeviceOrientation() ~= DeviceOrientationMode.Landscape

	local state, setState = React.useState(props.initialPresentation or frozen.Compact)
	local state2, setState2 = React.useState(nil)
	local onDragInputTarget = React.useCallback(function(p)
		setState2(p)
	end, {})
	local v2 = React.useCallback(function()
		setState(frozen.Expanded)
	end, {})
	local ref = React.useRef(props.expandCount)
	React.useEffect(function()
		if props.expandCount > ref.current then
			ref.current = props.expandCount
			v2()
		end
	end, { props.expandCount, v2 })
	local onCollapse = React.useCallback(function()
		setState(frozen.Compact)
	end, {})
	local onEndCall = React.useCallback(function()
		local callId = props.callId or ""

		if FFlagFriendsCallingServiceLuaMigration then
			FriendsCallingService:EndCall(callId, "LuaEndAction")
		else
			CallingService:EndCall(callId, "LuaEndAction")
		end
	end, { props.callId })

	local v3 = state == frozen.Expanded
	local geometry = resolveGeometry({
		deviceInsets = deviceInsets,
		exposesTopSafeArea = host.exposesTopSafeArea,
		isPortrait = isPortrait,
		margin = v.Padding.Medium
	})
	local children

	if v3 then
		children = React.createElement(ExpandedCallOverlay, {
			connectedAt = props.connectedAt,
			participant = props.participant,
			hasRoundedCorners = geometry.expanded.hasRoundedCorners,
			isMicrophoneMuted = props.isMicrophoneMuted,
			onCollapse = onCollapse,
			onDragInputTarget = onDragInputTarget,
			onEndCall = onEndCall,
			onOpenChat = noop,
			onToggleConversationAudio = noop,
			onToggleMicrophone = noop,
			topPadding = geometry.expanded.topPadding
		})
	else
		children = React.createElement(CollapsedCallOverlay, {
			participant = props.participant,
			isMicrophoneMuted = props.isMicrophoneMuted,
			onDragInputTarget = onDragInputTarget,
			onToggleConversationAudio = noop,
			onToggleMicrophone = noop
		})
	end

	local createElement = React.createElement
	local window = FloatingWindow.Window
	local v4 = {
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
	local boundsInsets

	if v3 then
		boundsInsets = geometry.expanded.boundsInsets
	else
		boundsInsets = geometry.collapsed.boundsInsets
	end

	v4.boundsInsets = boundsInsets
	v4.children = children
	v4.displayOrder = host.displayOrder
	v4.dragInputTarget = state2
	v4.enabled = props.enabled

	v4.draggable = not (v3 and isPortrait)
	v4.initialCenter = UDim2.fromScale(0.85, 0.2)
	local onActivated

	if not v3 then
		onActivated = v2
	end

	v4.onActivated = onActivated
	v4.screenInsets = host.screenInsets
	local size = if v3 then geometry.expanded.size else udim
	v4.size = size
	return createElement(window, v4)
end

local function CallPipWindow(props)
	local v = useCallPipViewModel()

	return React.createElement(CallPipSession, {
		key = tostring(v.session),
		callId = v.callId,
		connectedAt = v.connectedAt,
		enabled = v.enabled,
		expandCount = v.expandCount,
		host = props.host,
		participant = v.participant,
		isMicrophoneMuted = props.isMicrophoneMuted,
		initialPresentation = props.initialPresentation
	})
end

local function CallPip(p)
	local v = useSelectedTheme()
	local colorMode

	if p.host.followsAppColorMode and v == "light" then
		colorMode = ColorMode.Light
	else
		colorMode = ColorMode.Dark
	end

	return React.createElement(FoundationProvider, { colorMode = colorMode }, {
		Window = React.createElement(CallPipWindow, p)
	})
end

return CallPip
