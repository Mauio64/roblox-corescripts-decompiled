local Parent = script:FindFirstAncestor("Moments").Parent
local UserInputService = game:GetService("UserInputService")
local React = require(Parent.React)
local useEventConnection = require(Parent.ReactUtils).useEventConnection

local function isActivationInput(p1) -- line: 51
	return p1.UserInputType == Enum.UserInputType.MouseButton1 or p1.UserInputType == Enum.UserInputType.Touch
end
local function withinDistance(vector2: Vector2, vector2_2: Vector2, n1: number) -- line: 56
	return n1 >= (vector2 - vector2_2).Magnitude
end
local function useMomentGestures(b1: boolean, t1: {[any]: any}, p2: ((...any) -> ...any)?) -- line: 60
	-- upvalues: React (copy), useEventConnection (copy), UserInputService (copy)
	local v15 = React.useRef(nil)
	local v16 = React.useRef(t1)

	v16.current = t1

	local v17 = p2 or os.clock
	local v18 = React.useRef(0)
	local v19 = React.useRef(Vector2.zero)
	local v20 = React.useRef(0)
	local v21 = React.useRef(nil)
	local v22 = React.useRef(nil)
	local v23 = React.useRef(nil)
	local v24 = React.useRef(false)
	local v25 = React.useRef(nil)
	local v26 = React.useRef(false)
	local v27 = React.useCallback(function(p3) -- line: 82
		-- upvalues: b1 (copy), v23 (copy), v24 (copy), v26 (copy), v17 (copy), v25 (copy), v18 (copy), v19 (copy), v20 (copy), v22 (copy), v21 (copy), v16 (copy)
		if not b1 or p3.UserInputType ~= Enum.UserInputType.MouseButton1 and p3.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		v23.current = p3
		v24.current = false
		v26.current = false

		local v31 = v17()
		local vector2 = Vector2.new(p3.Position.X, p3.Position.Y)

		v25.current = vector2

		local v33 = v31 - v18.current <= 0.25
		local v34 = (vector2 - v19.current).Magnitude <= 50

		if v33 and v34 then
			local v35 = v20

			v35.current = v35.current + 1
		else
			v20.current = 1
		end

		v18.current = v31
		v19.current = vector2

		if v20.current >= 2 and v22.current then
			task.cancel(v22.current)
			v22.current = nil
		end

		if v21.current then
			task.cancel(v21.current)
		end

		v21.current = task.delay(0.5, function() -- line: 116
			-- upvalues: b1 (copy), v23 (copy), p3 (copy), v24 (copy), v16 (copy)
			if not b1 then
				return
			end

			if v23.current == p3 and not v24.current then
				v24.current = true

				local onLongPress = v16.current.onLongPress

				if onLongPress then
					onLongPress()
				end
			end
		end)
	end, {
		b1,
		v17
	})
	local v28 = React.useCallback(function(p4) -- line: 132
		-- upvalues: b1 (copy), v23 (copy), v25 (copy), v26 (copy), v21 (copy)
		if not b1 or v23.current == nil then
			return
		end

		if p4.UserInputType == Enum.UserInputType.Touch and p4 ~= v23.current then
			return
		end

		if v25.current ~= nil and not v26.current and not ((Vector2.new(p4.Position.X, p4.Position.Y) - v25.current).Magnitude <= 50) then
			v26.current = true

			if v21.current then
				task.cancel(v21.current)
				v21.current = nil
			end
		end
	end, { b1 })

	useEventConnection(UserInputService.InputChanged, v28, { v28 })

	local v29 = React.useCallback(function(p5) -- line: 156
		-- upvalues: v23 (copy), v21 (copy), v24 (copy), v26 (copy), v16 (copy), v20 (copy), v22 (copy), v19 (copy)
		if p5 ~= v23.current then
			return
		end

		v23.current = nil

		if v21.current then
			task.cancel(v21.current)
			v21.current = nil
		end

		if v24.current or v26.current or p5.UserInputType ~= Enum.UserInputType.MouseButton1 and p5.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		local onTap = v16.current.onTap

		if onTap then
			onTap()
		end

		if v20.current >= 2 then
			if v22.current then
				task.cancel(v22.current)
				v22.current = nil
			end

			v20.current = 0

			local onDoubleTap = v16.current.onDoubleTap

			if onDoubleTap then
				onDoubleTap(v19.current)

				return
			end
		else
			if v22.current then
				task.cancel(v22.current)
			end

			v22.current = task.delay(0.25, function() -- line: 195
				-- upvalues: v22 (copy), v20 (copy), v16 (copy)
				v22.current = nil

				if v20.current == 1 then
					local onSingleTapConfirmed = v16.current.onSingleTapConfirmed

					if onSingleTapConfirmed then
						onSingleTapConfirmed()
					end
				end

				v20.current = 0
			end)
		end
	end, {})

	useEventConnection(UserInputService.InputEnded, v29, { v29 })
	React.useEffect(function() -- line: 210
		-- upvalues: v15 (copy), v27 (copy)
		local current = v15.current

		if current == nil then
			return
		end

		local connection = current.InputBegan:Connect(v27)

		return function() -- line: 216
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { v27 })
	React.useEffect(function() -- line: 221
		-- upvalues: v21 (copy), v22 (copy)
		return function() -- line: 222
			-- upvalues: v21 (copy), v22 (copy)
			if v21.current then
				task.cancel(v21.current)
			end

			if v22.current then
				task.cancel(v22.current)
			end
		end
	end, {})

	return {
		ref = v15,
		onInputBegan = v27,
		onInputChanged = v28,
		onInputEnded = v29
	}
end

return useMomentGestures
