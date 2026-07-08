local Parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(Parent.React)

local function ContextStack(t1: {[any]: any}) -- line: 12
	-- upvalues: React (copy)
	local children = t1.children

	for i = #t1.providers, 1, -1 do
		local v7 = t1.providers[i]

		children = React.cloneElement(v7, nil, children)
	end

	return children
end

return ContextStack
