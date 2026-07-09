local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local Immutable = require(DiscoveryMonolithParent.AppCommonLib).Immutable
local Modules = DiscoveryMonolith.Modules
local SetSearchInGamesStatus = require(Modules.LuaApp.Actions.SetSearchInGamesStatus)

return function(t1: {[any]: any}?, p1) -- line: 12
	-- upvalues: SetSearchInGamesStatus (copy), Immutable (copy)
	local v8 = t1 or {}

	assert(v8, "")

	if p1.type == SetSearchInGamesStatus.name then
		v8 = Immutable.Set(v8, p1.searchUuid, p1.status)
	end

	return v8
end
