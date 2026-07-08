local Parent = script:FindFirstAncestor("SponsoredAdViewability").Parent
local React = require(Parent.React)

require(Parent.DiscoveryTypes)

local sponsoredAdViewabilityRegistry = require(script.Parent.sponsoredAdViewabilityRegistry)

local function useTagAsSponsoredAdViewabilityCandidate(t1: {[any]: any}, p1) -- line: 13
	-- upvalues: React (copy), sponsoredAdViewabilityRegistry (copy)
	local v7 = if not p1 then nil else p1.encryptedAdTrackingData
	local v8 = if not p1 then nil else p1.tileType

	React.useEffect(function() -- line: 17
		-- upvalues: v7 (copy), v8 (copy), t1 (copy), sponsoredAdViewabilityRegistry (copy)
		if v7 == nil or v8 == nil then
			return
		end

		local current = t1.current

		if current == nil then
			return
		end

		return sponsoredAdViewabilityRegistry.bind(current, {
			encryptedAdTrackingData = v7,
			tileType = v8
		})
	end, {
		v7,
		v8,
		t1
	})
end

return useTagAsSponsoredAdViewabilityCandidate
