local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local RetrievalStatus = require(DiscoveryMonolithParent.Http).Enum.RetrievalStatus
local Modules = DiscoveryMonolith.Modules
local SetHomePageDataStatus = require(Modules.LuaApp.Actions.SetHomePageDataStatus)

return function(p1, p2) -- line: 8
	-- upvalues: RetrievalStatus (copy), SetHomePageDataStatus (copy)
	local v8 = p1 or RetrievalStatus.NotStarted

	if p2.type == SetHomePageDataStatus.name then
		v8 = p2.status
	end

	return v8
end
