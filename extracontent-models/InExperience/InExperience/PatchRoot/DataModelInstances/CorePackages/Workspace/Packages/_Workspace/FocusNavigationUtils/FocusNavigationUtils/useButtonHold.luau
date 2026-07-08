local FocusNavigationUtils = script:FindFirstAncestor("FocusNavigationUtils")
local FocusNavigationUtilsParent = FocusNavigationUtils.Parent
local ArgCheck = require(FocusNavigationUtilsParent.ArgCheck)
local ButtonHoldStateEnum = require(FocusNavigationUtils.ButtonHoldStateEnum)
local InputHandlers = require(FocusNavigationUtilsParent.InputHandlers)
local React = require(FocusNavigationUtilsParent.React)

local function useFakeCancelHoldAfterBlur(p1, p2, p3) -- line: 18
	-- upvalues: React (copy)
	local v12 = React.useCallback(function() -- line: 19
		-- upvalues: p2 (copy), p3 (copy)
		p2({
			eventData = {
				UserInputState = Enum.UserInputState.End
			}
		})
		p3()
	end, {
		p2,
		p3
	})

	React.useEffect(function() -- line: 31
		-- upvalues: p1 (copy), v12 (copy)
		if p1 and p1:IsA("GuiObject") then
			local connection = p1.SelectionLost:Connect(v12)

			return function() -- line: 34
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end

		return function() -- line: 38
		end
	end, {
		p1,
		v12
	})
end
local function useButtonHold(n1: number, n2: number, b1: boolean?) -- line: 42
	-- upvalues: ArgCheck (copy), React (copy), ButtonHoldStateEnum (copy), InputHandlers (copy), useFakeCancelHoldAfterBlur (copy)
	ArgCheck.assert(n1 >= 0, "signalHoldIntentSeconds must be greater than or equal to 0")
	ArgCheck.assert(n2 > 0, "signalHoldCompleteSeconds must be greater than 0")
	ArgCheck.assert(n1 < n2, "signalHoldIntentSeconds should be less than signalHoldCompleteSeconds")

	local v16, v17 = React.useState(ButtonHoldStateEnum.NOT_HELD)
	local v18 = React.useRef(nil)
	local v19, v20 = React.useBinding(0)
	local v21, v22 = React.useState(nil)
	local v23 = React.useCallback(function() -- line: 59
		-- upvalues: v18 (copy), v17 (copy), ButtonHoldStateEnum (copy)
		v18.current = tick()
		v17(ButtonHoldStateEnum.JUST_PRESSED)
	end, {})
	local v24 = React.useCallback(function(_) -- line: 64
		-- upvalues: ArgCheck (copy), v18 (copy), v20 (copy), v19 (copy), n1 (copy), v17 (copy), ButtonHoldStateEnum (copy)
		local timestamp = tick()

		ArgCheck.assert(v18.current ~= nil, "startTime.current should not be nil")

		if v18.current then
			ArgCheck.assert(timestamp >= v18.current, "startTime.current should be less than or equal to tick()")
			v20(timestamp - v18.current)
		end

		if v19:getValue() >= n1 then
			v17(ButtonHoldStateEnum.HOLDING)
		end
	end, {
		v19,
		n1
	})
	local v25 = React.useCallback(function() -- line: 79
		-- upvalues: v20 (copy), n2 (copy), v18 (copy), v17 (copy), ButtonHoldStateEnum (copy)
		v20(n2)
		v18.current = nil
		v17(ButtonHoldStateEnum.COMPLETED)
	end, { n2 })
	local v26 = React.useCallback(function() -- line: 85
		-- upvalues: v20 (copy), v18 (copy), v17 (copy), ButtonHoldStateEnum (copy)
		v20(0)
		v18.current = nil
		v17(ButtonHoldStateEnum.NOT_HELD)
	end, {})
	local v27 = React.useCallback(InputHandlers.handleInput({
		hold = {
			durationSeconds = n2,
			onStep = v24,
			onComplete = v25,
			allowReleaseAfterHold = b1
		},
		onPress = v23,
		onRelease = v26
	}), {
		v26,
		v24,
		v25,
		n2,
		b1
	})
	local v28 = React.useCallback(function(p5) -- line: 111
		-- upvalues: v22 (copy), v27 (copy)
		v22(p5.targetInstance)
		v27(p5)
	end, { v27 })

	useFakeCancelHoldAfterBlur(v21, v27, v26)

	return {
		eventHandler = v28,
		holdState = v16,
		holdTime = v19,
		holdProgress = v19:map(function(n3: number) -- line: 122
			-- upvalues: n2 (copy)
			return n3 / n2
		end),
		cancelHold = v26
	}
end

return useButtonHold
