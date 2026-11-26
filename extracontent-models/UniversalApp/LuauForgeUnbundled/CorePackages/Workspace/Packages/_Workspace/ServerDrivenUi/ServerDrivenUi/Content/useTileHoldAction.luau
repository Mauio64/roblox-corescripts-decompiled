local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/FocusNavigationUtils")

local function useTileHoldAction(data, callback, callback2)
	local state, setState = React.useState(nil)
	local ref = React.useRef(false)
	local v5 = data ~= nil
	local v6 = React.useCallback(function(p2)
		if callback then
			callback(p2)
		end

		if v5 then
			setState(p2)
		end
	end, { callback, v5 })

	local v7 = React.useCallback(function()
		if ref.current then
			return
		end

		if callback2 then
			callback2()
		end
	end, { callback2 })

	local onHoldCompleted = if data then data.onHoldCompleted else nil
	local v8 = React.useCallback(function(p2)
		if onHoldCompleted then
			onHoldCompleted(nil, p2)
		end
	end, { onHoldCompleted })

	local v9 = React.useCallback(function(current)
		ref.current = current
	end, {})

	return {
		tileRef = v6,
		onActivated = v7,
		holdDetectorProps = data and state and {
			guiObject = state,
			onHoldDetected = v8,
			setDisabledForHold = v9,
			keyCode = data.keyCode,
			focusNavigationEventName = data.focusNavigationEventName,
			disableRegularActionOnHoldIntent = nil
		} or nil
	}
end

return useTileHoldAction
