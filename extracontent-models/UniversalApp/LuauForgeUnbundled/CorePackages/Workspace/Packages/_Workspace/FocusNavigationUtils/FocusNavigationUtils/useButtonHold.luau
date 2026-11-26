local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/ArgCheck")
local ButtonHoldStateEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/ButtonHoldStateEnum")
local ButtonHoldCompletedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/ButtonHoldCompletedSignal")
local fFlagEnableFocusNavTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/SharedFlags").FFlagEnableFocusNavTelemetry

local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/InputHandlers")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/React")

local function useFakeCancelHoldAfterBlur(guiObject, callback, callback2)
	local v5 = React.useCallback(function()
		callback({
			eventData = { UserInputState = Enum.UserInputState.End }
		})

		callback2()
	end, { callback, callback2 })

	React.useEffect(function()
		if guiObject and guiObject:IsA("GuiObject") then
			local selectionLostConnection = guiObject.SelectionLost:Connect(v5)
			return function()
				selectionLostConnection:Disconnect()
			end
		end

		return function() end
	end, { guiObject, v5 })
end

local function useButtonHold(p2, p3, p4)
	ArgCheck.assert(p2 >= 0, "signalHoldIntentSeconds must be greater than or equal to 0")
	ArgCheck.assert(p3 > 0, "signalHoldCompleteSeconds must be greater than 0")
	ArgCheck.assert(p2 < p3, "signalHoldIntentSeconds should be less than signalHoldCompleteSeconds")

	local state, setState = React.useState(ButtonHoldStateEnum.NOT_HELD)
	local ref = React.useRef(nil)

	local v5, v6 = React.useBinding(0)
	local state2, setState2 = React.useState(nil)

	local ref2 = if fFlagEnableFocusNavTelemetry then React.useRef(nil) else nil

	local v7 = React.useCallback(function()
		ref.current = tick()
		setState(ButtonHoldStateEnum.JUST_PRESSED)
	end, {})

	local v8 = React.useCallback(function(p5)
		local now = tick()
		ArgCheck.assert(ref.current ~= nil, "startTime.current should not be nil")

		if ref.current then
			ArgCheck.assert(ref.current <= now, "startTime.current should be less than or equal to tick()")

			v6(now - ref.current)
		end

		if p2 <= v5:getValue() then
			setState(ButtonHoldStateEnum.HOLDING)
		end
	end, { v5, p2 })

	local v9 = React.useCallback(function()
		v6(p3)
		ref.current = nil
		setState(ButtonHoldStateEnum.COMPLETED)

		if fFlagEnableFocusNavTelemetry and ref2 and ref2.current then
			local current = ref2.current
			ButtonHoldCompletedSignal:fire(current.eventName, current.keyCode, current.userInputType)
		end
	end, { p3 })

	local v10 = React.useCallback(function()
		v6(0)
		ref.current = nil
		setState(ButtonHoldStateEnum.NOT_HELD)
	end, {})

	local v11 = React.useCallback(InputHandlers.handleInput({
		hold = {
			durationSeconds = p3,
			onStep = v8,
			onComplete = v9,
			allowReleaseAfterHold = p4
		},
		onPress = v7,
		onRelease = v10
	}), { v10, v8, v9, p3, p4 })

	local v12 = React.useCallback(function(data)
		setState2(data.targetInstance)

		if fFlagEnableFocusNavTelemetry and ref2 and data.eventName then
			local v13 = ref2
			local v14 = { eventName = data.eventName, keyCode = 0, userInputType = 0 }
			local v15 = if data.eventData then data.eventData.KeyCode else nil
			v14.keyCode = v15
			local v16 = if data.eventData then data.eventData.UserInputType else nil
			v14.userInputType = v16
			v13.current = v14
		end

		v11(data)
	end, { v11 })

	useFakeCancelHoldAfterBlur(state2, v11, v10)

	return {
		eventHandler = v12,
		holdState = state,
		holdTime = v5,
		holdProgress = v5:map(function(p5)
			return p5 / p3
		end),
		cancelHold = v10
	}
end

return useButtonHold
