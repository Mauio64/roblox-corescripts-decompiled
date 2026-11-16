local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")
local ViewRecycler = require(ViewRecyclerReact.Parent.ViewRecycler)

local DataSource = ViewRecycler.DataSource
local React = require(ViewRecyclerReact.Parent.React)

local function useReconciledDataSource(p, p2)
	local v = React.useState(function()
		return DataSource.sequence(p, p2)
	end)

	local ref = React.useRef(nil)

	if ref.current == nil then
		ref.current = table.clone(p)
	end

	React.useLayoutEffect(function()
		DataSource.reconcileSnapshot(v, ref.current, p, p2)
		ref.current = table.clone(p)
	end, { v, p, p2 })

	return v
end

return useReconciledDataSource
