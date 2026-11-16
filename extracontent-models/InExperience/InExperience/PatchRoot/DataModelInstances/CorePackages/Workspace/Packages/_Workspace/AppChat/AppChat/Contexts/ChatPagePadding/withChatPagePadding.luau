local parent = script:FindFirstAncestor("AppChat").Parent

local Roact = require(parent.Roact)
local Context = require(script.Parent.Context)

return function(render)
	assert(type(render) == "function", "Expect renderCallback to be a function.")
	return Roact.createElement(Context.Consumer, { render = render })
end
