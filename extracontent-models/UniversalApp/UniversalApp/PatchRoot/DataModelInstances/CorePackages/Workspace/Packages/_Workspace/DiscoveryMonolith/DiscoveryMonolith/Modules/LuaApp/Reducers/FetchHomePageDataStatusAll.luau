local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local RetrievalStatus = require(DiscoveryMonolithParent.Http).Enum.RetrievalStatus
local Modules = DiscoveryMonolith.Modules
local SetFetchHomePageDataStatusAll = require(Modules.LuaApp.Actions.SetFetchHomePageDataStatusAll)

return function(p1, p2) -- line: 8
	-- upvalues: RetrievalStatus (copy), SetFetchHomePageDataStatusAll (copy)
	local v8 = p1 or RetrievalStatus.NotStarted

	if p2.type == SetFetchHomePageDataStatusAll.name then
		v8 = p2.status
	end

	return v8
end
