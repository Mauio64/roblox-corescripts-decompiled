local Parent = script:FindFirstAncestor("AppBlox").Parent
local InputHandlers = require(Parent.InputHandlers)
local ReactFocusNavigation = require(Parent.ReactFocusNavigation)
local FocusNavigationEventNameEnum = require(Parent.FocusNavigationUtils).FocusNavigationEventNameEnum
local React = require(Parent.React)
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function useCloseWithBackButton(p1, p2: ((...any) -> ...any)?) -- line: 15
	-- upvalues: React (copy), InputHandlers (copy), ReactFocusNavigation (copy), t1 (copy), FocusNavigationEventNameEnum (copy)
	local v10 = React.useMemo(function() -- line: 16
		-- upvalues: InputHandlers (copy), p2 (copy)
		return InputHandlers.onRelease(function(p3) -- line: 17
			-- upvalues: p2 (copy)
			if p2 then
				p2()
				p3:cancel()
			end
		end)
	end, { p2 })
	local v11 = ReactFocusNavigation.useEventMap(t1, p1)

	return (ReactFocusNavigation.useEventHandler(FocusNavigationEventNameEnum.NavigateBack, v10, nil, v11))
end

return useCloseWithBackButton
