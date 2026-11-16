local parent = script:FindFirstAncestor("Foundation").Parent
local React = require(parent.React)

local PluginContext = require(script.Parent.PluginContext)

local function PluginProvider(p)
	return React.createElement(PluginContext.Provider, {
		value = p.plugin or React.None
	}, p.children)
end

return PluginProvider
