local parent = script:FindFirstAncestor("GamePlayButton").Parent

local UserInputService = game:GetService("UserInputService")
local React = require(parent.React)
local PressCaptureUtils = require(script.Parent.PressCaptureUtils)

local isPointInsideBounds = PressCaptureUtils.isPointInsideBounds
local getInputPosition = PressCaptureUtils.getInputPosition
local isPressInput = PressCaptureUtils.isPressInput

local function disconnectGlobalInputEnded(p) -- 5 equivalent calls inferred from this helper
	if p.inputEndedConnection then
		p.inputEndedConnection:Disconnect()
		p.inputEndedConnection = nil
	end
end

local function disconnectInstanceListeners(state) -- 4 equivalent calls inferred from this helper
	if state.destroyingConnection then
		state.destroyingConnection:Disconnect()
		state.destroyingConnection = nil
	end

	if state.instanceInputEndedConnection then
		state.instanceInputEndedConnection:Disconnect()
		state.instanceInputEndedConnection = nil
	end
end

local function clearPressTracking(state) -- 6 equivalent calls inferred from this helper
	state.isPressed = false
	state.boundsPosition = nil
	state.boundsSize = nil
	disconnectInstanceListeners(state) -- inferred equivalent call
end

local function disconnectAllPressCapture(p)
	clearPressTracking(p) -- inferred equivalent call
	disconnectGlobalInputEnded(p) -- inferred equivalent call
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

	local onActivated = React.useCallback(function()
		local current2 = ref2.current

		if current2.isPressed then
			if ref5.current then
				return
			end
		else
			ref5.current = false
		end

		ref5.current = true
		clearPressTracking(current2) -- inferred equivalent call
		disconnectGlobalInputEnded(current2) -- inferred equivalent call
		ref.current()
	end, {})

	local v = React.useCallback(function(p)
		local current2 = ref2.current

		if current2.isPressed and current2.boundsPosition and current2.boundsSize then
			if isPointInsideBounds(getInputPosition(p), current2.boundsPosition, current2.boundsSize) then
				onActivated()
				return
			end

			clearPressTracking(current2) -- inferred equivalent call
			disconnectGlobalInputEnded(current2) -- inferred equivalent call
		else
			clearPressTracking(current2) -- inferred equivalent call
			disconnectGlobalInputEnded(current2) -- inferred equivalent call
		end
	end, { onActivated })

	local v2 = React.useCallback(function()
		local current2 = ref2.current

		if current2.inputEndedConnection then
			return
		end

		current2.inputEndedConnection = UserInputService.InputEnded:Connect(function(input)
			if not isPressInput(input) then
				return
			end

			v(input)
		end)
	end, { v })

	local v3 = React.useCallback(function(instance)
		if instance == nil then
			return function() end
		end

		local function onPressInstanceDestroyed()
			if not ref2.current.isPressed then
				return
			end

			disconnectInstanceListeners(ref2.current) -- inferred equivalent call
			v2()
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
			disconnectInstanceListeners(current2) -- inferred equivalent call
			current2.destroyingConnection = instance.Destroying:Connect(onPressInstanceDestroyed)
			current2.instanceInputEndedConnection = instance.InputEnded:Connect(function(input2)
				if not isPressInput(input2) then
					return
				end

				if ref2.current.isPressed then
					local current3 = ref2.current
					clearPressTracking(current3) -- inferred equivalent call
					disconnectGlobalInputEnded(current3) -- inferred equivalent call
				end
			end)
		end)

		return function()
			inputBeganConnection:Disconnect()
		end
	end, { v2 })

	local playButtonRef = React.useCallback(function(guiObject)
		if ref3.current then
			ref3.current()
			ref3.current = nil
		end

		if guiObject and guiObject:IsA("GuiObject") then
			ref3.current = v3(guiObject)
		end
	end, { v3 })

	local loadingCaptureRef = React.useCallback(function(guiObject)
		if ref4.current then
			ref4.current()
			ref4.current = nil
		end

		if guiObject and guiObject:IsA("GuiObject") then
			ref4.current = v3(guiObject)
		end
	end, { v3 })

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
				disconnectInstanceListeners(current2) -- inferred equivalent call
				v2()
			elseif not current2.inputEndedConnection then
				clearPressTracking(current2) -- inferred equivalent call
			end
		end
	end, { v2 })

	return {
		onActivated = onActivated,
		playButtonRef = playButtonRef,
		loadingCaptureRef = loadingCaptureRef
	}
end
