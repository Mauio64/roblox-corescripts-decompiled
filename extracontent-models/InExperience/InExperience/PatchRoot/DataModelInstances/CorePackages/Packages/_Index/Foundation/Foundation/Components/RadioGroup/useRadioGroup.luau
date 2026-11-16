local parent = script:FindFirstAncestor("Foundation").Parent

local React = require(parent.React)

local RadioGroupContext = require(script.Parent.RadioGroupContext)

return function()
	return React.useContext(RadioGroupContext)
end
