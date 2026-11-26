local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local useEventConnection = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactUtils").useEventConnection

local function isActivationInput(p2): boolean
	return p2.UserInputType == Enum.UserInputType.MouseButton1
		or p2.UserInputType == Enum.UserInputType.Touch
end

local function withinDistance(p2, p3, p4): boolean
	return (p2 - p3).Magnitude <= p4
end

local function containsPoint(p2, p3): boolean
	local absolutePosition = p2.AbsolutePosition
	local v5 = absolutePosition + p2.AbsoluteSize
	return p3.X >= absolutePosition.X and p3.X <= v5.X and p3.Y >= absolutePosition.Y and p3.Y <= v5.Y
end

local function useMomentGestures(p2, current, p3, data)
	local ref = React.useRef(nil)

	local ref2 = React.useRef(current)
	ref2.current = current

	local v5 = p3 or os.clock

	local ref3 = React.useRef(0)
	local ref4 = React.useRef(Vector2.zero)
	local ref5 = React.useRef(0)
	local ref6 = React.useRef(nil)
	local ref7 = React.useRef(nil)
	local ref8 = React.useRef(nil)
	local ref9 = React.useRef(false)
	local ref10 = React.useRef(false)
	local ref11 = React.useRef(nil)
	local ref12 = React.useRef(false)
	local ref13 = React.useRef(false)
	local v6 = (data == nil or data.movementThreshold == nil) and 50 or data.movementThreshold

	local v7 = (data == nil or data.longPressThreshold == nil) and 0.5 or data.longPressThreshold

	local scrollingFrameRef = if data ~= nil then data.scrollingFrameRef else nil
	local cancellationSignal = if data ~= nil then data.cancellationSignal else nil
	local v8 = not (data == nil) and data.cancelWhenInactive == true
	local v9 = not (data == nil) and data.cancelOnUserScroll == true

	local v10 = React.useCallback(function()
		if not ref10.current then
			return
		end

		ref10.current = false
		local onLongPressCancel = ref2.current.onLongPressCancel

		if onLongPressCancel then
			onLongPressCancel()
		end
	end, {})

	local v11 = React.useCallback(function()
		v10()
		ref8.current = nil
		ref11.current = nil
		ref12.current = false
		ref13.current = false
		ref9.current = false
		ref5.current = 0

		if ref6.current then
			task.cancel(ref6.current)
			ref6.current = nil
		end

		if ref7.current then
			task.cancel(ref7.current)
			ref7.current = nil
		end
	end, {})

	local v12 = React.useCallback(function(current2)
		if
			not p2
			or current2.UserInputType ~= Enum.UserInputType.MouseButton1
			and current2.UserInputType ~= Enum.UserInputType.Touch
		then
			return
		end

		ref8.current = current2
		ref9.current = false
		ref12.current = false
		ref13.current = false

		local v13 = v5()
		local vector2 = Vector2.new(current2.Position.X, current2.Position.Y)
		ref11.current = vector2

		local v14 = v13 - ref3.current <= 0.25
		local v15 = (vector2 - ref4.current).Magnitude <= 50

		if v14 and v15 then
			ref5.current += 1
		else
			ref5.current = 1
		end

		ref3.current = v13
		ref4.current = vector2

		if ref5.current >= 2 and ref7.current then
			task.cancel(ref7.current)
			ref7.current = nil
		end

		if ref6.current then
			task.cancel(ref6.current)
		end

		v10()
		ref10.current = true
		local onLongPressStart = ref2.current.onLongPressStart

		if onLongPressStart then
			onLongPressStart()
		end

		ref6.current = task.delay(v7, function()
			if not p2 then
				return
			end

			if ref8.current == current2 and not ref9.current then
				ref9.current = true
				ref10.current = false
				local onLongPress = ref2.current.onLongPress

				if onLongPress then
					onLongPress()
				end
			end
		end)
	end, { p2, v5, v7, v10 })

	local v13 = React.useCallback(function(p4)
		local current2 = ref8.current
		local current3 = ref11.current
		local current4 = if scrollingFrameRef ~= nil then scrollingFrameRef.current else nil

		if v9 and current4 ~= nil then
			local userInputType = p4.UserInputType
			local vector2 = Vector2.new(p4.Position.X, p4.Position.Y)
			local v14 = userInputType == Enum.UserInputType.Touch and p4 == current2
			local v15

			if userInputType == Enum.UserInputType.MouseMovement and current2 ~= nil then
				v15 = current2.UserInputType == Enum.UserInputType.MouseButton1
			else
				v15 = false
			end

			if current2 == nil or current3 == nil then
				v15 = false
			elseif v14 or v15 then
				v15 = not ((vector2 - current3).Magnitude <= 2)
			end

			local v16

			if userInputType == Enum.UserInputType.MouseWheel then
				local mouseLocation = UserInputService:GetMouseLocation()
				local absolutePosition = current4.AbsolutePosition
				local v17 = absolutePosition + current4.AbsoluteSize

				if
					mouseLocation.X >= absolutePosition.X
					and mouseLocation.X <= v17.X
					and mouseLocation.Y >= absolutePosition.Y
				then
					v16 = mouseLocation.Y <= v17.Y
				else
					v16 = false
				end
			else
				v16 = false
			end

			local v17 = not (ref6.current == nil) and ref2.current.onLongPress ~= nil

			if v15 and v17 and (vector2 - current3).Magnitude <= 10 then
				ref13.current = true
				ref5.current = 0

				if ref7.current then
					task.cancel(ref7.current)
					ref7.current = nil
				end
			elseif v15 or v16 then
				v11()
				return
			end
		end

		if not p2 or current2 == nil or p4.UserInputType == Enum.UserInputType.Touch and p4 ~= current2 then
			return
		end

		if
			current3 ~= nil
			and not ref12.current
			and not (v6 >= (Vector2.new(p4.Position.X, p4.Position.Y) - current3).Magnitude)
		then
			ref12.current = true

			if ref6.current then
				task.cancel(ref6.current)
				ref6.current = nil
			end

			v10()
		end
	end, { p2, v6, scrollingFrameRef, v9, v11, v10 })

	useEventConnection(UserInputService.InputChanged, v13, { v13 })

	local v14 = React.useCallback(function(p4)
		if ref8.current ~= p4 then
			return
		end

		ref8.current = nil

		if ref6.current then
			task.cancel(ref6.current)
			ref6.current = nil
		end

		v10()

		if
			ref9.current
			or ref12.current
			or ref13.current
			or p4.UserInputType ~= Enum.UserInputType.MouseButton1
			and p4.UserInputType ~= Enum.UserInputType.Touch
		then
			return
		end

		local onTap = ref2.current.onTap

		if onTap then
			onTap(ref4.current, ref5.current)
		end

		if ref5.current >= 2 then
			if ref7.current then
				task.cancel(ref7.current)
				ref7.current = nil
			end

			ref5.current = 0
			local onDoubleTap = ref2.current.onDoubleTap

			if onDoubleTap then
				onDoubleTap(ref4.current)
			end
		else
			if ref7.current then
				task.cancel(ref7.current)
			end

			local current2 = ref4.current
			ref7.current = task.delay(0.25, function()
				ref7.current = nil
				local onSingleTapConfirmed = ref5.current == 1 and ref2.current.onSingleTapConfirmed

				if onSingleTapConfirmed then
					onSingleTapConfirmed(current2)
				end

				ref5.current = 0
			end)
		end
	end, { v10 })

	useEventConnection(UserInputService.InputEnded, v14, { v14 })

	React.useEffect(function()
		if cancellationSignal == nil then
			return
		end

		local connection = cancellationSignal:Connect(v11)
		return function()
			connection:Disconnect()
		end
	end, { cancellationSignal, v11 })

	React.useEffect(function()
		if v8 and not p2 then
			v11()
		end
	end, { p2, v8, v11 })

	React.useEffect(function()
		local current2 = ref.current

		if current2 == nil then
			return
		end

		local inputBeganConnection = current2.InputBegan:Connect(v12)
		return function()
			inputBeganConnection:Disconnect()
		end
	end, { v12 })

	React.useEffect(function()
		return function()
			ref10.current = false
			v11()
		end
	end, { v11 })

	return { ref = ref, onInputBegan = v12, onInputChanged = v13, onInputEnded = v14 }
end

return useMomentGestures
