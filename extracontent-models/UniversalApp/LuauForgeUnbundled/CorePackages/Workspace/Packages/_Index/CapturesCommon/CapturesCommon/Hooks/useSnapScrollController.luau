local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/ReactOtter")
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/ReactUtils")

local NavigationType = require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Enums/NavigationType")

local isPointWithinBounds = require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Utils/isPointWithinBounds")

local useCallback = React.useCallback
local useEffect = React.useEffect
local useEventConnection = ReactUtils.useEventConnection
local useMotor = ReactOtter.useMotor
local useRef = React.useRef
local useState = React.useState

local function useSnapScrollController(p2, p3, current, max)
	local v5 = useRef(nil)
	local state, setState = useState(p3)
	local v6 = useRef(nil)
	local v7 = useRef(false)
	local v8 = useRef(nil)
	local v9 = useRef(nil)
	local v10 = useRef(nil)
	local v11 = useRef(nil)
	local v12 = useRef(false)

	local v13 = useCallback(function(p4)
		if not v6.current then
			return
		end

		v6.current.Position = UDim2.new(0.5, 0, 0, p4)
	end, {})

	local v14 = useCallback(function()
		v7.current = false
	end, {})

	local v15 = useMotor((p3 - 1) * -current.Y, v13, v14)

	local v16 = React.useCallback(function(value, p4)
		if not p2 or not v6.current or not v5.current or v7.current or v12.current or max < 1 then
			return
		end

		assert(v6.current ~= nil, "motionRef.current is nil")

		v7.current = true

		local v17 = math.clamp(value, 1, max)
		local v18 = (v17 - 1) * -current.Y

		if p4 then
			v15(ReactOtter.instant(v18))
		else
			v15(ReactOtter.spring(v18, { frequency = 8 }))
		end

		setState(v17)
	end, { p2, current, max, v15 })

	local v17 = React.useCallback(function(p4, p5)
		if p4 == NavigationType.Previous then
			v16(state - 1, p5)
		elseif p4 == NavigationType.Next then
			v16(state + 1, p5)
		else
			v16(state, p5)
		end
	end, { state, v16 })

	useEffect(function()
		if not v6.current or v8.current == current then
			return
		end

		v7.current = false
		v17(NavigationType.Current, true)
		v8.current = current
	end, { current, v17 })

	local v18 = React.useCallback(function(p4, p5, p6, p7, p8)
		if p7 == Enum.UserInputState.Begin then
			v17(NavigationType.Current)
			v12.current = true
		elseif p7 == Enum.UserInputState.End then
			v12.current = false
			v10.current = nil
		end
	end, { v17 })

	useEventConnection(UserInputService.TouchPinch, v18)

	local v19 = React.useCallback(function(current2)
		if not p2 or not v6.current or not v5.current or v10.current then
			return
		end

		if not isPointWithinBounds(
			Vector2.new(current2.Position.X, current2.Position.Y),
			v5.current.AbsolutePosition,
			v5.current.AbsoluteSize
		) then
			return
		end

		v9.current = v6.current.Position.Y.Offset
		v11.current = current2.Position.Y
		v10.current = current2
		v15(ReactOtter.instant(v6.current.Position.Y.Offset))
	end, { p2, v15 })

	useEventConnection(UserInputService.TouchStarted, v19)

	local v20 = React.useCallback(function(p4)
		if
			not p2
			or not v6.current
			or not v5.current
			or v10.current ~= p4
			or not v9.current
			or not v11.current
			or v12.current
		then
			return
		end

		local v21 = p4.Position.Y - v11.current
		local v22 = math.clamp(v9.current + v21, (max - 1) * -current.Y - 100, 100)

		v15(ReactOtter.instant(v22))
	end, { p2, current, max, v15 })

	useEventConnection(UserInputService.TouchMoved, v20)

	local v21 = React.useCallback(function(p4)
		if not p2 or not v6.current or not v5.current or not v10.current or v12.current or v7.current then
			return
		end

		if p4 == Enum.SwipeDirection.Up then
			v17(NavigationType.Next)
		elseif p4 == Enum.SwipeDirection.Down then
			v17(NavigationType.Previous)
		else
			v17(NavigationType.Current)
		end
	end, { p2, v17 })

	useEventConnection(UserInputService.TouchSwipe, v21)

	local v22 = React.useCallback(function(p4)
		if
			not p2
			or not v6.current
			or not v5.current
			or v10.current ~= p4
			or not v9.current
			or v7.current
		then
			return
		end

		local v23 = v6.current.Position.Y.Offset - v9.current

		if -v23 > current.Y * 0.25 then
			v17(NavigationType.Next)
		elseif current.Y * 0.25 < v23 then
			v17(NavigationType.Previous)
		else
			v17(NavigationType.Current)
		end

		v10.current = nil
		v9.current = nil
	end, { p2, current, v17 })

	useEventConnection(UserInputService.TouchEnded, v22)

	local v23 = React.useCallback(function(p4, p5)
		if not p2 then
			return
		end

		if p4 < 0 or p5.Y < -0.1 then
			v17(NavigationType.Next)
		elseif p4 > 0 or p5.Y > 0.1 then
			v17(NavigationType.Previous)
		end
	end, { p2, v17 })

	useEventConnection(UserInputService.PointerAction, v23)

	return state, v5, v6, v16, v17
end

return useSnapScrollController
