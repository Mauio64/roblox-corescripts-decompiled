local parent = script.Parent.Parent
local React = require(parent.React)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)

local mockableWarn = FocusNavigationUtils.mockableWarn

local FocusNavigationContext = require(script.Parent.FocusNavigationContext)

local function useFocusGuiObject()
	local v = React.useContext(FocusNavigationContext)

	return React.useCallback(function(p, flag: boolean?)
		if v then
			v:focusGuiObject(p, flag and true or false)
		elseif _G.__DEV__ then
			mockableWarn([[
Could not capture focus with no FocusNavigationService.

Introduce a ReactFocusNavigation.FocusNavigationProvider above this component in the tree and provide it with a value returned from FocusNavigationService.new(...)]])
		end
	end, { v })
end

return useFocusGuiObject
