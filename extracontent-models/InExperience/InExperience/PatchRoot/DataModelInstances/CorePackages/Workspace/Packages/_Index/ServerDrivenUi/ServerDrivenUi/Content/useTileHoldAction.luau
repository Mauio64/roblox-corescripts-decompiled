local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(Parent.React)

require(Parent.FocusNavigationUtils)

local function useTileHoldAction(t1: {[any]: any}?, p1: ((...any) -> ...any)?, p2: ((...any) -> ...any)?) -- line: 43
	-- upvalues: React (copy)
	local v7, v8 = React.useState(nil)
	local v9 = React.useRef(false)
	local v10 = t1 ~= nil
	local v11 = React.useCallback(function(p3) -- line: 52
		-- upvalues: p1 (copy), v10 (copy), v8 (copy)
		if p1 then
			p1(p3)
		end

		if v10 then
			v8(p3)
		end
	end, {
		p1,
		v10
	})
	local v12 = React.useCallback(function() -- line: 65
		-- upvalues: v9 (copy), p2 (copy)
		if v9.current then
			return
		end

		if p2 then
			p2()
		end
	end, { p2 })
	local v13 = if not t1 then nil else t1.onHoldCompleted
	local v14 = React.useCallback(function(p4) -- line: 75
		-- upvalues: v13 (copy)
		if v13 then
			v13(nil, p4)
		end
	end, { v13 })
	local v15 = React.useCallback(function(b1: boolean) -- line: 81
		-- upvalues: v9 (copy)
		v9.current = b1
	end, {})
	local v16 = if not t1 or not v7 then nil else {
		guiObject = v7,
		onHoldDetected = v14,
		setDisabledForHold = v15,
		keyCode = t1.keyCode,
		focusNavigationEventName = t1.focusNavigationEventName
	}

	return {
		tileRef = v11,
		onActivated = v12,
		holdDetectorProps = v16
	}
end

return useTileHoldAction
