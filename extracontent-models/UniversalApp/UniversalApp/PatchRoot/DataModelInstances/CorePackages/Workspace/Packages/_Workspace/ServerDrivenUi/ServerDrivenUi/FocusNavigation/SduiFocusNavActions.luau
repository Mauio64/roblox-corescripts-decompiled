local GuiService = game:GetService("GuiService")
local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(Parent.React)
local ReactFocusNavigation = require(Parent.ReactFocusNavigation)

require(Parent.SduiCoreSystem)

local function SduiFocusNavActions(t1: {[any]: any}) -- line: 21
	-- upvalues: React (copy), GuiService (copy), ReactFocusNavigation (copy)
	local keys = t1.focusNavActions.keys
	local events = t1.focusNavActions.events
	local v9 = React.useMemo(function() -- line: 24
		-- upvalues: t1 (copy), GuiService (copy)
		if t1.guiObject then
			return t1.guiObject
		end

		return GuiService.SelectedCoreObject
	end, { t1.guiObject })
	local v10 = ReactFocusNavigation.useEventMap(keys)
	local v11 = ReactFocusNavigation.useEventHandlerMap(events, v10)

	React.useEffect(function() -- line: 35
		-- upvalues: v11 (copy), v9 (copy)
		if v11 then
			v11(v9)
		end

		return function() -- line: 39
			-- upvalues: v11 (copy)
			v11(nil)
		end
	end, {
		v11,
		v9
	})

	return nil
end

return React.memo(SduiFocusNavActions)
