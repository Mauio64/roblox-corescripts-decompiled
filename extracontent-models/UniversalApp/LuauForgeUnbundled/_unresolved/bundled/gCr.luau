local module = require("@luauforge/bundled/gCf")
local module2 = require("@luauforge/bundled/gCs")
local module3 = require("@luauforge/bundled/gCC")

local fFlagLuaAppGamePassesDataHydrationMigrationEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppGamePassesDataHydrationMigrationEnabled
local module4 = require("@luauforge/bundled/dSY")

return function(p2, value)
	if type(value) ~= "string" then
		error(string.format(
			"FetchExperienceStoreProducts thunk expects universeId to be a string. Got type: '%s', value: '%s'",
			type(value),
			(tostring(value))
		))
	end

	return function(object)
		if fFlagLuaAppGamePassesDataHydrationMigrationEnabled then
			module4.Game.getGamePassStore(false).fetchPassesForUniverse(value)
		else
			object:dispatch(module(p2, value))
		end

		object:dispatch(module3(p2, value))

		local state = object:getState()
		local gameDetailsV2 = state.GameDetailsV2
		local v5 = gameDetailsV2 and gameDetailsV2[value]

		if not (v5 and v5.rootPlaceId) then
			local gameDetails = state.GameDetails
			v5 = gameDetails and gameDetails[value]
		end

		if v5 and v5.rootPlaceId and state.LocalUserId then
			object:dispatch(module2(p2, value, v5.rootPlaceId, state.LocalUserId))
		end
	end
end
