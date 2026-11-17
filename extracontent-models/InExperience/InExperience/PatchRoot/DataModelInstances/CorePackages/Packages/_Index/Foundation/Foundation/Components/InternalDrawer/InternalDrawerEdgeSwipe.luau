local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)

local InternalDrawerOpenPhase = require(Foundation.Enums.InternalDrawerOpenPhase)
local InternalDrawerSide = require(Foundation.Enums.InternalDrawerSide)
require(script.Parent.Types)
local edgeSwipeHandlers = require(script.Parent.edgeSwipeHandlers)
local getTestIdTag = require(Foundation.Utility.getTestIdTag)
local swipeMath = require(script.Parent.swipeMath)
local useHardwareInsets = require(Foundation.Components.Sheet.useHardwareInsets)
local useOverlay = require(Foundation.Providers.Overlay.useOverlay)
local useSwipeSession = require(script.Parent.useSwipeSession)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function InternalDrawerEdgeSwipe(props)
	local v = useOverlay()
	local v2 = useHardwareInsets(v)
	local v3 = useTokens()
	local ref = React.useRef(nil)
	local v4 = props.config.edgeWidth
	local thresholds, velocityThreshold = swipeMath.resolveThresholds(props.config)
	local setPhase = props.setPhase

	useSwipeSession({
		side = props.side,
		travel = props.travel,
		isOpen = props.isOpen,
		distanceFraction = thresholds,
		velocityThreshold = velocityThreshold,
		onPress = function()
			setPhase(InternalDrawerOpenPhase.Pressed)
		end,
		onPressEnd = function()
			setPhase(InternalDrawerOpenPhase.Idle)
		end,
		onClaim = function()
			setPhase(InternalDrawerOpenPhase.Dragging)
		end,
		onDragCancel = function()
			setPhase(InternalDrawerOpenPhase.Settling)
		end,
		onCommit = function()
			setPhase(InternalDrawerOpenPhase.Requested)
		end,
		setDrag = props.setDrag
	}, function(latest)
		return { gesture = nil, latest = latest, edgeRef = ref }
	end, edgeSwipeHandlers, not props.isOpen)

	local v5 = props.side == InternalDrawerSide.End
	local screenGui

	if v then
		screenGui = v:FindFirstAncestorWhichIsA("ScreenGui")
	end

	local v6

	if screenGui == nil then
		v6 = false
	else
		v6 = screenGui.ScreenInsets == Enum.ScreenInsets.DeviceSafeInsets
	end

	local v7

	if v6 then
		v7 = if v5 then v2.right else v2.left
	else
		v7 = 0
	end

	local v8 = math.max(props.outerBleed, v7)

	if v4 == nil then
		v4 = v3.Size.Size_600
	end

	local v9 = v4 + v8
	local position

	if v5 then
		position = UDim2.new(1, v8, 0, 0)
	else
		position = UDim2.fromOffset(-v8, 0)
	end

	local v10 = {
		Active = false,
		AnchorPoint = Vector2.new(v5 and 1 or 0, 0),
		Size = UDim2.new(0, v9, 1, 0),
		Position = position,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Selectable = false,
		ZIndex = props.zIndex,
		Visible = not props.isOpen,
		ref = ref,
		[React.Tag] = getTestIdTag(props.testId, "edge")
	}

	return v and ReactRoblox.createPortal(React.createElement("Frame", v10), v)
end

return InternalDrawerEdgeSwipe
