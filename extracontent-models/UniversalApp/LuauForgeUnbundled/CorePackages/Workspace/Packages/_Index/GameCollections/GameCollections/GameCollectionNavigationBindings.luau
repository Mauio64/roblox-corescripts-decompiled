local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/ReactFocusNavigation")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/InputHandlers")
local focusNavigationEventNameEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/FocusNavigationUtils").FocusNavigationEventNameEnum

local v5 = {
	[Enum.KeyCode.ButtonX] = focusNavigationEventNameEnum.SeeAll,
	[Enum.KeyCode.ButtonA] = focusNavigationEventNameEnum.HoldToPlay
}

local function useControllerBarFocusNavigationBindings(onSeeAll, p2)
	local v7 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.SeeAll] = onSeeAll and {
				handler = InputHandlers.onRelease(onSeeAll)
			} or nil,
			[focusNavigationEventNameEnum.HoldToPlay] = p2 and { handler = p2 } or nil
		}
	end, { onSeeAll, p2 })

	local v8 = ReactFocusNavigation.useEventMap(v5)
	return ReactFocusNavigation.useEventHandlerMap(v7, v8)
end

return {
	["useControllerBarFocusNavigationBindings"] = useControllerBarFocusNavigationBindings,
	OnSeeAllControllerBarNavigateWrapper = function(p2)
		local v7 = useControllerBarFocusNavigationBindings(p2.onSeeAll)

		return React.createElement(
			"Frame",
			{
				ref = v7,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1
			},
			p2.children
		)
	end
}
