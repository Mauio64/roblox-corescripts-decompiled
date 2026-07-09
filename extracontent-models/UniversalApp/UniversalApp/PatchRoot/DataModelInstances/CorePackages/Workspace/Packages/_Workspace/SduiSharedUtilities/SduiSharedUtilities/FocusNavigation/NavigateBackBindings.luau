local Parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local React = require(Parent.React)
local ReactFocusNavigation = require(Parent.ReactFocusNavigation)
local InputHandlers = require(Parent.InputHandlers)
local FocusNavigationEventNameEnum = require(Parent.FocusNavigationUtils).FocusNavigationEventNameEnum
local t1 = {}

local function useOnNavigateBack(p1: ((...any) -> ...any), p2) -- line: 21
	-- upvalues: React (copy), InputHandlers (copy), ReactFocusNavigation (copy), FocusNavigationEventNameEnum (copy)
	local v10 = React.useCallback(InputHandlers.onRelease(function(p3) -- line: 23
		-- upvalues: p1 (copy)
		p3:cancel()
		p1()
	end), { p1 })

	return ReactFocusNavigation.useEventHandler(FocusNavigationEventNameEnum.NavigateBack, v10, nil, p2)
end

t1.useOnNavigateBack = useOnNavigateBack

function t1.OnNavigateBackWrapper(t2: {[any]: any}) -- line: 40
	-- upvalues: useOnNavigateBack (copy), React (copy)
	local v12 = useOnNavigateBack(t2.onNavigateBack)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ref = v12,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, t2.children)
end

return t1
