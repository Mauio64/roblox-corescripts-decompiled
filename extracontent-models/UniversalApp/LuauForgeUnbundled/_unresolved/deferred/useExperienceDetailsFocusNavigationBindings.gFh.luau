local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = require("@luauforge/bundled/ehL").FocusNavigationEventNameEnum

local v5 = {
	[Enum.KeyCode.ButtonY] = focusNavigationEventNameEnum.DisplayStatsAndInfo,
	[Enum.KeyCode.ButtonX] = focusNavigationEventNameEnum.Play
}

local function useExperienceDetailsFocusNavigationBindings(p2, p3)
	local v6 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.Play] = {
				handler = InputHandlers.onRelease(p2)
			},
			[focusNavigationEventNameEnum.DisplayStatsAndInfo] = {
				handler = InputHandlers.onRelease(p3)
			}
		}
	end, { p2, p3 })

	local state, setState = React.useState(true)

	local ref = React.useRef(nil)
	local v8 = ReactFocusNavigation.useEventMap(not state and {} or v5, ref)
	return ReactFocusNavigation.useEventHandlerMap(not state and {} or v6, v8), setState
end

return useExperienceDetailsFocusNavigationBindings
