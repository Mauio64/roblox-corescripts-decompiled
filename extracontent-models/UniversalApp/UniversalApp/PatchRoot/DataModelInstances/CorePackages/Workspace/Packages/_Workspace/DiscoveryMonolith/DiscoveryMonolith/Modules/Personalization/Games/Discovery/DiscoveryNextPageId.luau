local Modules = script:FindFirstAncestor("DiscoveryMonolith").Modules
local SetDiscoveryNextPageId = require(Modules.Personalization.Games.Discovery.SetDiscoveryNextPageId)

return function(s1: string?, p1) -- line: 5
	-- upvalues: SetDiscoveryNextPageId (copy)
	local v5 = s1 or ""

	if p1.type == SetDiscoveryNextPageId.name then
		v5 = p1.nextPageId
	end

	return v5
end
