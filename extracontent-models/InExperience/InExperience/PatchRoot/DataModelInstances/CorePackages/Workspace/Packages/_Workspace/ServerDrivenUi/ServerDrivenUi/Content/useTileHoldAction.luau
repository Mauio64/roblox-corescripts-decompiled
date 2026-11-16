local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local React = require(parent.React)
require(parent.FocusNavigationUtils)

local function useTileHoldAction(data, callback, callback2)
	local state, setState = React.useState(nil)
	local ref = React.useRef(false)
	local v = data ~= nil
	local tileRef = React.useCallback(function(p)
		if callback then
			callback(p)
		end

		if v then
			setState(p)
		end
	end, { callback, v })

	local onActivated = React.useCallback(function()
		if ref.current then
			return
		end

		if callback2 then
			callback2()
		end
	end, { callback2 })
	local onHoldCompleted

	if data then
		onHoldCompleted = data.onHoldCompleted
	else
		onHoldCompleted = nil
	end

	local onHoldDetected = React.useCallback(function(p)
		if onHoldCompleted then
			onHoldCompleted(nil, p)
		end
	end, { onHoldCompleted })

	local setDisabledForHold = React.useCallback(function(current: boolean)
		ref.current = current
	end, {})

	return {
		tileRef = tileRef,
		onActivated = onActivated,
		holdDetectorProps = data and state and {
			guiObject = state,
			onHoldDetected = onHoldDetected,
			setDisabledForHold = setDisabledForHold,
			keyCode = data.keyCode,
			focusNavigationEventName = data.focusNavigationEventName,
			disableRegularActionOnHoldIntent = nil
		} or nil
	}
end

return useTileHoldAction
