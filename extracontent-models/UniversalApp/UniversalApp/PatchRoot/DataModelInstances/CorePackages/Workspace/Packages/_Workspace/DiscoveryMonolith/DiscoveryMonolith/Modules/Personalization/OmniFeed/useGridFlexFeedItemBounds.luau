local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local React = require(DiscoveryMonolithParent.React)
local RoactUtils = require(DiscoveryMonolithParent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Modules = DiscoveryMonolith.Modules
local SetGameGridFlexFeedItemInput = require(Modules.Personalization.OmniFeed.DataStore.SetGameGridFlexFeedItemInput)
local ClearGameGridFlexFeedItemBounds = require(Modules.Personalization.OmniFeed.DataStore.ClearGameGridFlexFeedItemBounds)

local function useGridFlexFeedItemBounds(s1: string, n1: number, n2: number, n3: number, t1: {[any]: any}) -- line: 20
	-- upvalues: useDispatch (copy), useSelector (copy), React (copy), SetGameGridFlexFeedItemInput (copy), ClearGameGridFlexFeedItemBounds (copy)
	local v16 = useDispatch()
	local v17 = useSelector(function(p1) -- line: 29
		-- upvalues: s1 (copy), n1 (copy)
		return ((p1.Personalization.GameGridFlexFeedItemBounds[s1] or {}).flexItemsBounds or {})[n1]
	end)

	React.useEffect(function() -- line: 36
		-- upvalues: n2 (copy), v16 (copy), SetGameGridFlexFeedItemInput (copy), s1 (copy), n1 (copy), n3 (copy), t1 (copy), ClearGameGridFlexFeedItemBounds (copy)
		if n2 and n2 > 0 then
			v16(SetGameGridFlexFeedItemInput(s1, n1, n3, n2, t1))
		end

		return function() -- line: 41
			-- upvalues: n2 (copy), v16 (copy), ClearGameGridFlexFeedItemBounds (copy), s1 (copy), n1 (copy), t1 (copy)
			if n2 and n2 > 0 then
				v16(ClearGameGridFlexFeedItemBounds(s1, n1, n2, t1))
			end
		end
	end, {
		s1,
		n1,
		n2,
		n3,
		t1
	})

	return v17
end

return useGridFlexFeedItemBounds
