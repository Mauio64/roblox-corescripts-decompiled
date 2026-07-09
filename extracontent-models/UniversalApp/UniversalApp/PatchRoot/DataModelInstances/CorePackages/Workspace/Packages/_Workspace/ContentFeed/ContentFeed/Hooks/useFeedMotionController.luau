local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local UserInputService = game:GetService("UserInputService")
local AppCommonLib = require(ParentParentParent.AppCommonLib)
local CapturesCommon = require(ParentParentParent.CapturesCommon)
local React = require(ParentParentParent.React)
local RobloxAppHooks = require(ParentParentParent.RobloxAppHooks)
local ReactUtils = require(ParentParentParent.ReactUtils)
local Otter = require(ParentParentParent.Otter)
local Signal = AppCommonLib.Signal
local FeedDirectionType = require(ParentParent.Enums.FeedDirectionType)
local NavigationType = require(ParentParent.Enums.NavigationType)
local useEventConnection = ReactUtils.useEventConnection
local useGuiInset = CapturesCommon.Hooks.useGuiInset
local useRef = React.useRef
local useScreenSize = RobloxAppHooks.useScreenSize

local function v17(n1: number, n2: number, p1: ((...any) -> ...any), p2: ((...any) -> ...any), t1: {[any]: any}) -- line: 27
	-- upvalues: Otter (copy)
	local v24 = Otter.createSingleMotor(n1)

	v24:onStep(p1)
	v24:onComplete(p2)
	t1.current = true
	v24:setGoal(Otter.spring(n2, {
		frequency = 8
	}))
end
local function useFeedMotionController(b1: boolean, b2: boolean, n3: number, b3: boolean) -- line: 41
	-- upvalues: useScreenSize (copy), useGuiInset (copy), useRef (copy), Signal (copy), useEventConnection (copy), UserInputService (copy), NavigationType (copy), v17 (copy), React (copy), FeedDirectionType (copy)
	local v29 = useScreenSize()
	local v30 = useGuiInset()
	local v31 = useRef(nil)
	local v32 = useRef(false)
	local v33 = useRef(false)
	local v34 = useRef(nil)
	local v35 = useRef(nil)
	local v36 = useRef(nil)
	local v37 = useRef(Signal.new())

	useEventConnection(UserInputService.TouchPinch, function(_, _, _, p6, _) -- line: 69
		-- upvalues: v33 (copy)
		if p6 == Enum.UserInputState.Begin then
			v33.current = true
		end
	end)
	useEventConnection(UserInputService.TouchStarted, function(p8) -- line: 76
		-- upvalues: v32 (copy), v34 (copy), v31 (copy), v36 (copy), b3 (copy), v35 (copy)
		v32.current = false

		if v34.current == nil and (v31.current and v36.current == nil and not b3) then
			v34.current = v31.current.Position.Y.Offset
			v35.current = p8.Position.Y
			v36.current = p8
		end
	end)
	useEventConnection(UserInputService.TouchMoved, function(p9) -- line: 90
		-- upvalues: v31 (copy), v33 (copy), v34 (copy), v35 (copy), v36 (copy), b3 (copy), b1 (copy), b2 (copy)
		if v31.current and (not v33.current and v34.current ~= nil and v35.current ~= nil and p9 == v36.current and not b3) then
			local v50 = p9.Position.Y - v35.current

			if b1 then
				v50 = math.min(v50, 100)
			end

			if b2 then
				v50 = math.max(v50, -100)
			end

			v31.current.Position = UDim2.fromOffset(0, v34.current + v50)
		end
	end)
	useEventConnection(UserInputService.TouchSwipe, function(p10) -- line: 113
		-- upvalues: v31 (copy), v32 (copy), v33 (copy), b3 (copy), b1 (copy), b2 (copy), v29 (copy), NavigationType (copy), v30 (copy), n3 (copy), v37 (copy), v17 (copy)
		if not v31.current or (v32.current or v33.current or b3) then
			return
		end

		assert(v31.current ~= nil, "feedMotionRef.current is nil")

		if b1 and p10 == Enum.SwipeDirection.Down then
			return
		end

		if b2 and p10 == Enum.SwipeDirection.Up then
			return
		end

		local n4 = 0

		if p10 == Enum.SwipeDirection.Up and v31.current.Position.Y.Offset % v29.Y > v29.Y / 2 then
			n4 = v29.Y
		elseif p10 == Enum.SwipeDirection.Down and v31.current.Position.Y.Offset % v29.Y < v29.Y / 2 then
			n4 = -v29.Y
		end

		local v53 = if p10 ~= Enum.SwipeDirection.Up then NavigationType.NavigatedToNextItem else NavigationType.NavigatedToPreviousItem
		local YOffset = v31.current.Position.Y.Offset
		local v55 = v31.current.Position.Y.Offset - n4
		local Y = v29.Y
		local v57 = v55 % Y
		local v58 = math.clamp(if not (v57 > Y / 2) then v55 - v57 - v30.top else math.min(v55 + (Y - v57), 0) - v30.top, -(n3 - 1) * v29.Y - v30.top, 0)

		v17(YOffset, v58, function(n5: number) -- line: 152
			-- upvalues: v31 (copy)
			if not v31.current then
				return
			end

			v31.current.Position = UDim2.fromOffset(0, n5)
		end, function() -- line: 158
			-- upvalues: YOffset (copy), v58 (copy), v32 (copy), v37 (copy), v53 (copy)
			if math.abs(YOffset - v58) < 2 then
				return
			end

			v32.current = false
			v37.current:fire(v53)
		end, v32)
	end)
	useEventConnection(UserInputService.TouchEnded, function(p11) -- line: 169
		-- upvalues: v36 (copy), v31 (copy), v34 (copy), v32 (copy), b3 (copy), v29 (copy), v30 (copy), v33 (copy), NavigationType (copy), v37 (copy), v17 (copy)
		if p11 == v36.current then
			v36.current = nil
		end

		if not v31.current or not v34.current or v32.current or v36.current ~= nil or b3 then
			return
		end

		assert(v31.current ~= nil, "feedMotionRef.current is nil")
		assert(v34.current ~= nil, "feedStartPositionYOffset.current is nil")

		local current = v34.current
		local Y = v29.Y
		local v62 = current % Y
		local v63 = if not (v62 > Y / 2) then current - v62 - v30.top else math.min(current + (Y - v62), 0) - v30.top
		local YOffset = v31.current.Position.Y.Offset
		local Y2 = v29.Y
		local v66 = YOffset % Y2
		local v67 = if not (v66 > Y2 / 2) then YOffset - v66 - v30.top else math.min(YOffset + (Y2 - v66), 0) - v30.top
		local u68 = if not v33.current then if not (v63 < v67) then if not (v67 < v63) then NavigationType.NavigatedToCurrentItem else NavigationType.NavigatedToNextItem else NavigationType.NavigatedToPreviousItem else NavigationType.NavigatedToCurrentItem

		v34.current = nil

		local YOffset2 = v31.current.Position.Y.Offset

		task.wait()
		v33.current = false

		if not v31.current then
			return
		end

		if YOffset2 ~= v31.current.Position.Y.Offset then
			return
		end

		local YOffset3 = v31.current.Position.Y.Offset

		v17(YOffset3, v67, function(n6: number) -- line: 219
			-- upvalues: v31 (copy)
			if not v31.current then
				return
			end

			v31.current.Position = UDim2.fromOffset(0, n6)
		end, function() -- line: 225
			-- upvalues: v32 (copy), u68 (ref), v37 (copy)
			v32.current = false

			if u68 then
				v37.current:fire(u68)
			end
		end, v32)
	end)

	local v38 = React.useCallback(function(p12) -- line: 235
		-- upvalues: v31 (copy), v32 (copy), FeedDirectionType (copy), v29 (copy), v30 (copy), n3 (copy), v37 (copy), NavigationType (copy), v17 (copy)
		if not v31.current or v32.current then
			return
		end

		assert(v31.current ~= nil, "feedMotionRef.current is nil")

		local n7 = 0

		if p12 == FeedDirectionType.Up then
			n7 = -v29.Y
		elseif p12 == FeedDirectionType.Down then
			n7 = v29.Y
		end

		local YOffset = v31.current.Position.Y.Offset
		local v74 = v31.current.Position.Y.Offset - n7
		local Y = v29.Y
		local v76 = v74 % Y
		local v77 = math.clamp(if not (v76 > Y / 2) then v74 - v76 - v30.top else math.min(v74 + (Y - v76), 0) - v30.top, -(n3 - 1) * v29.Y, 0)

		v32.current = true
		v17(YOffset, v77, function(n8: number) -- line: 255
			-- upvalues: v77 (copy), v31 (copy)
			if v77 - n8 < 2 and v77 - n8 > -2 then
				v31.current.Position = UDim2.fromOffset(0, v77)

				return
			end

			v31.current.Position = UDim2.fromOffset(0, n8)
		end, function() -- line: 262
			-- upvalues: v32 (copy), p12 (copy), FeedDirectionType (copy), v37 (copy), NavigationType (copy)
			v32.current = false

			if p12 == FeedDirectionType.Down then
				v37.current:fire(NavigationType.NavigatedToPreviousItem)

				return
			end

			if p12 == FeedDirectionType.Up then
				v37.current:fire(NavigationType.NavigatedToNextItem)
			end
		end, v32)
	end, {
		n3,
		v29
	})
	local v39 = React.useCallback(function(n9: number) -- line: 275
		-- upvalues: b3 (copy), b1 (copy), v38 (copy), FeedDirectionType (copy), b2 (copy)
		if b3 then
			return
		end

		if n9 > 0 and not b1 then
			v38(FeedDirectionType.Up)

			return
		end

		if n9 < 0 and not b2 then
			v38(FeedDirectionType.Down)
		end
	end, {
		b3,
		b1,
		b2,
		v38
	})

	useEventConnection(UserInputService.PointerAction, v39)

	return v31, v37.current, v38
end

return useFeedMotionController
