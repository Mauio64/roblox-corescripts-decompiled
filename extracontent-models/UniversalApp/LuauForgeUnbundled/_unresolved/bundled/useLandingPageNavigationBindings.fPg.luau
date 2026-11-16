local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local focusNavigationEventNameEnum = require("@luauforge/bundled/eeo").FocusNavigationEventNameEnum

local function useLandingPageNavigationBindings()
	local v5 = React.useCallback(function(object)
		object:cancel()
	end, {})

	return (ReactFocusNavigation.useEventHandler(focusNavigationEventNameEnum.NavigateBack, v5))
end

return useLandingPageNavigationBindings
