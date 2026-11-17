local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local Dash = require(parent.Dash)
local React = require(parent.React)

local InternalDrawerOpenPhase = require(Foundation.Enums.InternalDrawerOpenPhase)
local ScrollBarVisibility = require(Foundation.Enums.ScrollBarVisibility)
local withDefaults = require(Foundation.Utility.withDefaults)

local InternalDrawerEdgeSwipe = require(script.Parent.InternalDrawerEdgeSwipe)
local InternalDrawerOverlay = require(script.Parent.InternalDrawerOverlay)
require(script.Parent.Types)
local drawerMotion = require(script.Parent.drawerMotion)
local useInternalDrawerVariants = require(script.Parent.useInternalDrawerVariants)
local useSurfaceWidth = require(script.Parent.useSurfaceWidth)

local v = {
	outerBleed = 0,
	scrolls = true,
	scrollBarVisibility = ScrollBarVisibility.None,
	testId = "--foundation-internal-drawer"
}

local function InternalDrawer(p, ref3)
	local v2 = withDefaults(p, v)
	local v3 = useInternalDrawerVariants(v2.layout, v2.side)
	local _, travel = useSurfaceWidth(v2.width, v3.surface.margin, v2.outerBleed)
	local state, setState = React.useState(v2.isOpen)
	local state2, setState2 = React.useState(InternalDrawerOpenPhase.Idle)
	local ref = React.useRef(state2)
	ref.current = state2
	local ref2 = React.useRef(v2.isOpen)
	local drag, setDrag = drawerMotion.useDrag()

	if v2.isOpen and not state then
		setState(true)
	end

	if v2.isOpen then
		ref2.current = true

		if state2 ~= InternalDrawerOpenPhase.Idle then
			setState2(InternalDrawerOpenPhase.Idle)
		end
	end

	React.useEffect(function()
		if state2 == InternalDrawerOpenPhase.Requested and not v2.isOpen then
			setState2(InternalDrawerOpenPhase.Settling)
		end
	end, { state2, v2.isOpen })

	local onCloseComplete = v2.onCloseComplete
	local onExited = React.useCallback(function()
		local current = ref2.current
		ref2.current = false
		setState(false)
		setState2(InternalDrawerOpenPhase.Idle)

		if current and onCloseComplete then
			onCloseComplete()
		end
	end, { onCloseComplete })

	local onRequestOpen = v2.onRequestOpen
	local setPhase = React.useCallback(function(p2)
		if p2 == InternalDrawerOpenPhase.Idle and ref.current ~= InternalDrawerOpenPhase.Pressed then
			return
		end

		setState2(p2)

		if p2 == InternalDrawerOpenPhase.Requested and onRequestOpen ~= nil then
			onRequestOpen()
		end
	end, { onRequestOpen })

	local v4 = state or state2 ~= InternalDrawerOpenPhase.Idle

	if not v4 and v2.swipeToOpen == nil then
		return nil
	end

	local joined = Dash.join(v2, {
		ref = ref3,
		onExited = onExited,
		drag = drag,
		setDrag = setDrag,
		openPhase = state2
	})

	local createElement = React.createElement
	local fragment = React.Fragment
	local edge

	if v2.swipeToOpen ~= nil then
		edge = React.createElement(InternalDrawerEdgeSwipe, {
			config = v2.swipeToOpen,
			side = v2.side,
			outerBleed = v2.outerBleed,
			travel = travel,
			isOpen = v2.isOpen,
			zIndex = v2.elevation.zIndex,
			setPhase = setPhase,
			setDrag = setDrag,
			testId = v2.testId
		})
	end

	local overlay

	if v4 then
		overlay = React.createElement(InternalDrawerOverlay, joined)
	end

	return createElement(fragment, nil, { Edge = edge, Overlay = overlay })
end

return React.memo(React.forwardRef(InternalDrawer))
