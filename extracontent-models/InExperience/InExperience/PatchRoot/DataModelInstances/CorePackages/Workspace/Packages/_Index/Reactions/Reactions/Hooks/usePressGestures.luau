local parent = script:FindFirstAncestor("Reactions").Parent

local UserInputService = game:GetService("UserInputService")

require(parent.Foundation)
local React = require(parent.React)

local function isPressInput(current): boolean -- 1 equivalent call inferred from this helper
	return current.UserInputType == Enum.UserInputType.Touch or current.UserInputType == Enum.UserInputType.MouseButton1
end

local function toVector2(position: Vector3) -- 3 equivalent calls inferred from this helper
	return Vector2.new(position.X, position.Y)
end

local function usePressGestures(p, current)
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

	local v = React.useCallback(function()
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

	local v2 = React.useCallback(function(vector2: Vector2)
		if ref6.current then
			local onHoldMoved = ref.current.onHoldMoved

			if onHoldMoved then
				onHoldMoved(vector2)
			end
		elseif (vector2 - ref4.current).Magnitude > 10 then
			v()
		end
	end, { v })

	local v3 = React.useCallback(function(p2)
		local current2 = ref6.current
		local current3 = ref7.current
		local v3 = p2.UserInputState == Enum.UserInputState.Cancel
		v()

		local current4 = ref.current

		if current2 then
			if current4.onHoldEnded then
				local onHoldEnded = current4.onHoldEnded
				local v4

				if not v3 then
					v4 = toVector2(p2.Position) -- inferred equivalent call
				end

				onHoldEnded(v4)
			end
		else
			if v3 then
				return
			end

			local current5 = toVector2(p2.Position) -- inferred equivalent call

			if current4.onDoubleTap == nil then
				if current4.onTap then
					current4.onTap()
				end
			elseif current3 then
				current4.onDoubleTap(current5)
			else
				ref9.current = current5
				ref8.current = task.delay(0.25, function()
					ref8.current = nil
					local onTap = ref.current.onTap

					if onTap then
						onTap()
					end
				end)
			end
		end
	end, { v })

	local onInputBegan = React.useCallback(function(current2)
		if not isPressInput(current2) or ref2.current ~= nil then -- inferred equivalent call
			return
		end

		local current4 = toVector2(current2.Position) -- inferred equivalent call

		local current3 = ref8.current

		if current3 ~= nil then
			task.cancel(current3)
			ref8.current = nil

			if (current4 - ref9.current).Magnitude <= 50 then
				ref7.current = true
			else
				local onTap = ref.current.onTap

				if onTap then
					onTap()
				end
			end
		end

		ref2.current = current2
		ref4.current = current4
		ref3.current = current2.Changed:Connect(function(p2: string)
			if p2 == "Position" then
				v2(toVector2(current2.Position))
			elseif p2 == "UserInputState" then
				local userInputState = current2.UserInputState

				if userInputState == Enum.UserInputState.End or userInputState == Enum.UserInputState.Cancel then
					v3(current2)
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
	end, { v2, v3 })

	local onInputChanged = React.useCallback(function(p2)
		local current2 = ref2.current

		if
			current2 == nil
			or current2.UserInputType ~= Enum.UserInputType.MouseButton1
			or p2.UserInputType ~= Enum.UserInputType.MouseMovement
		then
			return
		end

		v2(toVector2(p2.Position))
	end, { v2 })

	React.useEffect(function()
		local current2 = p.current

		if current2 == ref10.current then
			return
		end

		if ref11.current ~= nil then
			ref11.current:Disconnect()
			ref11.current = nil
		end

		ref10.current = current2
		local v4

		if current2 == nil then
			v4 = false
		elseif typeof(current2) == "Instance" then
			v4 = current2:IsA("GuiObject")
		else
			v4 = current2.InputBegan ~= nil
		end

		if v4 then
			ref11.current = current2.InputBegan:Connect(onInputBegan)
		end
	end)

	React.useEffect(function()
		local inputChangedConnection = UserInputService.InputChanged:Connect(onInputChanged)
		return function()
			inputChangedConnection:Disconnect()
		end
	end, { onInputChanged })

	React.useEffect(function()
		return function()
			v()

			if ref11.current ~= nil then
				ref11.current:Disconnect()
				ref11.current = nil
			end

			if ref8.current ~= nil then
				task.cancel(ref8.current)
				ref8.current = nil
			end
		end
	end, { v })

	return { onInputBegan = onInputBegan, onInputChanged = onInputChanged }
end

return usePressGestures
