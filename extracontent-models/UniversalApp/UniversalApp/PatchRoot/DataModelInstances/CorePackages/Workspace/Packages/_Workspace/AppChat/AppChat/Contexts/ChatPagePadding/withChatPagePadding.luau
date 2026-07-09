local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local Context = require(script.Parent.Context)

return function(p1: ((...any) -> ...any)) -- line: 13
	-- upvalues: Roact (copy), Context (copy)
	assert(type(p1) == "function", "Expect renderCallback to be a function.")

	return Roact.createElement(Context.Consumer, {
		render = p1
	})
end
