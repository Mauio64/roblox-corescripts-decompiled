local parent = script.Parent.Parent
local React = require(parent.React)
require(parent.FocusNavigation)

local FocusNavigationContext = require(script.Parent.FocusNavigationContext)
local useComposedRef = require(script.Parent.useComposedRef)
local useEventLifecycleRef = require(script.Parent.useEventLifecycleRef)

local function useEventMap(p, p2)
	local v = React.useContext(FocusNavigationContext)

	return useComposedRef(useEventLifecycleRef(React.useCallback(function(guiObject)
		if v then
			assert(guiObject:IsA("GuiObject"), "EventMaps can only be mapped to GuiObjects")
			v:registerEventMap(guiObject, p)
		end
	end, { v, p }), (React.useCallback(function(guiObject)
		if v then
			assert(guiObject:IsA("GuiObject"), "EventMaps can only be mapped to GuiObjects")
			v:deregisterEventMap(guiObject, p)
		end
	end, { v, p }))), p2)
end

return useEventMap
