local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)

require(Foundation.Utility.Plugin.StudioUri)

local usePlugin = require(Foundation.Providers.Plugin.usePlugin)
local WidgetManager = require(script.Parent.WidgetManager)
local WidgetsContext = require(script.Parent.WidgetsContext)

require(script.Parent.Types)

local function WidgetsProvider(t1: {[any]: any}) -- line: 21
	-- upvalues: usePlugin (copy), React (copy), WidgetManager (copy), WidgetsContext (copy)
	local v9 = usePlugin()

	if v9 == nil then
		error("WidgetsProvider must be used within a Plugin context")
	end

	local v10 = React.useMemo(function() -- line: 27
		-- upvalues: WidgetManager (copy), v9 (copy)
		return WidgetManager.new(v9:GetPluginComponent("Widgets"))
	end, { v9 })

	React.useEffect(function() -- line: 31
		-- upvalues: v10 (copy)
		return function() -- line: 32
			-- upvalues: v10 (copy)
			v10:destroy()
		end
	end, { v10 })

	local v11 = React.useCallback(function(p1, p2) -- line: 37
		-- upvalues: v10 (copy)
		v10:register(p1, p2)
	end, { v10 })
	local v12 = React.useCallback(function(p3, p4) -- line: 41
		-- upvalues: v10 (copy)
		v10:deregister(p3, p4)
	end, { v10 })
	local v13 = React.useCallback(function() -- line: 45
		-- upvalues: v10 (copy)
		return v10:nextId()
	end, { v10 })
	local t2 = {
		register = v11,
		deregister = v12,
		nextId = v13
	}

	return React.createElement(WidgetsContext.Provider, {
		value = t2
	}, t1.children)
end

return WidgetsProvider
