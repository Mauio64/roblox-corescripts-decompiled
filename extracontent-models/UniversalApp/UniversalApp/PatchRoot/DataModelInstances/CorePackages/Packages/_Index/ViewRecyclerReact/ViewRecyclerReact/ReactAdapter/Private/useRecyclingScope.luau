local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")
local React = require(ViewRecyclerReact.Parent.React)
local RecyclingScopeContext = require(script.Parent.RecyclingScopeContext)

local function useRecyclingScope(p: string)
	local v = React.useContext(RecyclingScopeContext)
	assert(v ~= nil, `{p} requires a RecyclingScope`)
	local v2 = React.useState(function()
		return v.getScope()
	end)

	React.useEffect(function()
		return v.registerConsumer()
	end, { v })
	return v2
end

return useRecyclingScope
