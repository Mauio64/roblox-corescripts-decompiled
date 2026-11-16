local GuiService = game:GetService("GuiService")
local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local React = require(parent.React)

local ReactFocusNavigation = require(parent.ReactFocusNavigation)
require(parent.SduiCoreSystem)

local function SduiFocusNavActions(p): nil
	local keys = p.focusNavActions.keys
	local events = p.focusNavActions.events
	local v = React.useMemo(function()
		if p.guiObject then
			return p.guiObject
		end

		return GuiService.SelectedCoreObject
	end, { p.guiObject })

	local v2 = ReactFocusNavigation.useEventMap(keys)

	local v3 = ReactFocusNavigation.useEventHandlerMap(events, v2)

	React.useEffect(function()
		if v3 then
			v3(v)
		end

		return function()
			v3(nil)
		end
	end, { v3, v })

	return nil
end

return React.memo(SduiFocusNavActions)
