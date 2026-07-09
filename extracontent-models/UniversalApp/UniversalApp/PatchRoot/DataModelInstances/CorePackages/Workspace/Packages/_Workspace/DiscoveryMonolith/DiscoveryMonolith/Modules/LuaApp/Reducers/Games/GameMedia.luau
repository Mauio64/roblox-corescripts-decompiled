local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local Immutable = require(DiscoveryMonolithParent.AppCommonLib).Immutable
local Modules = DiscoveryMonolith.Modules
local UpdateGameMedia = require(Modules.LuaApp.Actions.Games.UpdateGameMedia)

return function(t1: {[any]: any}?, p1) -- line: 12
	-- upvalues: UpdateGameMedia (copy), Immutable (copy)
	local v8 = t1 or {}

	assert(v8, "")

	if p1.type == UpdateGameMedia.name then
		v8 = Immutable.Set(v8, p1.universeId, p1.entries)
	end

	return v8
end
