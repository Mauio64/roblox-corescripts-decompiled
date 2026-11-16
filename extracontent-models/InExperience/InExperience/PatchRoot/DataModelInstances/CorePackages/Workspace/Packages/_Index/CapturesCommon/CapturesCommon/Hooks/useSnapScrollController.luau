local parent = script.Parent.Parent
local parent2 = parent.Parent

local UserInputService = game:GetService("UserInputService")

local React = require(parent2.React)
local ReactOtter = require(parent2.ReactOtter)
local ReactUtils = require(parent2.ReactUtils)

local NavigationType = require(parent.Enums.NavigationType)

local isPointWithinBounds = require(parent.Utils.isPointWithinBounds)

local useCallback = React.useCallback
local useEffect = React.useEffect
local useEventConnection = ReactUtils.useEventConnection
local useMotor = ReactOtter.useMotor
local useRef = React.useRef
local useState = React.useState

local function useSnapScrollController(flag: boolean, p: number, current: Vector2, max: number)
	local v = useRef(nil)
	local state, setState = useState(p)
	local v2 = useRef(nil)
	local v3 = useRef(false)
	local v4 = useRef(nil)
	local v5 = useRef(nil)
	local v6 = useRef(nil)
	local v7 = useRef(nil)
	local v8 = useRef(false)

	local v9 = useCallback(function(p2)
		if not v2.current then
			return
		end

		v2.current.Position = UDim2.new(0.5, 0, 0, p2)
	end, {})

	local v10 = useCallback(function()
		v3.current = false
	end, {})

	local v11 = useMotor((p - 1) * -current.Y, v9, v10)

	local v12 = React.useCallback(function(value: number, flag2: boolean?)
		if not flag or not v2.current or not v.current or v3.current or v8.current or max < 1 then
			return
		end

		assert(v2.current ~= nil, "motionRef.current is nil")

		v3.current = true

		local v12 = math.clamp(value, 1, max)
		local v13 = (v12 - 1) * -current.Y

		if flag2 then
			v11(ReactOtter.instant(v13))
		else
			v11(ReactOtter.spring(v13, { frequency = 8 }))
		end

		setState(v12)
	end, { flag, current, max, v11 })

	local v13 = React.useCallback(function(p2, flag2: boolean?)
		if p2 == NavigationType.Previous then
			v12(state - 1, flag2)
		elseif p2 == NavigationType.Next then
			v12(state + 1, flag2)
		else
			v12(state, flag2)
		end
	end, { state, v12 })

	useEffect(function()
		if not v2.current or v4.current == current then
			return
		end

		v3.current = false
		v13(NavigationType.Current, true)
		v4.current = current
	end, { current, v13 })

	local v14 = React.useCallback(function(_, _, _, p2, _)
		if p2 == Enum.UserInputState.Begin then
			v13(NavigationType.Current)
			v8.current = true
		elseif p2 == Enum.UserInputState.End then
			v8.current = false
			v6.current = nil
		end
	end, { v13 })

	useEventConnection(UserInputService.TouchPinch, v14)

	local v15 = React.useCallback(function(current2)
		if not flag or not v2.current or not v.current or v6.current then
			return
		end

		if not isPointWithinBounds(
			Vector2.new(current2.Position.X, current2.Position.Y),
			v.current.AbsolutePosition,
			v.current.AbsoluteSize
		) then
			return
		end

		v5.current = v2.current.Position.Y.Offset
		v7.current = current2.Position.Y
		v6.current = current2
		v11(ReactOtter.instant(v2.current.Position.Y.Offset))
	end, { flag, v11 })

	useEventConnection(UserInputService.TouchStarted, v15)

	local v16 = React.useCallback(function(p2)
		if
			not flag
			or not v2.current
			or not v.current
			or v6.current ~= p2
			or not v5.current
			or not v7.current
			or v8.current
		then
			return
		end

		local v16 = p2.Position.Y - v7.current
		local v17 = math.clamp(v5.current + v16, (max - 1) * -current.Y - 100, 100)

		v11(ReactOtter.instant(v17))
	end, { flag, current, max, v11 })

	useEventConnection(UserInputService.TouchMoved, v16)

	local v17 = React.useCallback(function(p2)
		if not flag or not v2.current or not v.current or not v6.current or v8.current or v3.current then
			return
		end

		if p2 == Enum.SwipeDirection.Up then
			v13(NavigationType.Next)
		elseif p2 == Enum.SwipeDirection.Down then
			v13(NavigationType.Previous)
		else
			v13(NavigationType.Current)
		end
	end, { flag, v13 })

	useEventConnection(UserInputService.TouchSwipe, v17)

	local v18 = React.useCallback(function(p2)
		if not flag or not v2.current or not v.current or v6.current ~= p2 or not v5.current or v3.current then
			return
		end

		local v18 = v2.current.Position.Y.Offset - v5.current

		if -v18 > current.Y * 0.25 then
			v13(NavigationType.Next)
		elseif current.Y * 0.25 < v18 then
			v13(NavigationType.Previous)
		else
			v13(NavigationType.Current)
		end

		v6.current = nil
		v5.current = nil
	end, { flag, current, v13 })

	useEventConnection(UserInputService.TouchEnded, v18)

	local v19 = React.useCallback(function(p2: number, vector2: Vector2)
		if not flag then
			return
		end

		if p2 < 0 or vector2.Y < -0.1 then
			v13(NavigationType.Next)
		elseif p2 > 0 or vector2.Y > 0.1 then
			v13(NavigationType.Previous)
		end
	end, { flag, v13 })

	useEventConnection(UserInputService.PointerAction, v19)

	return state, v, v2, v12, v13
end

return useSnapScrollController
