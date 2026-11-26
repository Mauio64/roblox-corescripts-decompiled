local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/FocusNavigationUtils")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/ReactFocusNavigation")

local useOnNavigateBack = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/FocusNavigation/NavigateBackBindings").useOnNavigateBack

local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function useBackButtonBinding(p2)
	local state, setState = React.useState(nil)

	local v6 = useOnNavigateBack(p2, (ReactFocusNavigation.useEventMap(navigateBacks)))

	React.useEffect(function()
		if v6 then
			v6(state)
		end
	end, { v6, state })

	return setState
end

return useBackButtonBinding
