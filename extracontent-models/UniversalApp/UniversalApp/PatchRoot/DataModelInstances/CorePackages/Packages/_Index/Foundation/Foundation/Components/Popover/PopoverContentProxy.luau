local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Content = require(script.Parent.Content)
local ContentPlugin = require(script.Parent.ContentPlugin)
local isPluginSecurity = require(Foundation.Utility.isPluginSecurity)
local usePlugin = require(Foundation.Providers.Plugin.usePlugin)

local function PopoverContentProxy(p, ref)
	local _, v = usePlugin()

	if ref then
		p = table.clone(p)
		p.ref = ref
	end

	if isPluginSecurity() and v then
		return React.createElement(ContentPlugin, p)
	end

	return React.createElement(Content, p)
end

return React.forwardRef(PopoverContentProxy)
