local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local Cryo = require(DiscoveryMonolithParent.Cryo)

require(DiscoveryMonolithParent.DiscoveryTypes)

local Modules = DiscoveryMonolith.Modules
local SetPageSessionTimestamp = require(Modules.Personalization.Sessions.DataStore.SetPageSessionTimestamp)

return function(p1, p2) -- line: 10
	-- upvalues: SetPageSessionTimestamp (copy), Cryo (copy)
	local v8 = p1 or {}

	if p2.type == SetPageSessionTimestamp.name then
		v8 = Cryo.Dictionary.join(v8, {
			[p2.page] = p2.timestamp
		})
	end

	return v8
end
