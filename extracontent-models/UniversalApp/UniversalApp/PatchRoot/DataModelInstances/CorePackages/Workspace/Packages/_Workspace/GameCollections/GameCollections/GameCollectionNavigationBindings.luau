local Parent = script:FindFirstAncestor("GameCollections").Parent
local React = require(Parent.React)
local ReactFocusNavigation = require(Parent.ReactFocusNavigation)
local InputHandlers = require(Parent.InputHandlers)
local FocusNavigationEventNameEnum = require(Parent.FocusNavigationUtils).FocusNavigationEventNameEnum
local t1 = {
	[Enum.KeyCode.ButtonX] = FocusNavigationEventNameEnum.SeeAll,
	[Enum.KeyCode.ButtonA] = FocusNavigationEventNameEnum.HoldToPlay
}
local t2 = {}

local function useControllerBarFocusNavigationBindings(p1: ((...any) -> ...any)?, p2: ((...any) -> ...any)?) -- line: 23
	-- upvalues: React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), ReactFocusNavigation (copy), t1 (copy)
	local v11 = React.useMemo(function() -- line: 24
		-- upvalues: FocusNavigationEventNameEnum (copy), p1 (copy), InputHandlers (copy), p2 (copy)
		return {
			[FocusNavigationEventNameEnum.SeeAll] = if not p1 then nil else {
				handler = InputHandlers.onRelease(p1)
			},
			[FocusNavigationEventNameEnum.HoldToPlay] = if not p2 then nil else {
				handler = p2
			}
		}
	end, {
		p1,
		p2
	})
	local v12 = ReactFocusNavigation.useEventMap(t1)

	return ReactFocusNavigation.useEventHandlerMap(v11, v12)
end

t2.useControllerBarFocusNavigationBindings = useControllerBarFocusNavigationBindings

function t2.OnSeeAllControllerBarNavigateWrapper(t3: {[any]: any}) -- line: 45
	-- upvalues: useControllerBarFocusNavigationBindings (copy), React (copy)
	local v14 = useControllerBarFocusNavigationBindings(t3.onSeeAll)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ref = v14,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, t3.children)
end

return t2
