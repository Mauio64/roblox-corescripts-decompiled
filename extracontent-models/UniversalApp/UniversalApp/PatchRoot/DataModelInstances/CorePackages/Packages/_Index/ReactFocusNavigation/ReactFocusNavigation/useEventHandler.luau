local parent = script.Parent.Parent
local React = require(parent.React)
require(parent.FocusNavigation)

local FocusNavigationContext = require(script.Parent.FocusNavigationContext)
local useComposedRef = require(script.Parent.useComposedRef)
local useEventLifecycleRef = require(script.Parent.useEventLifecycleRef)

local function useEventHandler(p: string, p2, p3, p4)
	local v = React.useContext(FocusNavigationContext)

	return useComposedRef(useEventLifecycleRef(React.useCallback(function(guiObject)
		if v then
			assert(guiObject:IsA("GuiObject"), "Event handlers can only be applied to GuiObjects")
			v:registerEventHandler(guiObject, p, p2, p3)
		end
	end, { v, p, p2, p3 }), (React.useCallback(function(guiObject)
		if v then
			assert(guiObject:IsA("GuiObject"), "Event handlers can only be applied to GuiObjects")
			v:deregisterEventHandler(guiObject, p, p2, p3)
		end
	end, { v, p, p2, p3 }))), p4)
end

return useEventHandler
