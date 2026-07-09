local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = require(CorePackages.Workspace.Packages.FocusNavigationUtils).FocusNavigationEventNameEnum
local t1 = {
	[Enum.KeyCode.ButtonY] = FocusNavigationEventNameEnum.DisplayStatsAndInfo,
	[Enum.KeyCode.ButtonX] = FocusNavigationEventNameEnum.Play
}

local function useExperienceDetailsFocusNavigationBindings(p1, p2) -- line: 16
	-- upvalues: React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), t1 (copy), ReactFocusNavigation (copy)
	local v10 = React.useMemo(function() -- line: 17
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), p1 (copy), p2 (copy)
		return {
			[FocusNavigationEventNameEnum.Play] = {
				handler = InputHandlers.onRelease(p1)
			},
			[FocusNavigationEventNameEnum.DisplayStatsAndInfo] = {
				handler = InputHandlers.onRelease(p2)
			}
		}
	end, {
		p1,
		p2
	})
	local v11, v12 = React.useState(true)
	local v13 = if not v11 then {} else t1
	local v14 = React.useRef(nil)
	local v15 = ReactFocusNavigation.useEventMap(v13, v14)

	return ReactFocusNavigation.useEventHandlerMap(if not v11 then {} else v10, v15), v12
end

return useExperienceDetailsFocusNavigationBindings
