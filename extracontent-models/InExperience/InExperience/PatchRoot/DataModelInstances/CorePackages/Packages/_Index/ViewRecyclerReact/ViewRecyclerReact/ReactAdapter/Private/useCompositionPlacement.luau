local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")

local CompositionPlacement = require(ViewRecyclerReact.ReactAdapter.Private.CompositionPlacement)
require(ViewRecyclerReact.Parent.ViewRecycler)
local React = require(ViewRecyclerReact.Parent.React)
require(script.Parent.RecyclingRoot)

local function useCompositionPlacement(p, maxPoolSize: number?, diagnostics)
	local v = React.useState(function()
		local scope = p.getScope({ maxPoolSize = maxPoolSize, diagnostics = diagnostics })

		return CompositionPlacement.new(scope)
	end)

	React.useLayoutEffect(function()
		return function()
			v.destroy()
		end
	end, { v })

	return v
end

return useCompositionPlacement
