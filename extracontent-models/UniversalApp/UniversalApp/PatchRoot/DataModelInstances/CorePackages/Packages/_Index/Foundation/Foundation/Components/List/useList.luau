local Parent = script:FindFirstAncestor("Foundation").Parent
local React = require(Parent.React)
local ListContext = require(script.Parent.ListContext)

return function() -- line: 8
	-- upvalues: React (copy), ListContext (copy)
	return React.useContext(ListContext)
end
