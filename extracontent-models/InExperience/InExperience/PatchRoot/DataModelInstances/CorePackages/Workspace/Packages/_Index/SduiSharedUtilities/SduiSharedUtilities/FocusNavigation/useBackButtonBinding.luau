local Parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local React = require(Parent.React)
local ReactFocusNavigation = require(Parent.ReactFocusNavigation)
local useOnNavigateBack = require(script.Parent.NavigateBackBindings).useOnNavigateBack
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function useBackButtonBinding(p1: ((...any) -> ...any)) -- line: 27
	-- upvalues: React (copy), ReactFocusNavigation (copy), t1 (copy), useOnNavigateBack (copy)
	local v10, v11 = React.useState(nil)
	local v12 = ReactFocusNavigation.useEventMap(t1)
	local v13 = useOnNavigateBack(p1, v12)

	React.useEffect(function() -- line: 33
		-- upvalues: v13 (copy), v10 (copy)
		if v13 then
			v13(v10)
		end
	end, {
		v13,
		v10
	})

	return v11
end

return useBackButtonBinding
