local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local FocusNavigationEventNameEnum = require(CorePackages.Workspace.Packages.FocusNavigationUtils).FocusNavigationEventNameEnum

local function useLandingPageNavigationBindings() -- line: 8
	-- upvalues: React (copy), ReactFocusNavigation (copy), FocusNavigationEventNameEnum (copy)
	local v6 = React.useCallback(function(p1) -- line: 9
		p1:cancel()
	end, {})

	return (ReactFocusNavigation.useEventHandler(FocusNavigationEventNameEnum.NavigateBack, v6))
end

return useLandingPageNavigationBindings
