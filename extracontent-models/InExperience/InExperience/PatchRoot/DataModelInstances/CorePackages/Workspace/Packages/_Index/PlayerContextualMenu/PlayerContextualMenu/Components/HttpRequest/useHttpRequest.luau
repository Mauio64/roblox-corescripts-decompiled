local Parent = script:FindFirstAncestor("PlayerContextualMenu").Parent
local React = require(Parent.React)
local HttpRequestContext = require(script.Parent.HttpRequestContext)

return function() -- line: 7
	-- upvalues: React (copy), HttpRequestContext (copy)
	return React.useContext(HttpRequestContext)
end
