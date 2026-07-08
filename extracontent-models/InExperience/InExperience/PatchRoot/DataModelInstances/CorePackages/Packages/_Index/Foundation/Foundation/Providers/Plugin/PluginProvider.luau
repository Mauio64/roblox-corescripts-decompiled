local Parent = script:FindFirstAncestor("Foundation").Parent
local React = require(Parent.React)
local PluginContext = require(script.Parent.PluginContext)

local function PluginProvider(t1: {[any]: any}) -- line: 13
	-- upvalues: React (copy), PluginContext (copy)
	return React.createElement(PluginContext.Provider, {
		value = t1.plugin or React.None
	}, t1.children)
end

return PluginProvider
