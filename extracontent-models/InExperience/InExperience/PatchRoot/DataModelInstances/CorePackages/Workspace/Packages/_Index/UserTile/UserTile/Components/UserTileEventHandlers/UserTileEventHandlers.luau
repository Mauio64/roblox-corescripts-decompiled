local Parent = script:FindFirstAncestor("UserTile").Parent
local React = require(Parent.React)
local HoldDetector = require(Parent.HoldToPlay).HoldDetector
local ReactFocusNavigation = require(Parent.ReactFocusNavigation)
local InputHandlers = require(Parent.InputHandlers)

require(Parent.FocusNavigationUtils)

local t1 = {
	primary = Enum.KeyCode.ButtonA,
	secondary = Enum.KeyCode.ButtonX
}

local function UserTileEventHandlers(t2: {[any]: any}) -- line: 30
	-- upvalues: React (copy), t1 (copy), InputHandlers (copy), ReactFocusNavigation (copy), HoldDetector (copy)
	local tileRef = t2.tileRef
	local buttons = t2.buttons
	local onTileActivated = t2.onTileActivated
	local v12 = React.useRef(false)
	local v13 = React.useCallback(function(b1: boolean) -- line: 36
		-- upvalues: v12 (copy)
		v12.current = b1
	end, {})
	local v14, v15 = React.useMemo(function() -- line: 40
		-- upvalues: buttons (copy)
		if buttons then
			return buttons[#buttons], buttons[#buttons - 1]
		end

		return nil, nil
	end, { buttons })
	local v16 = React.useCallback(function() -- line: 47
		-- upvalues: v12 (copy), onTileActivated (copy)
		if v12.current then
			return
		end

		onTileActivated()
	end, { onTileActivated })
	local v17 = React.useCallback(function() -- line: 54
		-- upvalues: v14 (copy)
		if v14 and v14.onActivated then
			v14.onActivated()
		end
	end, { v14 })
	local v18 = React.useCallback(function() -- line: 60
		-- upvalues: v15 (copy)
		if v15 and v15.onActivated then
			v15.onActivated()
		end
	end, { v15 })
	local v19, v20 = React.useMemo(function() -- line: 66
		-- upvalues: v15 (copy), t1 (copy), InputHandlers (copy), v18 (copy)
		local v25 = if not v15 then nil else v15.focusEventName

		if v25 then
			return {
				[t1.secondary] = v25
			}, {
				[v25] = {
					handler = InputHandlers.onRelease(v18)
				}
			}
		end

		return {}, {}
	end, {
		v15,
		v18
	})
	local v21 = ReactFocusNavigation.useEventMap(v19)
	local v22 = ReactFocusNavigation.useEventHandlerMap(v20, v21)

	React.useEffect(function() -- line: 87
		-- upvalues: v22 (copy), tileRef (copy)
		if v22 and tileRef then
			v22(tileRef.current)
		end

		return function() -- line: 91
			-- upvalues: v22 (copy)
			v22(nil)
		end
	end, { v22 })

	local v23 = v14 and v14.focusEventName or nil

	if tileRef.current and v23 then
		return (React.createElement(HoldDetector, {
			guiObject = tileRef.current,
			onHoldDetected = v17,
			onRegularActivated = v16,
			setDisabledForHold = v13,
			keyCode = t1.primary,
			focusNavigationEventName = v23
		}))
	end

	return nil
end

return UserTileEventHandlers
