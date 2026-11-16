local GuiService = game:GetService("GuiService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")

local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ReactFocusNavigation")
require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")

local function SduiFocusNavActions(p2): nil
	local keys = p2.focusNavActions.keys
	local events = p2.focusNavActions.events
	local v5 = React.useMemo(function()
		if p2.guiObject then
			return p2.guiObject
		end

		return GuiService.SelectedCoreObject
	end, { p2.guiObject })

	local v6 = ReactFocusNavigation.useEventMap(keys)

	local v7 = ReactFocusNavigation.useEventHandlerMap(events, v6)

	React.useEffect(function()
		if v7 then
			v7(v5)
		end

		return function()
			v7(nil)
		end
	end, { v7, v5 })

	return nil
end

return React.memo(SduiFocusNavActions)
