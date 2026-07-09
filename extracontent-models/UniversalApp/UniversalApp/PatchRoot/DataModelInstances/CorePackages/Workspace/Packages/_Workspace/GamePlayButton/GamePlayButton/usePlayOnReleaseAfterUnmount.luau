local Parent = script:FindFirstAncestor("GamePlayButton").Parent
local UserInputService = game:GetService("UserInputService")
local React = require(Parent.React)
local PressCaptureUtils = require(script.Parent.PressCaptureUtils)
local isPointInsideBounds = PressCaptureUtils.isPointInsideBounds
local getInputPosition = PressCaptureUtils.getInputPosition
local isPressInput = PressCaptureUtils.isPressInput

local function disconnectGlobalInputEnded(t1: {[any]: any}) -- line: 21
	if t1.inputEndedConnection then
		t1.inputEndedConnection:Disconnect()
		t1.inputEndedConnection = nil
	end
end
local function disconnectInstanceListeners(t2: {[any]: any}) -- line: 28
	if t2.destroyingConnection then
		t2.destroyingConnection:Disconnect()
		t2.destroyingConnection = nil
	end

	if t2.instanceInputEndedConnection then
		t2.instanceInputEndedConnection:Disconnect()
		t2.instanceInputEndedConnection = nil
	end
end
local function clearPressTracking(t3: {[any]: any}) -- line: 39
	t3.isPressed = false
	t3.boundsPosition = nil
	t3.boundsSize = nil

	if t3.destroyingConnection then
		t3.destroyingConnection:Disconnect()
		t3.destroyingConnection = nil
	end

	if t3.instanceInputEndedConnection then
		t3.instanceInputEndedConnection:Disconnect()
		t3.instanceInputEndedConnection = nil
	end
end
local function disconnectAllPressCapture(t4: {[any]: any}) -- line: 46
	t4.isPressed = false
	t4.boundsPosition = nil
	t4.boundsSize = nil

	if t4.destroyingConnection then
		t4.destroyingConnection:Disconnect()
		t4.destroyingConnection = nil
	end

	if t4.instanceInputEndedConnection then
		t4.instanceInputEndedConnection:Disconnect()
		t4.instanceInputEndedConnection = nil
	end

	if t4.inputEndedConnection then
		t4.inputEndedConnection:Disconnect()
		t4.inputEndedConnection = nil
	end
end

return function(p1: ((...any) -> ...any)) -- line: 51
	-- upvalues: React (copy), getInputPosition (copy), isPointInsideBounds (copy), UserInputService (copy), isPressInput (copy)
	local v17 = React.useRef(p1)

	v17.current = p1

	local v18 = React.useRef({
		isPressed = false,
		boundsPosition = nil,
		boundsSize = nil,
		destroyingConnection = nil,
		inputEndedConnection = nil,
		instanceInputEndedConnection = nil
	})
	local v19 = React.useRef(nil)
	local v20 = React.useRef(nil)
	local v21 = React.useRef(false)
	local v22 = React.useCallback(function() -- line: 72
		-- upvalues: v18 (copy), v21 (copy), v17 (copy)
		local current = v18.current

		if not current.isPressed then
			v21.current = false
		elseif v21.current then
			return
		end

		v21.current = true
		current.isPressed = false
		current.boundsPosition = nil
		current.boundsSize = nil

		if current.destroyingConnection then
			current.destroyingConnection:Disconnect()
			current.destroyingConnection = nil
		end

		if current.instanceInputEndedConnection then
			current.instanceInputEndedConnection:Disconnect()
			current.instanceInputEndedConnection = nil
		end

		if current.inputEndedConnection then
			current.inputEndedConnection:Disconnect()
			current.inputEndedConnection = nil
		end

		v17.current()
	end, {})
	local v23 = React.useCallback(function(p2) -- line: 87
		-- upvalues: v18 (copy), getInputPosition (copy), isPointInsideBounds (copy), v22 (copy)
		local current = v18.current

		if not current.isPressed or (not current.boundsPosition or not current.boundsSize) then
			current.isPressed = false
			current.boundsPosition = nil
			current.boundsSize = nil

			if current.destroyingConnection then
				current.destroyingConnection:Disconnect()
				current.destroyingConnection = nil
			end

			if current.instanceInputEndedConnection then
				current.instanceInputEndedConnection:Disconnect()
				current.instanceInputEndedConnection = nil
			end

			if current.inputEndedConnection then
				current.inputEndedConnection:Disconnect()
				current.inputEndedConnection = nil
			end

			return
		end

		local v31 = getInputPosition(p2)

		if isPointInsideBounds(v31, current.boundsPosition, current.boundsSize) then
			v22()

			return
		end

		current.isPressed = false
		current.boundsPosition = nil
		current.boundsSize = nil

		if current.destroyingConnection then
			current.destroyingConnection:Disconnect()
			current.destroyingConnection = nil
		end

		if current.instanceInputEndedConnection then
			current.instanceInputEndedConnection:Disconnect()
			current.instanceInputEndedConnection = nil
		end

		if current.inputEndedConnection then
			current.inputEndedConnection:Disconnect()
			current.inputEndedConnection = nil
		end
	end, { v22 })
	local v24 = React.useCallback(function() -- line: 103
		-- upvalues: v18 (copy), UserInputService (copy), isPressInput (copy), v23 (copy)
		local current = v18.current

		if current.inputEndedConnection then
			return
		end

		current.inputEndedConnection = UserInputService.InputEnded:Connect(function(input) -- line: 109
			-- upvalues: isPressInput (copy), v23 (copy)
			if not isPressInput(input) then
				return
			end

			v23(input)
		end)
	end, { v23 })
	local v25 = React.useCallback(function(p3) -- line: 117
		-- upvalues: v18 (copy), v24 (copy), isPressInput (copy), v21 (copy)
		if p3 == nil then
			return function() -- line: 119
			end
		end

		local function onPressInstanceDestroyed() -- line: 122
			-- upvalues: v18 (copy), v24 (copy)
			if not v18.current.isPressed then
				return
			end

			local current = v18.current

			if current.destroyingConnection then
				current.destroyingConnection:Disconnect()
				current.destroyingConnection = nil
			end

			if current.instanceInputEndedConnection then
				current.instanceInputEndedConnection:Disconnect()
				current.instanceInputEndedConnection = nil
			end

			v24()
		end

		local connection = p3.InputBegan:Connect(function(input) -- line: 130
			-- upvalues: isPressInput (copy), v18 (copy), v21 (copy), p3 (copy), onPressInstanceDestroyed (copy)
			if not isPressInput(input) then
				return
			end

			local current = v18.current

			v21.current = false
			current.isPressed = true
			current.boundsPosition = p3.AbsolutePosition
			current.boundsSize = p3.AbsoluteSize

			if current.destroyingConnection then
				current.destroyingConnection:Disconnect()
				current.destroyingConnection = nil
			end

			if current.instanceInputEndedConnection then
				current.instanceInputEndedConnection:Disconnect()
				current.instanceInputEndedConnection = nil
			end

			current.destroyingConnection = p3.Destroying:Connect(onPressInstanceDestroyed)
			current.instanceInputEndedConnection = p3.InputEnded:Connect(function(input2) -- line: 143
				-- upvalues: isPressInput (copy), v18 (copy)
				if not isPressInput(input2) then
					return
				end

				if v18.current.isPressed then
					local current2 = v18.current

					current2.isPressed = false
					current2.boundsPosition = nil
					current2.boundsSize = nil

					if current2.destroyingConnection then
						current2.destroyingConnection:Disconnect()
						current2.destroyingConnection = nil
					end

					if current2.instanceInputEndedConnection then
						current2.instanceInputEndedConnection:Disconnect()
						current2.instanceInputEndedConnection = nil
					end

					if current2.inputEndedConnection then
						current2.inputEndedConnection:Disconnect()
						current2.inputEndedConnection = nil
					end
				end
			end)
		end)

		return function() -- line: 153
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { v24 })
	local v26 = React.useCallback(function(p4) -- line: 158
		-- upvalues: v19 (copy), v25 (copy)
		if v19.current then
			v19.current()
			v19.current = nil
		end

		if p4 and p4:IsA("GuiObject") then
			v19.current = v25(p4)
		end
	end, { v25 })
	local v27 = React.useCallback(function(p5) -- line: 169
		-- upvalues: v20 (copy), v25 (copy)
		if v20.current then
			v20.current()
			v20.current = nil
		end

		if p5 and p5:IsA("GuiObject") then
			v20.current = v25(p5)
		end
	end, { v25 })

	React.useEffect(function() -- line: 180
		-- upvalues: v19 (copy), v20 (copy), v18 (copy), v24 (copy)
		return function() -- line: 181
			-- upvalues: v19 (copy), v20 (copy), v18 (copy), v24 (copy)
			if v19.current then
				v19.current()
				v19.current = nil
			end

			if v20.current then
				v20.current()
				v20.current = nil
			end

			local current = v18.current

			if current.isPressed and not current.inputEndedConnection then
				if current.destroyingConnection then
					current.destroyingConnection:Disconnect()
					current.destroyingConnection = nil
				end

				if current.instanceInputEndedConnection then
					current.instanceInputEndedConnection:Disconnect()
					current.instanceInputEndedConnection = nil
				end

				v24()

				return
			end

			if not current.inputEndedConnection then
				current.isPressed = false
				current.boundsPosition = nil
				current.boundsSize = nil

				if current.destroyingConnection then
					current.destroyingConnection:Disconnect()
					current.destroyingConnection = nil
				end

				if current.instanceInputEndedConnection then
					current.instanceInputEndedConnection:Disconnect()
					current.instanceInputEndedConnection = nil
				end
			end
		end
	end, { v24 })

	return {
		onActivated = v22,
		playButtonRef = v26,
		loadingCaptureRef = v27
	}
end
