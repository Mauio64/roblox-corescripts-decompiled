local UserInputService = game:GetService("UserInputService")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/React")
local PressCaptureUtils = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PressCaptureUtils")

local isPointInsideBounds = PressCaptureUtils.isPointInsideBounds
local getInputPosition = PressCaptureUtils.getInputPosition
local isPressInput = PressCaptureUtils.isPressInput

local function disconnectGlobalInputEnded(p2)
	if p2.inputEndedConnection then
		p2.inputEndedConnection:Disconnect()
		p2.inputEndedConnection = nil
	end
end

local function disconnectInstanceListeners(state)
	if state.destroyingConnection then
		state.destroyingConnection:Disconnect()
		state.destroyingConnection = nil
	end

	if state.instanceInputEndedConnection then
		state.instanceInputEndedConnection:Disconnect()
		state.instanceInputEndedConnection = nil
	end
end

local function clearPressTracking(state)
	state.isPressed = false
	state.boundsPosition = nil
	state.boundsSize = nil

	if state.destroyingConnection then
		state.destroyingConnection:Disconnect()
		state.destroyingConnection = nil
	end

	if state.instanceInputEndedConnection then
		state.instanceInputEndedConnection:Disconnect()
		state.instanceInputEndedConnection = nil
	end
end

local function disconnectAllPressCapture(state)
	state.isPressed = false
	state.boundsPosition = nil
	state.boundsSize = nil

	if state.destroyingConnection then
		state.destroyingConnection:Disconnect()
		state.destroyingConnection = nil
	end

	if state.instanceInputEndedConnection then
		state.instanceInputEndedConnection:Disconnect()
		state.instanceInputEndedConnection = nil
	end

	if state.inputEndedConnection then
		state.inputEndedConnection:Disconnect()
		state.inputEndedConnection = nil
	end
end

return function(current)
	local ref = React.useRef(current)
	ref.current = current

	local ref2 = React.useRef({
		isPressed = false,
		boundsPosition = nil,
		boundsSize = nil,
		destroyingConnection = nil,
		inputEndedConnection = nil,
		instanceInputEndedConnection = nil
	})

	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(false)

	local v5 = React.useCallback(function()
		local current2 = ref2.current

		if current2.isPressed then
			if ref5.current then
				return
			end
		else
			ref5.current = false
		end

		ref5.current = true
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

		ref.current()
	end, {})

	local v6 = React.useCallback(function(p2)
		local current2 = ref2.current

		if current2.isPressed and current2.boundsPosition and current2.boundsSize then
			if isPointInsideBounds(getInputPosition(p2), current2.boundsPosition, current2.boundsSize) then
				v5()
				return
			end

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
		else
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
	end, { v5 })

	local v7 = React.useCallback(function()
		local current2 = ref2.current

		if current2.inputEndedConnection then
			return
		end

		current2.inputEndedConnection = UserInputService.InputEnded:Connect(function(input)
			if not isPressInput(input) then
				return
			end

			v6(input)
		end)
	end, { v6 })

	local v8 = React.useCallback(function(instance)
		if instance == nil then
			return function() end
		end

		local function onPressInstanceDestroyed()
			if not ref2.current.isPressed then
				return
			end

			local current2 = ref2.current

			if current2.destroyingConnection then
				current2.destroyingConnection:Disconnect()
				current2.destroyingConnection = nil
			end

			if current2.instanceInputEndedConnection then
				current2.instanceInputEndedConnection:Disconnect()
				current2.instanceInputEndedConnection = nil
			end

			v7()
		end

		local inputBeganConnection = instance.InputBegan:Connect(function(input)
			if not isPressInput(input) then
				return
			end

			local current2 = ref2.current
			ref5.current = false
			current2.isPressed = true
			current2.boundsPosition = instance.AbsolutePosition
			current2.boundsSize = instance.AbsoluteSize

			if current2.destroyingConnection then
				current2.destroyingConnection:Disconnect()
				current2.destroyingConnection = nil
			end

			if current2.instanceInputEndedConnection then
				current2.instanceInputEndedConnection:Disconnect()
				current2.instanceInputEndedConnection = nil
			end

			current2.destroyingConnection = instance.Destroying:Connect(onPressInstanceDestroyed)
			current2.instanceInputEndedConnection = instance.InputEnded:Connect(function(input2)
				if not isPressInput(input2) then
					return
				end

				if ref2.current.isPressed then
					local current3 = ref2.current
					current3.isPressed = false
					current3.boundsPosition = nil
					current3.boundsSize = nil

					if current3.destroyingConnection then
						current3.destroyingConnection:Disconnect()
						current3.destroyingConnection = nil
					end

					if current3.instanceInputEndedConnection then
						current3.instanceInputEndedConnection:Disconnect()
						current3.instanceInputEndedConnection = nil
					end

					if current3.inputEndedConnection then
						current3.inputEndedConnection:Disconnect()
						current3.inputEndedConnection = nil
					end
				end
			end)
		end)

		return function()
			inputBeganConnection:Disconnect()
		end
	end, { v7 })

	local v9 = React.useCallback(function(guiObject)
		if ref3.current then
			ref3.current()
			ref3.current = nil
		end

		if guiObject and guiObject:IsA("GuiObject") then
			ref3.current = v8(guiObject)
		end
	end, { v8 })

	local v10 = React.useCallback(function(guiObject)
		if ref4.current then
			ref4.current()
			ref4.current = nil
		end

		if guiObject and guiObject:IsA("GuiObject") then
			ref4.current = v8(guiObject)
		end
	end, { v8 })

	React.useEffect(function()
		return function()
			if ref3.current then
				ref3.current()
				ref3.current = nil
			end

			if ref4.current then
				ref4.current()
				ref4.current = nil
			end

			local current2 = ref2.current

			if current2.isPressed and not current2.inputEndedConnection then
				if current2.destroyingConnection then
					current2.destroyingConnection:Disconnect()
					current2.destroyingConnection = nil
				end

				if current2.instanceInputEndedConnection then
					current2.instanceInputEndedConnection:Disconnect()
					current2.instanceInputEndedConnection = nil
				end

				v7()
			elseif not current2.inputEndedConnection then
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
			end
		end
	end, { v7 })

	return { onActivated = v5, playButtonRef = v9, loadingCaptureRef = v10 }
end
