local parent = script:FindFirstAncestor("UserTile").Parent

local React = require(parent.React)
local HoldToPlay = require(parent.HoldToPlay)
local HoldDetector = HoldToPlay.HoldDetector
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local InputHandlers = require(parent.InputHandlers)
require(parent.FocusNavigationUtils)

local SharedFlags = require(parent.SharedFlags)
local FFlagUserSearchCancelTileActivationOnHoldIntent = SharedFlags.FFlagUserSearchCancelTileActivationOnHoldIntent

local v = { primary = Enum.KeyCode.ButtonA, secondary = Enum.KeyCode.ButtonX }

local function UserTileEventHandlers(props)
	local tileRef = props.tileRef
	local buttons = props.buttons
	local onTileActivated = props.onTileActivated

	local ref = React.useRef(false)

	local setDisabledForHold = React.useCallback(function(current: boolean)
		ref.current = current

		if FFlagUserSearchCancelTileActivationOnHoldIntent and props.setDisabledForHold then
			props.setDisabledForHold(current)
		end
	end, FFlagUserSearchCancelTileActivationOnHoldIntent and { props.setDisabledForHold } or {})

	local v2, v3 = React.useMemo(function()
		if buttons then
			return buttons[#buttons], buttons[#buttons - 1]
		end

		return nil, nil
	end, { buttons })

	local onRegularActivated = React.useCallback(function()
		if ref.current then
			return
		end

		onTileActivated()
	end, { onTileActivated })

	local onHoldDetected = React.useCallback(function()
		if v2 and v2.onActivated then
			v2.onActivated()
		end
	end, { v2 })

	local v4 = React.useCallback(function()
		if v3 and v3.onActivated then
			v3.onActivated()
		end
	end, { v3 })

	local v5, v6 = React.useMemo(function()
		local focusEventName

		if v3 then
			focusEventName = v3.focusEventName
		end

		if not focusEventName then
			return {}, {}
		end

		return { [v.secondary] = focusEventName }, {
			[focusEventName] = { handler = InputHandlers.onRelease(v4) }
		}
	end, { v3, v4 })

	local v7 = ReactFocusNavigation.useEventMap(v5)

	local v8 = ReactFocusNavigation.useEventHandlerMap(v6, v7)

	local useEffect = React.useEffect
	local function fn()
		if v8 and tileRef then
			v8(tileRef.current)
		end

		return function()
			v8(nil)
		end
	end

	local v9

	if FFlagUserSearchCancelTileActivationOnHoldIntent then
		v9 = tileRef
	end

	useEffect(fn, { v8, v9 })

	if FFlagUserSearchCancelTileActivationOnHoldIntent then
		React.useEffect(function()
			if not tileRef then
				return
			end

			local current = tileRef.current

			if not current then
				return
			end

			local function clearHoldGuard() -- 1 equivalent call inferred from this helper
				if not ref.current then
					return
				end

				ref.current = false

				if props.setDisabledForHold then
					props.setDisabledForHold(false)
				end
			end
			local selectionLostConnection = current.SelectionLost:Connect(clearHoldGuard)
			local inputBeganConnection = current.InputBegan:Connect(function(input)
				local userInputType = input.UserInputType
				local v10 = userInputType == Enum.UserInputType.MouseButton1
					or userInputType == Enum.UserInputType.Touch
				local v11 = input.KeyCode == v.primary

				if input.UserInputState == Enum.UserInputState.Begin and (v10 or v11) then
					clearHoldGuard() -- inferred equivalent call
				end
			end)
			return function()
				selectionLostConnection:Disconnect()
				inputBeganConnection:Disconnect()
			end
		end, { props.setDisabledForHold, tileRef })
	end

	local focusEventName = v2 and v2.focusEventName or nil

	if tileRef.current and focusEventName then
		return (React.createElement(HoldDetector, {
			guiObject = tileRef.current,
			onHoldDetected = onHoldDetected,
			onRegularActivated = onRegularActivated,
			setDisabledForHold = setDisabledForHold,
			keyCode = v.primary,
			focusNavigationEventName = focusEventName,
			disableRegularActionOnHoldIntent = props.disableRegularActionOnHoldIntent
		}))
	end

	return nil
end

return UserTileEventHandlers
