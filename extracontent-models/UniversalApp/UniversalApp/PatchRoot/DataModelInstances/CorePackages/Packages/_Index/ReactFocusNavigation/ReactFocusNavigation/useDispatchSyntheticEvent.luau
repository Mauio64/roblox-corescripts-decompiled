local parent = script.Parent.Parent
local React = require(parent.React)
require(parent.FocusNavigation)

local FocusNavigationContext = require(script.Parent.FocusNavigationContext)

local function useDispatchSyntheticEvent()
	local v = React.useContext(FocusNavigationContext)

	return (React.useCallback(function(p: string, guiObject, p2)
		if v then
			assert(guiObject:IsA("GuiObject"), "Synthetic events must be dispatched on GuiObjects")

			return v:dispatchSyntheticEvent(p, guiObject, p2)
		end

		if _G.__DEV__ then
			warn("useDispatchSyntheticEvent: No FocusNavigationService available in context")
		end

		return false
	end, { v }))
end

return useDispatchSyntheticEvent
