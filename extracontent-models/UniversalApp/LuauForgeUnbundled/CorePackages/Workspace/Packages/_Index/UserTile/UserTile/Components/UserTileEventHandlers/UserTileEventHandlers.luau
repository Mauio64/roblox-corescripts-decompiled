local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/React")
local holdDetector = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/HoldToPlay").HoldDetector
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/ReactFocusNavigation")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/InputHandlers")
require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/FocusNavigationUtils")

local fFlagUserSearchCancelTileActivationOnHoldIntent = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/SharedFlags").FFlagUserSearchCancelTileActivationOnHoldIntent

local v5 = { primary = Enum.KeyCode.ButtonA, secondary = Enum.KeyCode.ButtonX }

local function UserTileEventHandlers(props)
	local tileRef = props.tileRef
	local buttons = props.buttons
	local onTileActivated = props.onTileActivated

	local ref = React.useRef(false)

	local v6 = React.useCallback(function(current)
		ref.current = current

		if fFlagUserSearchCancelTileActivationOnHoldIntent and props.setDisabledForHold then
			props.setDisabledForHold(current)
		end
	end, fFlagUserSearchCancelTileActivationOnHoldIntent and { props.setDisabledForHold } or {})

	local v7, v8 = React.useMemo(function()
		if buttons then
			return buttons[#buttons], buttons[#buttons - 1]
		end

		return nil, nil
	end, { buttons })

	local v9 = React.useCallback(function()
		if ref.current then
			return
		end

		onTileActivated()
	end, { onTileActivated })

	local v10 = React.useCallback(function()
		if v7 and v7.onActivated then
			v7.onActivated()
		end
	end, { v7 })

	local v11 = React.useCallback(function()
		if v8 and v8.onActivated then
			v8.onActivated()
		end
	end, { v8 })

	local v12, v13 = React.useMemo(function()
		local focusEventName = if v8 then v8.focusEventName else nil

		if not focusEventName then
			return {}, {}
		end

		return { [v5.secondary] = focusEventName }, {
			[focusEventName] = { handler = InputHandlers.onRelease(v11) }
		}
	end, { v8, v11 })

	local v14 = ReactFocusNavigation.useEventMap(v12)

	local v15 = ReactFocusNavigation.useEventHandlerMap(v13, v14)

	local function fn()
		if v15 and tileRef then
			v15(tileRef.current)
		end

		return function()
			v15(nil)
		end
	end

	React.useEffect(fn, { v15, if fFlagUserSearchCancelTileActivationOnHoldIntent then tileRef else nil })

	if fFlagUserSearchCancelTileActivationOnHoldIntent then
		React.useEffect(function()
			if not tileRef then
				return
			end

			local current = tileRef.current

			if not current then
				return
			end

			local function clearHoldGuard()
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
				local v18 = userInputType == Enum.UserInputType.MouseButton1
					or userInputType == Enum.UserInputType.Touch
				local v19 = input.KeyCode == v5.primary

				if input.UserInputState == Enum.UserInputState.Begin and (v18 or v19) then
					if not ref.current then
						return
					end

					ref.current = false

					if props.setDisabledForHold then
						props.setDisabledForHold(false)
					end
				end
			end)
			return function()
				selectionLostConnection:Disconnect()
				inputBeganConnection:Disconnect()
			end
		end, { props.setDisabledForHold, tileRef })
	end

	local focusEventName = v7 and v7.focusEventName or nil

	if tileRef.current and focusEventName then
		return (React.createElement(holdDetector, {
			guiObject = tileRef.current,
			onHoldDetected = v10,
			onRegularActivated = v9,
			setDisabledForHold = v6,
			keyCode = v5.primary,
			focusNavigationEventName = focusEventName,
			disableRegularActionOnHoldIntent = props.disableRegularActionOnHoldIntent
		}))
	end

	return nil
end

return UserTileEventHandlers
