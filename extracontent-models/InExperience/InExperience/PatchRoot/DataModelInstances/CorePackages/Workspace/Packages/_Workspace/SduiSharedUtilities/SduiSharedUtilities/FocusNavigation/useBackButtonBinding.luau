local parent = script:FindFirstAncestor("SduiSharedUtilities").Parent

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)

local NavigateBackBindings = require(script.Parent.NavigateBackBindings)
local useOnNavigateBack = NavigateBackBindings.useOnNavigateBack

local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function useBackButtonBinding(callback)
	local state, setState = React.useState(nil)

	local v = useOnNavigateBack(callback, (ReactFocusNavigation.useEventMap(navigateBacks)))

	React.useEffect(function()
		if v then
			v(state)
		end
	end, { v, state })

	return setState
end

return useBackButtonBinding
