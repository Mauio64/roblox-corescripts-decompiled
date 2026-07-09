local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Immutable = require(Modules.Common.Immutable)
local SetRecommendedGameEntries = require(Modules.LuaApp.Actions.Games.SetRecommendedGameEntries)

return function(t1: {[any]: any}?, p1) -- line: 11
	-- upvalues: SetRecommendedGameEntries (copy), Immutable (copy)
	local v6 = t1 or {}

	assert(v6, "")

	if p1.type == SetRecommendedGameEntries.name then
		v6 = Immutable.Set(v6, p1.universeId, p1.entries)
	end

	return v6
end
