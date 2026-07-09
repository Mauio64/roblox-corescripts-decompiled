local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local Cryo = require(DiscoveryMonolithParent.Cryo)
local Modules = DiscoveryMonolith.Modules
local SetOmniRecommendationsMetadataRequestStatus = require(Modules.LuaApp.Actions.Games.SetOmniRecommendationsMetadataRequestStatus)

return function(p1, p2) -- line: 9
	-- upvalues: SetOmniRecommendationsMetadataRequestStatus (copy), Cryo (copy)
	local v8 = p1 or {}

	if p2.type == SetOmniRecommendationsMetadataRequestStatus.name then
		local t1 = {}

		for k, v in pairs(p2.contentIds) do
			local v12 = v8[k] or {}

			t1[k] = Cryo.Dictionary.join(v12, v)
		end

		v8 = Cryo.Dictionary.join(v8, t1)
	end

	return v8
end
