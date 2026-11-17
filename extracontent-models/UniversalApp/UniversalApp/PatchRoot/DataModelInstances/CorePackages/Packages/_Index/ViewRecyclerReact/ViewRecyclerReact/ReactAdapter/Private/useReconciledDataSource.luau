local Flags = require(script:FindFirstAncestor("ViewRecyclerReact").Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")
local ViewRecycler = require(ViewRecyclerReact.Parent.ViewRecycler)

local DataSource = ViewRecycler.DataSource
local React = require(ViewRecyclerReact.Parent.React)

local function useReconciledDataSource(options, p)
	local v = React.useState(function()
		local sequence = DataSource.sequence
		local v

		if FFlagViewRecyclerReact084 then
			v = options or {}
		else
			v = options
		end

		return sequence(v, p)
	end)

	local ref = React.useRef(nil)

	if ref.current == nil then
		ref.current = table.clone(FFlagViewRecyclerReact084 and not options and {} or options)
	end

	React.useLayoutEffect(function()
		if FFlagViewRecyclerReact084 and (options == nil or p == nil) then
			return
		end

		DataSource.reconcileSnapshot(v, ref.current, options, p)
		ref.current = table.clone(options)
	end, { v, options, p })

	return v
end

return useReconciledDataSource
