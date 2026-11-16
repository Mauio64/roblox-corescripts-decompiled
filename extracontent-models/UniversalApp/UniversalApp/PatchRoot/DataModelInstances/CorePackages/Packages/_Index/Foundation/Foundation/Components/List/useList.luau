local parent = script:FindFirstAncestor("Foundation").Parent

local React = require(parent.React)

local ListContext = require(script.Parent.ListContext)

return function()
	return React.useContext(ListContext)
end
