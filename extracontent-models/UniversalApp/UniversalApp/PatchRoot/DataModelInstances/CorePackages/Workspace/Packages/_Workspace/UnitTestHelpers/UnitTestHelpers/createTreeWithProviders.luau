local ParentParent = script.Parent.Parent
local React = require(ParentParent.Dev.React)
local foldProviders = require(script.Parent.foldProviders)

return function(p1, t1: {[any]: any}?) -- line: 14
	-- upvalues: React (copy), foldProviders (copy)
	local v6 = t1 or {}

	assert(v6, "Config must not be nil")

	local v7 = React.createElement(p1, v6.props)

	return foldProviders(v7, v6.providers or {})
end
