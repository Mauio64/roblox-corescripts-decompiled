local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)

require(ParentParent.FocusNavigation)

local FocusNavigationContext = require(script.Parent.FocusNavigationContext)

local function useDispatchSyntheticEvent() -- line: 16
	-- upvalues: React (copy), FocusNavigationContext (copy)
	local v5 = React.useContext(FocusNavigationContext)

	return (React.useCallback(function(s1: string, p1, p2) -- line: 20
		-- upvalues: v5 (copy)
		if not v5 then
			if _G.__DEV__ then
				warn("useDispatchSyntheticEvent: No FocusNavigationService available in context")
			end

			return false
		end

		assert(p1:IsA("GuiObject"), "Synthetic events must be dispatched on GuiObjects")

		return v5:dispatchSyntheticEvent(s1, p1, p2)
	end, { v5 }))
end

return useDispatchSyntheticEvent
