local parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(parent.React)

local function ContextStack(p)
	local children = p.children

	for i = #p.providers, 1, -1 do
		local provider = p.providers[i]
		children = React.cloneElement(provider, nil, children)
	end

	return children
end

return ContextStack
