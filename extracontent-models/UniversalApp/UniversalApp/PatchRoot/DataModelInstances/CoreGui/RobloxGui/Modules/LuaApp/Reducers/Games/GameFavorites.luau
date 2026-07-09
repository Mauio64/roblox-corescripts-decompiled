local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Immutable = require(Modules.Common.Immutable)
local SetGameFavorite = require(Modules.LuaApp.Actions.Games.SetGameFavorite)

return function(t1: {[any]: any}?, p1) -- line: 9
	-- upvalues: SetGameFavorite (copy), Immutable (copy)
	local v6 = t1 or {}

	assert(v6, "")

	if p1.type == SetGameFavorite.name then
		v6 = Immutable.Set(v6, p1.universeId, p1.isFavorited)
	end

	return v6
end
