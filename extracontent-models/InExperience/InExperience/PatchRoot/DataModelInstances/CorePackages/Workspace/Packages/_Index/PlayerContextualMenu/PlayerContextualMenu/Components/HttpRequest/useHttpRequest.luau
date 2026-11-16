local parent = script:FindFirstAncestor("PlayerContextualMenu").Parent
local React = require(parent.React)

local HttpRequestContext = require(script.Parent.HttpRequestContext)

return function()
	return React.useContext(HttpRequestContext)
end
