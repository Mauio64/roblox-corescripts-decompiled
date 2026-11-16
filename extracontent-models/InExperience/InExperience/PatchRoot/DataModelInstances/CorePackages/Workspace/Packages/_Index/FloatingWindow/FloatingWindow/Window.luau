local parent = script.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local ReactRoblox = require(parent2.ReactRoblox)

local BehaviorKind = require(parent.BehaviorKind)
local Behaviors = require(parent.Behaviors)
local Geometry = require(parent.Geometry)
require(parent.Types)

local udim = UDim2.fromScale(0.5, 0.5)

local v = { bottom = 0, left = 0, right = 0, top = 0 }

local function Window(props)
	assert(
		(props.behavior or Behaviors.Contained).kind == BehaviorKind.Contained,
		"FloatingWindow only supports Contained behavior"
	)

	local boundsInsets = props.boundsInsets or v

	local ref = React.useRef(nil)
	local ref2 = React.useRef(Vector2.zero)
	local ref3 = React.useRef(Vector2.zero)
	local ref4 = React.useRef(false)
	local ref5 = React.useRef(false)
	local ref6 = React.useRef(Vector2.zero)
	local ref7 = React.useRef(Vector2.zero)

	local ref8 = React.useRef(Vector2.zero)
	local ref9 = React.useRef(false)
	local state, setState = React.useState(false)
	local v2, v3 = React.useBinding(Vector2.zero)

	local v4 = React.useCallback(function()
		local current = ref2.current
		local current2 = ref3.current

		if not (Geometry.hasPositiveSize(current) and Geometry.hasPositiveSize(current2)) then
			return
		end

		if ref4.current then
			if not ref5.current then
				v3((Geometry.clampCenter(ref8.current, current, current2)))
			end
		else
			ref4.current = true
			local center = Geometry.resolveCenter(props.initialCenter or udim, current)
			ref8.current = center
			v3((Geometry.clampCenter(center, current, current2)))
			setState(true)
		end
	end, { props.initialCenter, v3 })

	local v5 = React.useCallback(function(p)
		local absoluteSize = p.AbsoluteSize

		if absoluteSize == ref2.current then
			return
		end

		ref2.current = absoluteSize
		v4()
	end, { v4 })

	local v6 = React.useCallback(function(p)
		local absoluteSize = p.AbsoluteSize

		if absoluteSize == ref3.current then
			return
		end

		ref3.current = absoluteSize
		v4()
	end, { v4 })

	local v7 = React.useCallback(function(vector2: Vector2)
		if not ref5.current then
			return
		end

		local v7 = vector2 - ref6.current

		if v7.Magnitude > (props.dragThreshold or 25) then
			ref9.current = true
		end

		local current = ref7.current + v7
		ref8.current = current
		v3((Geometry.clampCenter(current, ref2.current, ref3.current)))
	end, { props.dragThreshold, v3 })

	local v8 = React.useCallback(function(_, current: Vector2)
		if not ref4.current then
			return
		end

		ref5.current = true
		ref9.current = false
		ref6.current = current
		ref7.current = v2:getValue()
	end, { v2 })

	local v9 = React.useCallback(function(_, vector2: Vector2)
		v7(vector2)
	end, { v7 })

	local v10 = React.useCallback(function(_, vector2: Vector2)
		v7(vector2)
		ref5.current = false

		if not ref9.current and props.onActivated ~= nil then
			props.onActivated()
		end
	end, { v2, props.onActivated, v7 })

	React.useLayoutEffect(function()
		if props.draggable ~= false then
			return
		end

		ref5.current = false
		ref9.current = false
		v4()
	end, { props.draggable, v4 })

	local mapped = v2:map(function(vector2: Vector2)
		return UDim2.fromOffset(vector2.X, vector2.Y)
	end)

	local createElement = React.createElement
	local tag = React.Tag
	local v11

	if props.testId ~= nil then
		v11 = `data-testid={props.testId}-drag-detector`
	end

	local dragDetector = createElement("UIDragDetector", {
		[tag] = v11,
		BoundingUI = ref,
		DragStyle = Enum.UIDragDetectorDragStyle.Scriptable,
		ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomOffset,
		[React.Event.DragContinue] = v9,
		[React.Event.DragEnd] = v10,
		[React.Event.DragStart] = v8
	})

	if props.draggable == false then
		dragDetector = nil
	elseif props.dragInputTarget ~= nil then
		dragDetector = ReactRoblox.createPortal({ DragDetector = dragDetector }, props.dragInputTarget)
	end

	local createElement2 = React.createElement
	local tag2 = React.Tag
	local v12

	if props.testId ~= nil then
		v12 = `data-testid={props.testId}-screen`
	end

	local v13 = {
		[tag2] = v12,
		DisplayOrder = props.displayOrder or 0,
		Enabled = props.enabled ~= false,
		Name = "FloatingWindow",
		ResetOnSpawn = false,
		ScreenInsets = props.screenInsets or Enum.ScreenInsets.CoreUISafeInsets,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}

	local createElement3 = React.createElement
	local v14 = { [React.Change.AbsoluteSize] = v5 }
	local tag3 = React.Tag
	local v15

	if props.testId ~= nil then
		v15 = `data-testid={props.testId}-bounds`
	end

	v14[tag3] = v15
	v14.BackgroundTransparency = 1
	v14.BorderSizePixel = 0

	v14.Position = UDim2.fromOffset(boundsInsets.left, boundsInsets.top)
	v14.ref = ref
	v14.Size = UDim2.new(1, -(boundsInsets.left + boundsInsets.right), 1, -(boundsInsets.top + boundsInsets.bottom))

	local createElement4 = React.createElement
	local v16 = { [React.Change.AbsoluteSize] = v6 }
	local tag4 = React.Tag
	local v17

	if props.testId ~= nil then
		v17 = `data-testid={props.testId}`
	end

	v16[tag4] = v17

	v16.Active = true
	v16.AnchorPoint = Vector2.new(0.5, 0.5)
	v16.BackgroundTransparency = 1
	v16.BorderSizePixel = 0
	v16.Position = mapped
	v16.Size = props.size
	v16.Visible = state
	return createElement2("ScreenGui", v13, {
		Bounds = createElement3("Frame", v14, {
			Window = createElement4("Frame", v16, {
				DragDetector = dragDetector,
				Content = props.children
			})
		})
	})
end

return Window
