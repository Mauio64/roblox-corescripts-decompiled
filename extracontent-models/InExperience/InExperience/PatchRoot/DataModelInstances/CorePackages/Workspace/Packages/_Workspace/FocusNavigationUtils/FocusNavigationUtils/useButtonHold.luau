local FocusNavigationUtils = script:FindFirstAncestor("FocusNavigationUtils")
local parent = FocusNavigationUtils.Parent

local ArgCheck = require(parent.ArgCheck)
local ButtonHoldStateEnum = require(FocusNavigationUtils.ButtonHoldStateEnum)
local ButtonHoldCompletedSignal = require(FocusNavigationUtils.ButtonHoldCompletedSignal)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableFocusNavTelemetry = SharedFlags.FFlagEnableFocusNavTelemetry

local InputHandlers = require(parent.InputHandlers)
local React = require(parent.React)

local function useFakeCancelHoldAfterBlur(guiObject, callback, callback2)
	local v = React.useCallback(function()
		callback({
			eventData = { UserInputState = Enum.UserInputState.End }
		})

		callback2()
	end, { callback, callback2 })

	React.useEffect(function()
		if guiObject and guiObject:IsA("GuiObject") then
			local selectionLostConnection = guiObject.SelectionLost:Connect(v)
			return function()
				selectionLostConnection:Disconnect()
			end
		end

		return function() end
	end, { guiObject, v })
end

local function useButtonHold(p: number, durationSeconds: number, allowReleaseAfterHold: boolean?)
	ArgCheck.assert(p >= 0, "signalHoldIntentSeconds must be greater than or equal to 0")
	ArgCheck.assert(durationSeconds > 0, "signalHoldCompleteSeconds must be greater than 0")
	ArgCheck.assert(p < durationSeconds, "signalHoldIntentSeconds should be less than signalHoldCompleteSeconds")

	local state, setState = React.useState(ButtonHoldStateEnum.NOT_HELD)
	local ref = React.useRef(nil)

	local holdTime, v = React.useBinding(0)
	local state2, setState2 = React.useState(nil)
	local ref2

	if FFlagEnableFocusNavTelemetry then
		ref2 = React.useRef(nil)
	else
		ref2 = nil
	end

	local onPress = React.useCallback(function()
		ref.current = tick()
		setState(ButtonHoldStateEnum.JUST_PRESSED)
	end, {})

	local onStep = React.useCallback(function(_)
		local now = tick()
		ArgCheck.assert(ref.current ~= nil, "startTime.current should not be nil")

		if ref.current then
			ArgCheck.assert(ref.current <= now, "startTime.current should be less than or equal to tick()")

			v(now - ref.current)
		end

		if p <= holdTime:getValue() then
			setState(ButtonHoldStateEnum.HOLDING)
		end
	end, { holdTime, p })

	local onComplete = React.useCallback(function()
		v(durationSeconds)
		ref.current = nil
		setState(ButtonHoldStateEnum.COMPLETED)

		if FFlagEnableFocusNavTelemetry and ref2 and ref2.current then
			local current = ref2.current
			ButtonHoldCompletedSignal:fire(current.eventName, current.keyCode, current.userInputType)
		end
	end, { durationSeconds })

	local v2 = React.useCallback(function()
		v(0)
		ref.current = nil
		setState(ButtonHoldStateEnum.NOT_HELD)
	end, {})

	local v3 = React.useCallback(InputHandlers.handleInput({
		hold = {
			durationSeconds = durationSeconds,
			onStep = onStep,
			onComplete = onComplete,
			allowReleaseAfterHold = allowReleaseAfterHold
		},
		onPress = onPress,
		onRelease = v2
	}), { v2, onStep, onComplete, durationSeconds, allowReleaseAfterHold })

	local eventHandler = React.useCallback(function(data)
		setState2(data.targetInstance)

		if FFlagEnableFocusNavTelemetry and ref2 and data.eventName then
			local v4 = ref2
			local current = { eventName = data.eventName, keyCode = 0, userInputType = 0 }
			local keyCode

			if data.eventData then
				keyCode = data.eventData.KeyCode
			end

			current.keyCode = keyCode
			local userInputType

			if data.eventData then
				userInputType = data.eventData.UserInputType
			end

			current.userInputType = userInputType
			v4.current = current
		end

		v3(data)
	end, { v3 })

	useFakeCancelHoldAfterBlur(state2, v3, v2)

	return {
		eventHandler = eventHandler,
		holdState = state,
		holdTime = holdTime,
		holdProgress = holdTime:map(function(p2: number)
			return p2 / durationSeconds
		end),
		cancelHold = v2
	}
end

return useButtonHold
