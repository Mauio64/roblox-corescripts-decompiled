local parent = script:FindFirstAncestor("GameCollections").Parent
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local InputHandlers = require(parent.InputHandlers)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local v = {
	[Enum.KeyCode.ButtonX] = FocusNavigationEventNameEnum.SeeAll,
	[Enum.KeyCode.ButtonA] = FocusNavigationEventNameEnum.HoldToPlay
}

local function useControllerBarFocusNavigationBindings(onSeeAll, handler)
	local v2 = React.useMemo(function()
		return {
			[FocusNavigationEventNameEnum.SeeAll] = onSeeAll and {
				handler = InputHandlers.onRelease(onSeeAll)
			} or nil,
			[FocusNavigationEventNameEnum.HoldToPlay] = handler and { handler = handler } or nil
		}
	end, { onSeeAll, handler })

	local v3 = ReactFocusNavigation.useEventMap(v)
	return ReactFocusNavigation.useEventHandlerMap(v2, v3)
end

return {
	["useControllerBarFocusNavigationBindings"] = useControllerBarFocusNavigationBindings,
	OnSeeAllControllerBarNavigateWrapper = function(p)
		local ref = useControllerBarFocusNavigationBindings(p.onSeeAll)

		return React.createElement(
			"Frame",
			{
				ref = ref,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1
			},
			p.children
		)
	end
}
