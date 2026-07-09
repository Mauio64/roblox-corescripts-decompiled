local ParentParent = script.Parent.Parent
local React = require(ParentParent.Dev.React)
local ReactFocusNavigation = require(ParentParent.Dev.ReactFocusNavigation)
local v4 = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)

return function(p1) -- line: 8
	-- upvalues: React (copy), ReactFocusNavigation (copy), v4 (copy)
	return function(p2) -- line: 9
		-- upvalues: React (copy), ReactFocusNavigation (copy), v4 (copy), p1 (copy)
		return React.createElement(ReactFocusNavigation.FocusNavigationContext.Provider, {
			value = v4
		}, React.createElement(p1, p2))
	end
end
