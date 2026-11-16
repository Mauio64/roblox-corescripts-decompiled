local UserInputService = game:GetService("UserInputService")

local module = require("@luauforge/deferred/dXP")
local module2 = require("@luauforge/deferred/dUv")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/React")
local module4 = require("@luauforge/deferred/dWO")
local module5 = require("@luauforge/deferred/dXz")

local module6 = require("@luauforge/deferred/dXC")
local signal = module.Signal

local module7 = require("@luauforge/deferred/dWS")
local module8 = require("@luauforge/deferred/dXK")

local useEventConnection = module5.useEventConnection
local useGuiInset = module2.Hooks.useGuiInset
local useRef = React.useRef
local useScreenSize = module4.useScreenSize

local module9 = require("@luauforge/deferred/dXQ")

local function fn(offset, p2, fn2, fn3, p3)
	local singleMotor = module6.createSingleMotor(offset)
	singleMotor:onStep(fn2)
	singleMotor:onComplete(fn3)
	p3.current = true
	singleMotor:setGoal(module6.spring(p2, { frequency = 8 }))
end

local function useFeedMotionController(p2, p3, p4, p5)
	local v5 = useScreenSize()
	local v6 = useGuiInset()

	local v7 = useRef(nil)
	local v8 = useRef(false)
	local v9 = useRef(false)
	local v10 = useRef(nil)
	local v11 = useRef(nil)
	local v12 = useRef(nil)
	local v13 = useRef(signal.new())

	useEventConnection(UserInputService.TouchPinch, function(p6, p7, p8, p9, p10)
		if p9 == Enum.UserInputState.Begin then
			v9.current = true
		end
	end)

	useEventConnection(UserInputService.TouchStarted, function(current)
		v8.current = false

		if v10.current == nil and v7.current and v12.current == nil and not p5 then
			v10.current = v7.current.Position.Y.Offset
			v11.current = current.Position.Y
			v12.current = current
		end
	end)

	useEventConnection(UserInputService.TouchMoved, function(p6)
		if
			v7.current
			and not v9.current
			and v10.current ~= nil
			and v11.current ~= nil
			and p6 == v12.current
			and not p5
		then
			local v14 = p6.Position.Y - v11.current

			if p2 then
				v14 = math.min(v14, 100)
			end

			if p3 then
				v14 = math.max(v14, -100)
			end

			v7.current.Position = UDim2.fromOffset(0, v10.current + v14)
		end
	end)

	useEventConnection(UserInputService.TouchSwipe, function(p6)
		if not v7.current or v8.current or v9.current or p5 then
			return
		end

		assert(v7.current ~= nil, "feedMotionRef.current is nil")

		if p2 and p6 == Enum.SwipeDirection.Down or p3 and p6 == Enum.SwipeDirection.Up then
			return
		end

		local v14 = 0

		if p6 == Enum.SwipeDirection.Up and v7.current.Position.Y.Offset % v5.Y > v5.Y / 2 then
			v14 = v5.Y
		elseif p6 == Enum.SwipeDirection.Down and v7.current.Position.Y.Offset % v5.Y < v5.Y / 2 then
			v14 = -v5.Y
		end

		local v15

		if p6 == Enum.SwipeDirection.Up then
			v15 = module8.NavigatedToPreviousItem
		else
			v15 = module8.NavigatedToNextItem
		end

		local offset = v7.current.Position.Y.Offset

		local v16 = v7.current.Position.Y.Offset - v14
		local y = v5.Y
		local v17 = v16 % y
		local v18 = if y / 2 < v17 then math.min(v16 + (y - v17), 0) - v6.top else v16 - v17 - v6.top

		local v19 = math.clamp(v18, -(p4 - 1) * v5.Y - v6.top, 0)

		fn(offset, v19, function(p7)
			if not v7.current then
				return
			end

			v7.current.Position = UDim2.fromOffset(0, p7)
		end, function()
			if math.abs(offset - v19) < 2 then
				return
			end

			v8.current = false
			v13.current:fire(v15)
		end, v8)
	end)

	useEventConnection(UserInputService.TouchEnded, function(p6)
		if v12.current == p6 then
			v12.current = nil
		end

		if not v7.current or not v10.current or v8.current or v12.current ~= nil or p5 then
			return
		end

		assert(v7.current ~= nil, "feedMotionRef.current is nil")
		assert(v10.current ~= nil, "feedStartPositionYOffset.current is nil")

		local current = v10.current
		local y = v5.Y
		local v14 = current % y
		local v15 = if y / 2 < v14 then math.min(current + (y - v14), 0) - v6.top else current - v14 - v6.top

		local offset = v7.current.Position.Y.Offset
		local y2 = v5.Y
		local v16 = offset % y2
		local v17 = if y2 / 2 < v16 then math.min(offset + (y2 - v16), 0) - v6.top else offset - v16 - v6.top
		local v18

		if v9.current then
			v18 = module8.NavigatedToCurrentItem
		elseif v15 < v17 then
			v18 = module8.NavigatedToPreviousItem
		else
			v18 = if v17 < v15 then module8.NavigatedToNextItem else module8.NavigatedToCurrentItem
		end

		v10.current = nil

		local offset2 = v7.current.Position.Y.Offset
		task.wait()
		v9.current = false

		if not (v7.current and offset2 == v7.current.Position.Y.Offset) then
			return
		end

		fn(v7.current.Position.Y.Offset, v17, function(p7)
			if not v7.current then
				return
			end

			v7.current.Position = UDim2.fromOffset(0, p7)
		end, function()
			v8.current = false

			if v18 then
				v13.current:fire(v18)
			end
		end, v8)
	end)

	local v14 = React.useCallback(function(p6)
		if not v7.current or v8.current then
			return
		end

		assert(v7.current ~= nil, "feedMotionRef.current is nil")

		local v15 = 0

		if p6 == module7.Up then
			v15 = -v5.Y
		elseif p6 == module7.Down then
			v15 = v5.Y
		end

		local offset = v7.current.Position.Y.Offset

		local v16 = v7.current.Position.Y.Offset - v15
		local y = v5.Y
		local v17 = v16 % y
		local v18 = if y / 2 < v17 then math.min(v16 + (y - v17), 0) - v6.top else v16 - v17 - v6.top

		local v19 = math.clamp(v18, -(p4 - 1) * v5.Y, 0)

		local function fn2(p7)
			if module9 and not v7.current then
				return
			end

			if v19 - p7 < 2 and v19 - p7 > -2 then
				v7.current.Position = UDim2.fromOffset(0, v19)
			else
				v7.current.Position = UDim2.fromOffset(0, p7)
			end
		end
		local function fn3()
			v8.current = false

			if p6 == module7.Down then
				v13.current:fire(module8.NavigatedToPreviousItem)
			elseif p6 == module7.Up then
				v13.current:fire(module8.NavigatedToNextItem)
			end
		end
		v8.current = true

		fn(offset, v19, fn2, fn3, v8)
	end, { p4, v5 })

	local v15 = React.useCallback(function(p6)
		if p5 then
			return
		end

		if p6 > 0 and not p2 then
			v14(module7.Up)
		elseif p6 < 0 and not p3 then
			v14(module7.Down)
		end
	end, { p5, p2, p3, v14 })

	useEventConnection(UserInputService.PointerAction, v15)

	return v7, v13.current, v14
end

return useFeedMotionController
