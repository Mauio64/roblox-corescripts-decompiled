local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Flags = require(Foundation.Utility.Flags)
require(Foundation.Utility.Plugin.StudioUri)
local usePlugin = require(Foundation.Providers.Plugin.usePlugin)

local WidgetManager = require(script.Parent.WidgetManager)
local WidgetsContext = require(script.Parent.WidgetsContext)

require(script.Parent.Types)

local function WidgetsProvider(p)
	local v = usePlugin()

	if v == nil then
		error("WidgetsProvider must be used within a Plugin context")
	end

	local v2 = React.useMemo(function()
		return WidgetManager.new(v:GetPluginComponent("Widgets"))
	end, { v })

	React.useEffect(function()
		return function()
			v2:destroy()
		end
	end, { v2 })

	local register = React.useCallback(function(p2, p3)
		v2:register(p2, p3)
	end, { v2 })

	local deregister = React.useCallback(function(p2, p3)
		v2:deregister(p2, p3)
	end, { v2 })
	local v3

	if Flags.FoundationPopoverPluginAnchorRefresh then
		v3 = React.useCallback(function(p2)
			return v2:refreshAsync(p2)
		end, { v2 })
	else
		v3 = nil
	end

	local nextId = React.useCallback(function()
		return v2:nextId()
	end, { v2 })

	local v4 = React.useMemo(function()
		local v4 = { register = register, deregister = deregister, refreshAsync = 0, nextId = 0 }
		local refreshAsync

		if Flags.FoundationPopoverPluginAnchorRefresh then
			refreshAsync = v3
		end

		v4.refreshAsync = refreshAsync
		v4.nextId = nextId
		return v4
	end, { register, deregister, v3, nextId })

	return React.createElement(WidgetsContext.Provider, { value = v4 }, p.children)
end

return WidgetsProvider
