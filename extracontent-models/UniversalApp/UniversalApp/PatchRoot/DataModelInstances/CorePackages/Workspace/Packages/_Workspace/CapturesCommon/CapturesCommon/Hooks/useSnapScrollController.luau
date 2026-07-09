local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local UserInputService = game:GetService("UserInputService")
local React = require(ParentParentParent.React)
local ReactOtter = require(ParentParentParent.ReactOtter)
local ReactUtils = require(ParentParentParent.ReactUtils)
local NavigationType = require(ParentParent.Enums.NavigationType)
local isPointWithinBounds = require(ParentParent.Utils.isPointWithinBounds)
local useCallback = React.useCallback
local useEffect = React.useEffect
local useEventConnection = ReactUtils.useEventConnection
local useMotor = ReactOtter.useMotor
local useRef = React.useRef
local useState = React.useState

local function useSnapScrollController(b1: boolean, n1: number, vector2: Vector2, n2: number) -- line: 26
	-- upvalues: useRef (copy), useState (copy), useCallback (copy), useMotor (copy), React (copy), ReactOtter (copy), NavigationType (copy), useEffect (copy), useEventConnection (copy), UserInputService (copy), isPointWithinBounds (copy)
	local v20 = useRef(nil)
	local v21, v22 = useState(n1)
	local v23 = useRef(nil)
	local v24 = useRef(false)
	local v25 = useRef(nil)
	local v26 = useRef(nil)
	local v27 = useRef(nil)
	local v28 = useRef(nil)
	local v29 = useRef(false)
	local v30 = useCallback(function(p1) -- line: 42
		-- upvalues: v23 (copy)
		if not v23.current then
			return
		end

		v23.current.Position = UDim2.new(0.5, 0, 0, p1)
	end, {})
	local v31 = useCallback(function() -- line: 50
		-- upvalues: v24 (copy)
		v24.current = false
	end, {})
	local v32 = useMotor((n1 - 1) * -vector2.Y, v30, v31)
	local v33 = React.useCallback(function(n3: number, b2: boolean?) -- line: 57
		-- upvalues: b1 (copy), v23 (copy), v20 (copy), v24 (copy), v29 (copy), n2 (copy), vector2 (copy), v32 (copy), ReactOtter (copy), v22 (copy)
		if not b1 or (not v23.current or not v20.current or v24.current or v29.current or n2 < 1) then
			return
		end

		assert(v23.current ~= nil, "motionRef.current is nil")
		v24.current = true

		local v44 = math.clamp(n3, 1, n2)
		local v45 = (v44 - 1) * -vector2.Y

		if b2 then
			v32(ReactOtter.instant(v45))
		else
			v32(ReactOtter.spring(v45, {
				frequency = 8
			}))
		end

		v22(v44)
	end, {
		b1,
		vector2,
		n2,
		v32
	})
	local v34 = React.useCallback(function(p2, b3: boolean?) -- line: 86
		-- upvalues: NavigationType (copy), v33 (copy), v21 (copy)
		if p2 == NavigationType.Previous then
			v33(v21 - 1, b3)

			return
		end

		if p2 == NavigationType.Next then
			v33(v21 + 1, b3)

			return
		end

		v33(v21, b3)
	end, {
		v21,
		v33
	})

	useEffect(function() -- line: 96
		-- upvalues: v23 (copy), v25 (copy), vector2 (copy), v24 (copy), v34 (copy), NavigationType (copy)
		if not v23.current or v25.current == vector2 then
			return
		end

		v24.current = false
		v34(NavigationType.Current, true)
		v25.current = vector2
	end, {
		vector2,
		v34
	})

	local v35 = React.useCallback(function(_, _, _, p6, _) -- line: 106
		-- upvalues: v34 (copy), NavigationType (copy), v29 (copy), v27 (copy)
		if p6 == Enum.UserInputState.Begin then
			v34(NavigationType.Current)
			v29.current = true

			return
		end

		if p6 == Enum.UserInputState.End then
			v29.current = false
			v27.current = nil
		end
	end, { v34 })

	useEventConnection(UserInputService.TouchPinch, v35)

	local v36 = React.useCallback(function(p8) -- line: 118
		-- upvalues: b1 (copy), v23 (copy), v20 (copy), v27 (copy), isPointWithinBounds (copy), v26 (copy), v28 (copy), v32 (copy), ReactOtter (copy)
		if not b1 or (not v23.current or not v20.current or v27.current) then
			return
		end

		if not isPointWithinBounds(Vector2.new(p8.Position.X, p8.Position.Y), v20.current.AbsolutePosition, v20.current.AbsoluteSize) then
			return
		end

		v26.current = v23.current.Position.Y.Offset
		v28.current = p8.Position.Y
		v27.current = p8
		v32(ReactOtter.instant(v23.current.Position.Y.Offset))
	end, {
		b1,
		v32
	})

	useEventConnection(UserInputService.TouchStarted, v36)

	local v37 = React.useCallback(function(p9) -- line: 140
		-- upvalues: b1 (copy), v23 (copy), v20 (copy), v27 (copy), v26 (copy), v28 (copy), v29 (copy), n2 (copy), vector2 (copy), v32 (copy), ReactOtter (copy)
		if not b1 or (not v23.current or not v20.current or p9 ~= v27.current or not v26.current or not v28.current or v29.current) then
			return
		end

		local v55 = p9.Position.Y - v28.current
		local v56 = math.clamp(v26.current + v55, (n2 - 1) * -vector2.Y - 100, 100)

		v32(ReactOtter.instant(v56))
	end, {
		b1,
		vector2,
		n2,
		v32
	})

	useEventConnection(UserInputService.TouchMoved, v37)

	local v38 = React.useCallback(function(p10) -- line: 166
		-- upvalues: b1 (copy), v23 (copy), v20 (copy), v27 (copy), v29 (copy), v24 (copy), v34 (copy), NavigationType (copy)
		if not b1 or (not v23.current or not v20.current or not v27.current or v29.current or v24.current) then
			return
		end

		if p10 == Enum.SwipeDirection.Up then
			v34(NavigationType.Next)

			return
		end

		if p10 == Enum.SwipeDirection.Down then
			v34(NavigationType.Previous)

			return
		end

		v34(NavigationType.Current)
	end, {
		b1,
		v34
	})

	useEventConnection(UserInputService.TouchSwipe, v38)

	local v39 = React.useCallback(function(p11) -- line: 190
		-- upvalues: b1 (copy), v23 (copy), v20 (copy), v27 (copy), v26 (copy), v24 (copy), vector2 (copy), v34 (copy), NavigationType (copy)
		if not b1 or (not v23.current or not v20.current or p11 ~= v27.current or not v26.current or v24.current) then
			return
		end

		local v59 = v23.current.Position.Y.Offset - v26.current

		if -v59 > vector2.Y * 0.25 then
			v34(NavigationType.Next)
		elseif v59 > vector2.Y * 0.25 then
			v34(NavigationType.Previous)
		else
			v34(NavigationType.Current)
		end

		v27.current = nil
		v26.current = nil
	end, {
		b1,
		vector2,
		v34
	})

	useEventConnection(UserInputService.TouchEnded, v39)

	local v40 = React.useCallback(function(n4: number, vector2_2: Vector2) -- line: 218
		-- upvalues: b1 (copy), v34 (copy), NavigationType (copy)
		if not b1 then
			return
		end

		if n4 < 0 or vector2_2.Y < -0.1 then
			v34(NavigationType.Next)

			return
		end

		if n4 > 0 or vector2_2.Y > 0.1 then
			v34(NavigationType.Previous)
		end
	end, {
		b1,
		v34
	})

	useEventConnection(UserInputService.PointerAction, v40)

	return v21, v20, v23, v33, v34
end

return useSnapScrollController
