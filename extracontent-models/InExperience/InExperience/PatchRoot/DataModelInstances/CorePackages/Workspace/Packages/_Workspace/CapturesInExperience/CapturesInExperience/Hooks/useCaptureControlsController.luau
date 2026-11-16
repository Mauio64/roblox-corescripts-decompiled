local parent = script.Parent.Parent
local parent2 = parent.Parent

local CapturesCommon = require(parent2.CapturesCommon)
local React = require(parent2.React)
local ReactOtter = require(parent2.ReactOtter)

local useAnimatedBinding = ReactOtter.useAnimatedBinding
local useCallback = React.useCallback
local Responsive = require(parent2.Responsive)
local useDeviceInsets = Responsive.useDeviceInsets
local useEffect = React.useEffect
local useGuiInset = CapturesCommon.Hooks.useGuiInset
local useRef = React.useRef
local useState = React.useState

local CaptureControlsConfiguration = require(parent.Utils.CaptureControlsConfiguration)

local SnapDirection = require(parent.Enums.SnapDirection)
local engineFeature = game:GetEngineFeature("UIDragDetectorFixEventPositionEnabled")

local v = { x = 0.5, y = 0.5 }
local v2 = { xOffset = -100, yOffset = -100 }
local vector2 = Vector2.new(1, 0.5)
local Right = SnapDirection.Right

local v3 = {
	duration = 0.4,
	easingStyle = { 0.19, 1, 0.22, 1 }
}

local function validateRefs(items): boolean
	for _, item in items do
		if item.current == nil or (item.current.AbsoluteSize.X <= 0 or item.current.AbsoluteSize.Y <= 0) then
			return false
		end
	end

	return true
end

local function clampItemPosition(vector2_2: Vector2, vector2_3: Vector2, vector2_4: Vector2, vector2_5: Vector2, vector2_6: Vector2)
	local v4 = vector2_2 - vector2_4
	local y = vector2_6.Y

	local v5 = not (vector2_5.X - 50 > vector2_3.X) and 50 or math.clamp(v4.X, 50, vector2_5.X - vector2_3.X - 50)

	if vector2_5.Y - y > vector2_3.Y then
		y = math.clamp(v4.Y, y, vector2_5.Y - vector2_3.Y)
	end

	return Vector2.new(v5, y)
end

local function getSnapPosition(vector2_2: Vector2, vector2_3: Vector2, absolutePosition: Vector2, absoluteSize: Vector2, vector2_4: Vector2, current: Vector2)
	return (clampItemPosition(
		Vector2.new(absoluteSize.X * vector2_4.X, absoluteSize.Y * vector2_4.Y) - Vector2.new(
			vector2_2.X * vector2_3.X,
			vector2_2.Y * vector2_3.Y
		) + absolutePosition,
		vector2_2,
		absolutePosition,
		absoluteSize,
		current
	))
end

local function getSnapAnchorPoint(vector2_2: Vector2, absolutePosition: Vector2, absoluteSize: Vector2, current: Vector2)
	local v4 = vector2_2 - absolutePosition

	local v5 = {
		Vector2.new(0, (math.max(v4.Y, current.Y))),
		Vector2.new(absoluteSize.X, v4.Y),
		Vector2.new(math.max(v4.X, current.X), 0),
		Vector2.new(v4.X, absoluteSize.Y)
	}

	table.sort(v5, function(a, b): boolean
		return (a - v4).Magnitude < (b - v4).Magnitude
	end)

	local v6 = v5[1]
	local magnitude = (v6 - v4).Magnitude
	return v6 / absoluteSize, magnitude
end

local function getSnapDirectionFromAnchorPoint(vector2_2: Vector2) -- 2 equivalent calls inferred from this helper
	if vector2_2.X == 0 then
		return SnapDirection.Left
	end

	if vector2_2.X == 1 then
		return SnapDirection.Right
	end

	if vector2_2.Y == 0 then
		return SnapDirection.Top
	end

	return SnapDirection.Bottom
end

local function getShouldRotate(flag: boolean, vector2_2: Vector2)
	local v4 = vector2_2.X == 0 or vector2_2.X == 1
	local v5 = vector2_2.Y == 0 or vector2_2.Y == 1

	if v4 and v5 then
		return false
	end

	if v5 and not flag then
		return true
	end

	return v4 and flag and true or false
end

local function useCaptureControlsController(flag: boolean, current: Vector2)
	local v4 = useRef(current)
	local dragContainerRef = useRef(nil)
	local dragDetectorRef = useRef(nil)
	local dragItemRef = useRef(nil)
	local v5 = useRef(false)
	local screenshotButtonRef = useRef(nil)
	local v6 = useRef(CaptureControlsConfiguration.getStoredSnapAnchorPoint())

	local state, setState = useState(vector2)
	local state2, setState2 = useState(false)
	local state3, setState3 = useState(false)
	local state4, setState4 = useState(Right)

	local v7 = useGuiInset()
	local v8 = useDeviceInsets()

	local v9 = useCallback(function()
		v5.current = false
	end, {})

	local dragItemAnchorPointBinding, v10 = useAnimatedBinding(v)

	local dragItemPositionBinding, v11 = useAnimatedBinding(v2, v9)

	useEffect(function()
		if not (flag and validateRefs({ dragItemRef, dragContainerRef })) then
			return
		end

		assert(dragItemRef.current ~= nil, "dragItemRef is nil")
		assert(dragContainerRef.current ~= nil, "dragContainerRef is nil")

		v4.current = current

		local current2 = v6.current

		setState(current2)
		setState4(getSnapDirectionFromAnchorPoint(current2)) -- inferred equivalent call

		local v12 = dragItemRef.current.AbsoluteSize
		local v13 = dragItemRef.current.AnchorPoint

		local isItemHorizontal = state3
		local v14 = current2.X == 0 or current2.X == 1
		local v15 = current2.Y == 0 or current2.Y == 1
		local v16

		if v14 and v15 then
			v16 = false
		else
			v16 = v15 and not isItemHorizontal and true or v14 and isItemHorizontal and true or false
		end

		if v16 then
			v12 = Vector2.new(v12.Y, v12.X)
			v13 = Vector2.new(v13.Y, v13.X)
			v10({ x = ReactOtter.ease(v13.X, v3), y = ReactOtter.ease(v13.Y, v3) })

			setState3(not state3)
		end

		local snapPosition = getSnapPosition(
			v12,
			v13,
			dragContainerRef.current.AbsolutePosition,
			dragContainerRef.current.AbsoluteSize,
			current2,
			current
		)

		local vector2_2 = Vector2.new(v12.X * v13.X, v12.Y * v13.Y)

		v11({
			xOffset = ReactOtter.instant(snapPosition.X + vector2_2.X),
			yOffset = ReactOtter.instant(snapPosition.Y + vector2_2.Y)
		})
	end, { flag, current, v10, v11 })

	local v12 = useCallback(function()
		if not flag or v5.current or not validateRefs({ dragItemRef, dragContainerRef }) then
			return
		end

		assert(dragItemRef.current ~= nil, "dragItemRef is nil")
		assert(dragContainerRef.current ~= nil, "dragContainerRef is nil")

		local absoluteSize = dragItemRef.current.AbsoluteSize
		local anchorPoint = dragItemRef.current.AnchorPoint

		local snapPosition = getSnapPosition(
			absoluteSize,
			anchorPoint,
			dragContainerRef.current.AbsolutePosition,
			dragContainerRef.current.AbsoluteSize,
			state,
			current
		)

		local vector2_2 = Vector2.new(absoluteSize.X * anchorPoint.X, absoluteSize.Y * anchorPoint.Y)

		v11({
			xOffset = ReactOtter.instant(snapPosition.X + vector2_2.X),
			yOffset = ReactOtter.instant(snapPosition.Y + vector2_2.Y)
		})
	end, { flag, current, state, state2, v11 })

	local function fn(vector2_2: Vector2)
		if not flag or state2 or not validateRefs({ dragContainerRef, dragItemRef }) then
			return
		end

		assert(dragItemRef.current ~= nil, "dragItemRef is nil")
		assert(dragContainerRef.current ~= nil, "dragContainerRef is nil")

		local v13 = vector2_2 - Vector2.new(v7.left + v8.left, v7.top + v8.top)
		setState2(true)

		local absoluteSize = dragItemRef.current.AbsoluteSize
		local absolutePosition = dragItemRef.current.AbsolutePosition
		local _anchorPoint = dragItemRef.current.AnchorPoint

		local v14 = clampItemPosition(
			absolutePosition,
			absoluteSize,
			dragContainerRef.current.AbsolutePosition,
			dragContainerRef.current.AbsoluteSize,
			current
		)
		local v15

		if state3 then
			local v16 = if engineFeature then vector2_2 else v13
			v15 = (v16.X - absolutePosition.X) / absoluteSize.X
		else
			v15 = 0.5
		end

		local v16

		if state3 then
			v16 = 0.5
		else
			if engineFeature then
				v13 = vector2_2
			end

			v16 = (v13.Y - absolutePosition.Y) / absoluteSize.Y
		end

		local vector2_3 = Vector2.new(v15, v16)

		v10({
			x = ReactOtter.instant(vector2_3.X),
			y = ReactOtter.instant(vector2_3.Y)
		})

		local vector2_4 = Vector2.new(absoluteSize.X * vector2_3.X, absoluteSize.Y * vector2_3.Y)

		v11({
			xOffset = ReactOtter.instant(v14.X + vector2_4.X),
			yOffset = ReactOtter.instant(v14.Y + vector2_4.Y)
		})
	end

	local v13

	if not engineFeature then
		v13 = v8
	end

	local v14

	if not engineFeature then
		v14 = v7
	end

	local v15 = useCallback(fn, {
		flag,
		current,
		clampItemPosition,
		v13,
		v14,
		state2,
		state3,
		v11,
		v10
	})

	local function fn2(vector2_2: Vector2, flag2: boolean)
		if not validateRefs({ dragItemRef, dragContainerRef }) then
			return
		end

		assert(dragItemRef.current ~= nil, "dragItemRef is nil")
		assert(dragContainerRef.current ~= nil, "dragContainerRef is nil")

		local v16 = vector2_2 - Vector2.new(v7.left + v8.left, v7.top + v8.top)

		local absolutePosition = dragContainerRef.current.AbsolutePosition
		local absoluteSize = dragContainerRef.current.AbsoluteSize
		local v17 = if engineFeature then vector2_2 else v16
		local snapAnchorPoint, v18 = getSnapAnchorPoint(v17, absolutePosition, absoluteSize, current)

		local v19 = v18 < 70 or not flag2

		local v20 = dragItemRef.current.AbsoluteSize
		local v21 = dragItemRef.current.AnchorPoint

		local isItemHorizontal = state3
		local v22 = snapAnchorPoint.X == 0 or snapAnchorPoint.X == 1
		local v23 = snapAnchorPoint.Y == 0 or snapAnchorPoint.Y == 1
		local v24

		if v22 and v23 then
			v24 = false
		else
			v24 = v23 and not isItemHorizontal and true or v22 and isItemHorizontal and true or false
		end

		if v19 and v24 then
			v20 = Vector2.new(v20.Y, v20.X)
			v21 = Vector2.new(v21.Y, v21.X)
			v10({ x = ReactOtter.instant(v21.X), y = ReactOtter.instant(v21.Y) })

			setState3(not state3)
		end

		local vector2_3 = Vector2.new(v20.X * v21.X, v20.Y * v21.Y)
		local v25

		if v19 then
			v25 = getSnapPosition(v20, v21, absolutePosition, absoluteSize, snapAnchorPoint, current)
		else
			if engineFeature then
				v16 = vector2_2
			end

			v25 = clampItemPosition(v16 - vector2_3, v20, absolutePosition, absoluteSize, current)
		end

		if flag2 then
			v11({
				xOffset = ReactOtter.instant(v25.X + vector2_3.X),
				yOffset = ReactOtter.instant(v25.Y + vector2_3.Y)
			})
			return
		end

		v5.current = true
		v11({
			xOffset = ReactOtter.ease(v25.X + vector2_3.X, v3),
			yOffset = ReactOtter.ease(v25.Y + vector2_3.Y, v3)
		})

		setState(snapAnchorPoint)
		setState4(getSnapDirectionFromAnchorPoint(snapAnchorPoint)) -- inferred equivalent call

		CaptureControlsConfiguration.setStoredSnapAnchorPoint(snapAnchorPoint)
		v6.current = snapAnchorPoint
	end

	local v16

	if not engineFeature then
		v16 = v8
	end

	local v17

	if not engineFeature then
		v17 = v7
	end

	local v18 = useCallback(fn2, { current, v16, v17, state3, v11, v10 })

	local v19 = useCallback(function(vector2_2: Vector2)
		if flag and state2 then
			v18(vector2_2, true)
		end
	end, { flag, v18, state2 })

	local v20 = useCallback(function(vector2_2: Vector2)
		if flag and state2 then
			v18(vector2_2, false)
			setState2(false)
		end
	end, { flag, v18, state2 })

	useEffect(function()
		if not flag then
			return
		end

		if v4.current ~= current then
			v4.current = current
			v12()
		end
	end, { flag, current, v12 })

	useEffect(function()
		if not flag then
			return
		end

		local connections = {}

		if dragDetectorRef.current ~= nil then
			table.insert(connections, dragDetectorRef.current.DragStart:Connect(v15))
			table.insert(connections, dragDetectorRef.current.DragContinue:Connect(v19))
			table.insert(connections, dragDetectorRef.current.DragEnd:Connect(v20))
		end

		if dragContainerRef.current ~= nil then
			table.insert(connections, dragContainerRef.current:GetPropertyChangedSignal("AbsoluteSize"):Connect(v12))
		end

		if dragItemRef.current ~= nil then
			table.insert(connections, dragItemRef.current:GetPropertyChangedSignal("AbsoluteSize"):Connect(v12))
		end

		return function()
			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, { flag, v15, v19, v20, v12 })

	return {
		dragContainerRef = dragContainerRef,
		dragDetectorRef = dragDetectorRef,
		dragItemAnchorPointBinding = dragItemAnchorPointBinding,
		dragItemPositionBinding = dragItemPositionBinding,
		dragItemRef = dragItemRef,
		isItemHorizontal = state3,
		screenshotButtonRef = screenshotButtonRef,
		snapDirection = state4
	}
end

return useCaptureControlsController
