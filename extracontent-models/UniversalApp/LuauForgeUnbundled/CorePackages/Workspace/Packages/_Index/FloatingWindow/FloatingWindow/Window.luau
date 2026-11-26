local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FloatingWindow/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/FloatingWindow/ReactRoblox")

local BehaviorKind = require("@game/CorePackages/Workspace/Packages/_Index/FloatingWindow/FloatingWindow/BehaviorKind")
local Behaviors = require("@game/CorePackages/Workspace/Packages/_Index/FloatingWindow/FloatingWindow/Behaviors")
local Geometry = require("@game/CorePackages/Workspace/Packages/_Index/FloatingWindow/FloatingWindow/Geometry")
require("@game/CorePackages/Workspace/Packages/_Index/FloatingWindow/FloatingWindow/Types")

local udim = UDim2.fromScale(0.5, 0.5)

local v5 = { bottom = 0, left = 0, right = 0, top = 0 }

local function Window(props)
	assert(
		(props.behavior or Behaviors.Contained).kind == BehaviorKind.Contained,
		"FloatingWindow only supports Contained behavior"
	)

	local boundsInsets = props.boundsInsets or v5

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
	local v6, v7 = React.useBinding(Vector2.zero)

	local v8 = React.useCallback(function()
		local current = ref2.current
		local current2 = ref3.current

		if not (Geometry.hasPositiveSize(current) and Geometry.hasPositiveSize(current2)) then
			return
		end

		if ref4.current then
			if not ref5.current then
				v7((Geometry.clampCenter(ref8.current, current, current2)))
			end
		else
			ref4.current = true
			local center = Geometry.resolveCenter(props.initialCenter or udim, current)
			ref8.current = center
			v7((Geometry.clampCenter(center, current, current2)))
			setState(true)
		end
	end, { props.initialCenter, v7 })

	local v9 = React.useCallback(function(p2)
		local absoluteSize = p2.AbsoluteSize

		if absoluteSize == ref2.current then
			return
		end

		ref2.current = absoluteSize
		v8()
	end, { v8 })

	local v10 = React.useCallback(function(p2)
		local absoluteSize = p2.AbsoluteSize

		if absoluteSize == ref3.current then
			return
		end

		ref3.current = absoluteSize
		v8()
	end, { v8 })

	local v11 = React.useCallback(function(p2)
		if not ref5.current then
			return
		end

		local v12 = p2 - ref6.current

		if v12.Magnitude > (props.dragThreshold or 25) then
			ref9.current = true
		end

		local v13 = ref7.current + v12
		ref8.current = v13
		v7((Geometry.clampCenter(v13, ref2.current, ref3.current)))
	end, { props.dragThreshold, v7 })

	local v12 = React.useCallback(function(p2, current)
		if not ref4.current then
			return
		end

		ref5.current = true
		ref9.current = false
		ref6.current = current
		ref7.current = v6:getValue()
	end, { v6 })

	local v13 = React.useCallback(function(p2, p3)
		v11(p3)
	end, { v11 })

	local v14 = React.useCallback(function(p2, p3)
		v11(p3)
		ref5.current = false

		if not ref9.current and props.onActivated ~= nil then
			props.onActivated()
		end
	end, { v6, props.onActivated, v11 })

	React.useLayoutEffect(function()
		if props.draggable ~= false then
			return
		end

		ref5.current = false
		ref9.current = false
		v8()
	end, { props.draggable, v8 })

	local mapped = v6:map(function(p2)
		return UDim2.fromOffset(p2.X, p2.Y)
	end)

	local createElement = React.createElement
	local tag = React.Tag
	local v17 = if props.testId ~= nil then `data-testid={props.testId}-drag-detector` else nil
	local v18 = createElement("UIDragDetector", {
		[tag] = v17,
		BoundingUI = ref,
		DragStyle = Enum.UIDragDetectorDragStyle.Scriptable,
		ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomOffset,
		[React.Event.DragContinue] = v13,
		[React.Event.DragEnd] = v14,
		[React.Event.DragStart] = v12
	})

	if props.draggable == false then
		v18 = nil
	elseif props.dragInputTarget ~= nil then
		v18 = ReactRoblox.createPortal({ DragDetector = v18 }, props.dragInputTarget)
	end

	local createElement2 = React.createElement
	local tag2 = React.Tag
	local v21 = if props.testId ~= nil then `data-testid={props.testId}-screen` else nil
	local v20 = {
		[tag2] = v21,
		DisplayOrder = props.displayOrder or 0,
		Enabled = props.enabled ~= false,
		Name = "FloatingWindow",
		ResetOnSpawn = false,
		ScreenInsets = props.screenInsets or Enum.ScreenInsets.CoreUISafeInsets,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}

	local createElement3 = React.createElement
	local v24 = { [React.Change.AbsoluteSize] = v9 }
	local tag3 = React.Tag
	local v25 = if props.testId ~= nil then `data-testid={props.testId}-bounds` else nil
	v24[tag3] = v25
	v24.BackgroundTransparency = 1
	v24.BorderSizePixel = 0

	v24.Position = UDim2.fromOffset(boundsInsets.left, boundsInsets.top)
	v24.ref = ref
	v24.Size = UDim2.new(
		1,
		-(boundsInsets.left + boundsInsets.right),
		1,
		-(boundsInsets.top + boundsInsets.bottom)
	)

	local createElement4 = React.createElement
	local v28 = { [React.Change.AbsoluteSize] = v10 }
	local tag4 = React.Tag
	local v29 = if props.testId ~= nil then `data-testid={props.testId}` else nil
	v28[tag4] = v29

	v28.Active = true
	v28.AnchorPoint = Vector2.new(0.5, 0.5)
	v28.BackgroundTransparency = 1
	v28.BorderSizePixel = 0
	v28.Position = mapped
	v28.Size = props.size
	v28.Visible = state
	return createElement2("ScreenGui", v20, {
		Bounds = createElement3("Frame", v24, {
			Window = createElement4("Frame", v28, {
				DragDetector = v18,
				Content = props.children
			})
		})
	})
end

return Window
