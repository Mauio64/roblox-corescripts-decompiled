local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)

require(ParentParent.FocusNavigation)

local FocusNavigationContext = require(script.Parent.FocusNavigationContext)
local useComposedRef = require(script.Parent.useComposedRef)
local useEventLifecycleRef = require(script.Parent.useEventLifecycleRef)

local function useEventHandlerMap(p1, p2) -- line: 12
	-- upvalues: React (copy), FocusNavigationContext (copy), useEventLifecycleRef (copy), useComposedRef (copy)
	local v9 = React.useContext(FocusNavigationContext)
	local v10 = React.useCallback(function(p3) -- line: 15
		-- upvalues: v9 (copy), p1 (copy)
		if v9 then
			assert(p3:IsA("GuiObject"), "Event handler maps can only be applied to GuiObjects")
			v9:registerEventHandlers(p3, p1)
		end
	end, {
		v9,
		p1
	})
	local v11 = React.useCallback(function(p4) -- line: 22
		-- upvalues: v9 (copy), p1 (copy)
		if v9 then
			assert(p4:IsA("GuiObject"), "Event handler maps can only be applied to GuiObjects")
			v9:deregisterEventHandlers(p4, p1)
		end
	end, {
		v9,
		p1
	})
	local v12 = useEventLifecycleRef(v10, v11)

	return useComposedRef(v12, p2)
end

return useEventHandlerMap
