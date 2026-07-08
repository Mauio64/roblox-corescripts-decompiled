local Parent = script:FindFirstAncestor("Foundation").Parent
local React = require(Parent.React)
local RadioGroupContext = require(script.Parent.RadioGroupContext)

return function() -- line: 15
	-- upvalues: React (copy), RadioGroupContext (copy)
	return React.useContext(RadioGroupContext)
end
