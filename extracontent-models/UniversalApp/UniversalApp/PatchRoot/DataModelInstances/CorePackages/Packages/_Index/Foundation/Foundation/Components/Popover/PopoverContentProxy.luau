local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Content = require(script.Parent.Content)
local ContentPlugin = require(script.Parent.ContentPlugin)
local isPluginSecurity = require(Foundation.Utility.isPluginSecurity)
local usePlugin = require(Foundation.Providers.Plugin.usePlugin)

local function PopoverContentProxy(p1, p2) -- line: 13
	-- upvalues: usePlugin (copy), isPluginSecurity (copy), React (copy), ContentPlugin (copy), Content (copy)
	local _, v12 = usePlugin()

	if p2 then
		p1 = table.clone(p1)
		p1.ref = p2
	end

	if isPluginSecurity() and v12 then
		return React.createElement(ContentPlugin, p1)
	end

	return React.createElement(Content, p1)
end

return React.forwardRef(PopoverContentProxy)
