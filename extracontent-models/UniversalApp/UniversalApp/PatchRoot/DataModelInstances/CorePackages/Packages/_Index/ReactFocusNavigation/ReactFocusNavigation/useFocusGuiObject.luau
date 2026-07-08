local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local mockableWarn = require(ParentParent.FocusNavigationUtils).mockableWarn
local FocusNavigationContext = require(script.Parent.FocusNavigationContext)

local function useFocusGuiObject() -- line: 10
	-- upvalues: React (copy), FocusNavigationContext (copy), mockableWarn (copy)
	local v6 = React.useContext(FocusNavigationContext)

	return React.useCallback(function(p1, b1: boolean?) -- line: 13
		-- upvalues: v6 (copy), mockableWarn (copy)
		if v6 then
			v6:focusGuiObject(p1, not not b1)

			return
		end

		if _G.__DEV__ then
			mockableWarn("Could not capture focus with no FocusNavigationService.\n\nIntroduce a ReactFocusNavigation.FocusNavigationProvider above this component in the tree and provide it with a value returned from FocusNavigationService.new(...)")
		end
	end, { v6 })
end

return useFocusGuiObject
