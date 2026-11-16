local parent = script:FindFirstAncestor("Moments").Parent

local UserInputService = game:GetService("UserInputService")

local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)

local useEventConnection = ReactUtils.useEventConnection

local function isActivationInput(p): boolean
	return p.UserInputType == Enum.UserInputType.MouseButton1 or p.UserInputType == Enum.UserInputType.Touch
end

local function withinDistance(vector2: Vector2, current: Vector2, p: number): boolean -- 1 equivalent call inferred from this helper
	return (vector2 - current).Magnitude <= p
end

local function containsPoint(current, mouseLocation: Vector2): boolean -- 1 equivalent call inferred from this helper
	local absolutePosition = current.AbsolutePosition
	local v = absolutePosition + current.AbsoluteSize
	return mouseLocation.X >= absolutePosition.X
		and mouseLocation.X <= v.X
		and mouseLocation.Y >= absolutePosition.Y
		and mouseLocation.Y <= v.Y
end

local function useMomentGestures(flag: boolean, current, callback, data)
	local ref = React.useRef(nil)

	local ref2 = React.useRef(current)
	ref2.current = current

	local v = callback or os.clock

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
	local v2 = (data == nil or data.movementThreshold == nil) and 50 or data.movementThreshold

	local v3 = (data == nil or data.longPressThreshold == nil) and 0.5 or data.longPressThreshold
	local scrollingFrameRef

	if data == nil then
		scrollingFrameRef = nil
	else
		scrollingFrameRef = data.scrollingFrameRef
	end

	local cancellationSignal

	if data == nil then
		cancellationSignal = nil
	else
		cancellationSignal = data.cancellationSignal
	end

	local v4

	if data == nil then
		v4 = false
	else
		v4 = data.cancelWhenInactive == true
	end

	local v5

	if data == nil then
		v5 = false
	else
		v5 = data.cancelOnUserScroll == true
	end

	local v6 = React.useCallback(function()
		if not ref10.current then
			return
		end

		ref10.current = false
		local onLongPressCancel = ref2.current.onLongPressCancel

		if onLongPressCancel then
			onLongPressCancel()
		end
	end, {})

	local v7 = React.useCallback(function()
		v6()
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

	local onInputBegan = React.useCallback(function(current2)
		if
			not flag
			or current2.UserInputType ~= Enum.UserInputType.MouseButton1
			and current2.UserInputType ~= Enum.UserInputType.Touch
		then
			return
		end

		ref8.current = current2
		ref9.current = false
		ref12.current = false
		ref13.current = false

		local current3 = v()
		local vector2 = Vector2.new(current2.Position.X, current2.Position.Y)
		ref11.current = vector2

		local v8 = current3 - ref3.current <= 0.25
		local v9 = withinDistance(vector2, ref4.current, 50) -- inferred equivalent call

		if v8 and v9 then
			ref5.current += 1
		else
			ref5.current = 1
		end

		ref3.current = current3
		ref4.current = vector2

		if ref5.current >= 2 and ref7.current then
			task.cancel(ref7.current)
			ref7.current = nil
		end

		if ref6.current then
			task.cancel(ref6.current)
		end

		v6()
		ref10.current = true
		local onLongPressStart = ref2.current.onLongPressStart

		if onLongPressStart then
			onLongPressStart()
		end

		ref6.current = task.delay(v3, function()
			if not flag then
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
	end, { flag, v, v3, v6 })

	local onInputChanged = React.useCallback(function(p)
		local current2 = ref8.current
		local current3 = ref11.current
		local current4

		if scrollingFrameRef ~= nil then
			current4 = scrollingFrameRef.current
		end

		if v5 and current4 ~= nil then
			local userInputType = p.UserInputType
			local vector2 = Vector2.new(p.Position.X, p.Position.Y)
			local v8

			if userInputType == Enum.UserInputType.Touch then
				v8 = p == current2
			else
				v8 = false
			end

			local v9

			if userInputType == Enum.UserInputType.MouseMovement and current2 ~= nil then
				v9 = current2.UserInputType == Enum.UserInputType.MouseButton1
			else
				v9 = false
			end

			if current2 == nil or current3 == nil then
				v9 = false
			elseif v8 or v9 then
				v9 = not ((vector2 - current3).Magnitude <= 2)
			end

			local v10

			if userInputType == Enum.UserInputType.MouseWheel then
				v10 = containsPoint(current4, UserInputService:GetMouseLocation()) -- inferred equivalent call
			else
				v10 = false
			end

			local v11

			if ref6.current == nil then
				v11 = false
			else
				v11 = ref2.current.onLongPress ~= nil
			end

			if v9 and v11 and (vector2 - current3).Magnitude <= 10 then
				ref13.current = true
				ref5.current = 0

				if ref7.current then
					task.cancel(ref7.current)
					ref7.current = nil
				end
			elseif v9 or v10 then
				v7()
				return
			end
		end

		if not flag or current2 == nil or p.UserInputType == Enum.UserInputType.Touch and p ~= current2 then
			return
		end

		if
			current3 ~= nil
			and not ref12.current
			and not (v2 >= (Vector2.new(p.Position.X, p.Position.Y) - current3).Magnitude)
		then
			ref12.current = true

			if ref6.current then
				task.cancel(ref6.current)
				ref6.current = nil
			end

			v6()
		end
	end, { flag, v2, scrollingFrameRef, v5, v7, v6 })

	useEventConnection(UserInputService.InputChanged, onInputChanged, { onInputChanged })

	local onInputEnded = React.useCallback(function(p)
		if ref8.current ~= p then
			return
		end

		ref8.current = nil

		if ref6.current then
			task.cancel(ref6.current)
			ref6.current = nil
		end

		v6()

		if
			ref9.current
			or ref12.current
			or ref13.current
			or p.UserInputType ~= Enum.UserInputType.MouseButton1 and p.UserInputType ~= Enum.UserInputType.Touch
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
	end, { v6 })

	useEventConnection(UserInputService.InputEnded, onInputEnded, { onInputEnded })

	React.useEffect(function()
		if cancellationSignal == nil then
			return
		end

		local connection = cancellationSignal:Connect(v7)
		return function()
			connection:Disconnect()
		end
	end, { cancellationSignal, v7 })

	React.useEffect(function()
		if v4 and not flag then
			v7()
		end
	end, { flag, v4, v7 })

	React.useEffect(function()
		local current2 = ref.current

		if current2 == nil then
			return
		end

		local inputBeganConnection = current2.InputBegan:Connect(onInputBegan)
		return function()
			inputBeganConnection:Disconnect()
		end
	end, { onInputBegan })

	React.useEffect(function()
		return function()
			ref10.current = false
			v7()
		end
	end, { v7 })

	return {
		ref = ref,
		onInputBegan = onInputBegan,
		onInputChanged = onInputChanged,
		onInputEnded = onInputEnded
	}
end

return useMomentGestures
