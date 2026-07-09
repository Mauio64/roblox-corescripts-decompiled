local Parent = script:FindFirstAncestor("AppShortcutBar").Parent
local Rodux = require(Parent.Dev.Rodux)
local React = require(Parent.React)
local ReactFocusNavigation = require(Parent.ReactFocusNavigation)
local mockProviders = require(Parent.Dev.UnitTestHelpers).mockProviders

local function FocusNavigationWrapper(p1) -- line: 7
	-- upvalues: ReactFocusNavigation (copy), React (copy)
	local v9 = ReactFocusNavigation.useFocusGuiObject()
	local v10 = React.useCallback(function(p2) -- line: 9
		-- upvalues: v9 (copy)
		if p2 then
			v9(p2, false)
		end
	end, { v9 })
	local v11 = ReactFocusNavigation.useEventMap(p1.eventMap, v10)
	local v12 = ReactFocusNavigation.useEventHandlerMap(p1.eventHandlerMap, v11)

	return React.createElement("Frame", {
		ref = v12
	}, p1.children)
end
local function createFocusNavigationWrapper(t1: {[any]: any}, p3) -- line: 19
	-- upvalues: Rodux (copy), React (copy), ReactFocusNavigation (copy), FocusNavigationWrapper (copy), mockProviders (copy)
	local v15 = Rodux.Store.new(function(p4) -- line: 27
		return p4
	end, p3 or {})

	local function CreatedWrapper(p5) -- line: 31
		-- upvalues: React (copy), ReactFocusNavigation (copy), t1 (copy), FocusNavigationWrapper (copy), mockProviders (copy), v15 (copy)
		local v20 = React.createElement(ReactFocusNavigation.FocusNavigationContext.Provider, {
			value = t1.focusNavigation
		}, React.createElement(FocusNavigationWrapper, {
			eventMap = t1.eventMap or {},
			eventHandlerMap = t1.eventHandlerMap or {}
		}, p5.children))

		return mockProviders(v20, {
			store = v15
		})
	end

	return CreatedWrapper
end

return createFocusNavigationWrapper
