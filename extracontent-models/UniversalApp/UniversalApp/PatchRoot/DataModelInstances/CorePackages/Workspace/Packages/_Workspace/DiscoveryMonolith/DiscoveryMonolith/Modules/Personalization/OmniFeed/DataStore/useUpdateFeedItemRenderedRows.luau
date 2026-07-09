local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local React = require(DiscoveryMonolithParent.React)
local useSelector = require(DiscoveryMonolithParent.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(DiscoveryMonolithParent.RoactUtils).Hooks.RoactRodux.useDispatch
local ArgCheck = require(DiscoveryMonolithParent.ArgCheck)

require(DiscoveryMonolithParent.DiscoveryTypes)

local Modules = DiscoveryMonolith.Modules
local SetFeedItemRenderedRows = require(Modules.Personalization.OmniFeed.DataStore.SetFeedItemRenderedRows)
local ClearFeedItemRenderedRows = require(Modules.Personalization.OmniFeed.DataStore.ClearFeedItemRenderedRows)

local function useUpdateFeedItemRenderedRows(p1, p2, p3, p4) -- line: 13
	-- upvalues: useDispatch (copy), useSelector (copy), React (copy), ArgCheck (copy), SetFeedItemRenderedRows (copy), ClearFeedItemRenderedRows (copy)
	local v15 = useDispatch()
	local v16 = useSelector(function(p5) -- line: 15
		-- upvalues: p1 (copy), p2 (copy), p3 (copy)
		local v18 = p5.Personalization.OrderedOmniItems[p1] or {}

		if p2 then
			v18 = v18[p2] or {}
		end

		return v18.allItems and v18.allItems[p3] or nil
	end)

	React.useEffect(function() -- line: 29
		-- upvalues: ArgCheck (copy), v16 (copy), p3 (copy), p1 (copy), p2 (copy), v15 (copy), SetFeedItemRenderedRows (copy), p4 (copy), ClearFeedItemRenderedRows (copy)
		ArgCheck.assert(v16, `Trying to update the number of rows for a feed item but could not find it.  At position: { p3 }, Page: { p1 } (optional key: { p2 })`)

		if not v16 then
			return function() -- line: 35
			end
		end

		v15(SetFeedItemRenderedRows(p1, p2, p3, v16, p4))

		return function() -- line: 40
			-- upvalues: v15 (copy), ClearFeedItemRenderedRows (copy), p1 (copy), p2 (copy), p3 (copy), v16 (copy)
			v15(ClearFeedItemRenderedRows(p1, p2, p3, v16))
		end
	end, {
		p1,
		p2,
		p3,
		v16,
		p4
	})
end

return useUpdateFeedItemRenderedRows
