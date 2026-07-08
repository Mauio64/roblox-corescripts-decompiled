local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)

require(ParentParent.FocusNavigation)

local FocusNavigationContext = require(script.Parent.FocusNavigationContext)
local useComposedRef = require(script.Parent.useComposedRef)
local useEventLifecycleRef = require(script.Parent.useEventLifecycleRef)

local function useEventHandler(s1: string, p1, p2, p3) -- line: 14
	-- upvalues: React (copy), FocusNavigationContext (copy), useEventLifecycleRef (copy), useComposedRef (copy)
	local v11 = React.useContext(FocusNavigationContext)
	local v12 = React.useCallback(function(p4) -- line: 17
		-- upvalues: v11 (copy), s1 (copy), p1 (copy), p2 (copy)
		if v11 then
			assert(p4:IsA("GuiObject"), "Event handlers can only be applied to GuiObjects")
			v11:registerEventHandler(p4, s1, p1, p2)
		end
	end, {
		v11,
		s1,
		p1,
		p2
	})
	local v13 = React.useCallback(function(p5) -- line: 24
		-- upvalues: v11 (copy), s1 (copy), p1 (copy), p2 (copy)
		if v11 then
			assert(p5:IsA("GuiObject"), "Event handlers can only be applied to GuiObjects")
			v11:deregisterEventHandler(p5, s1, p1, p2)
		end
	end, {
		v11,
		s1,
		p1,
		p2
	})
	local v14 = useEventLifecycleRef(v12, v13)

	return useComposedRef(v14, p3)
end

return useEventHandler
