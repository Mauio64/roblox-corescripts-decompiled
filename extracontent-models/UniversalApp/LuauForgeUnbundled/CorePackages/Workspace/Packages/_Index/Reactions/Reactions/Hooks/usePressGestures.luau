local UserInputService = game:GetService("UserInputService")

require("@game/CorePackages/Workspace/Packages/_Workspace/Reactions/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Reactions/React")

local function isPressInput(p2): boolean
	return p2.UserInputType == Enum.UserInputType.Touch
		or p2.UserInputType == Enum.UserInputType.MouseButton1
end

local function toVector2(position)
	return Vector2.new(position.X, position.Y)
end

local function usePressGestures(p2, current)
	local ref = React.useRef(current)
	ref.current = current

	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(Vector2.zero)
	local ref5 = React.useRef(nil)
	local ref6 = React.useRef(false)
	local ref7 = React.useRef(false)

	local ref8 = React.useRef(nil)
	local ref9 = React.useRef(Vector2.zero)
	local ref10 = React.useRef(nil)
	local ref11 = React.useRef(nil)

	local v5 = React.useCallback(function()
		ref2.current = nil
		ref6.current = false
		ref7.current = false

		if ref3.current ~= nil then
			ref3.current:Disconnect()
			ref3.current = nil
		end

		if ref5.current ~= nil then
			task.cancel(ref5.current)
			ref5.current = nil
		end
	end, {})

	local v6 = React.useCallback(function(p3)
		if ref6.current then
			local onHoldMoved = ref.current.onHoldMoved

			if onHoldMoved then
				onHoldMoved(p3)
			end
		elseif (p3 - ref4.current).Magnitude > 10 then
			v5()
		end
	end, { v5 })

	local v7 = React.useCallback(function(p3)
		local current2 = ref6.current
		local current3 = ref7.current
		local v8 = p3.UserInputState == Enum.UserInputState.Cancel
		v5()

		local current4 = ref.current

		if current2 then
			if current4.onHoldEnded then
				local onHoldEnded = current4.onHoldEnded
				local vector2

				if not v8 then
					local position = p3.Position
					vector2 = Vector2.new(position.X, position.Y)
				end

				onHoldEnded(vector2)
			end
		else
			if v8 then
				return
			end

			local position = p3.Position
			local vector2 = Vector2.new(position.X, position.Y)

			if current4.onDoubleTap == nil then
				if current4.onTap then
					current4.onTap()
				end
			elseif current3 then
				current4.onDoubleTap(vector2)
			else
				ref9.current = vector2
				ref8.current = task.delay(0.25, function()
					ref8.current = nil
					local onTap = ref.current.onTap

					if onTap then
						onTap()
					end
				end)
			end
		end
	end, { v5 })

	local v8 = React.useCallback(function(current2)
		if
			current2.UserInputType ~= Enum.UserInputType.Touch
			and current2.UserInputType ~= Enum.UserInputType.MouseButton1
			or ref2.current ~= nil
		then
			return
		end

		local position = current2.Position
		local vector2 = Vector2.new(position.X, position.Y)

		local current3 = ref8.current

		if current3 ~= nil then
			task.cancel(current3)
			ref8.current = nil

			if (vector2 - ref9.current).Magnitude <= 50 then
				ref7.current = true
			else
				local onTap = ref.current.onTap

				if onTap then
					onTap()
				end
			end
		end

		ref2.current = current2
		ref4.current = vector2
		ref3.current = current2.Changed:Connect(function(p3)
			if p3 == "Position" then
				v6(toVector2(current2.Position))
			elseif p3 == "UserInputState" then
				local userInputState = current2.UserInputState

				if
					userInputState == Enum.UserInputState.End
					or userInputState == Enum.UserInputState.Cancel
				then
					v7(current2)
				end
			end
		end)

		if ref.current.onHold == nil then
			return
		end

		local holdDuration = ref.current.holdDuration or 0.4
		ref5.current = task.delay(holdDuration, function()
			ref5.current = nil

			if ref2.current ~= current2 then
				return
			end

			ref6.current = true
			local onHold = ref.current.onHold

			if onHold then
				onHold()
			end
		end)
	end, { v6, v7 })

	local v9 = React.useCallback(function(p3)
		local current2 = ref2.current

		if
			current2 == nil
			or current2.UserInputType ~= Enum.UserInputType.MouseButton1
			or p3.UserInputType ~= Enum.UserInputType.MouseMovement
		then
			return
		end

		v6(toVector2(p3.Position))
	end, { v6 })

	React.useEffect(function()
		local current2 = p2.current

		if current2 == ref10.current then
			return
		end

		if ref11.current ~= nil then
			ref11.current:Disconnect()
			ref11.current = nil
		end

		ref10.current = current2
		local v10

		if current2 == nil then
			v10 = false
		elseif typeof(current2) == "Instance" then
			v10 = current2:IsA("GuiObject")
		else
			v10 = current2.InputBegan ~= nil
		end

		if v10 then
			ref11.current = current2.InputBegan:Connect(v8)
		end
	end)

	React.useEffect(function()
		local inputChangedConnection = UserInputService.InputChanged:Connect(v9)
		return function()
			inputChangedConnection:Disconnect()
		end
	end, { v9 })

	React.useEffect(function()
		return function()
			v5()

			if ref11.current ~= nil then
				ref11.current:Disconnect()
				ref11.current = nil
			end

			if ref8.current ~= nil then
				task.cancel(ref8.current)
				ref8.current = nil
			end
		end
	end, { v5 })

	return { onInputBegan = v8, onInputChanged = v9 }
end

return usePressGestures
