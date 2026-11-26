local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")

local createMyCreationsFilterStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetMyCreationsFilterStore/createMyCreationsFilterStore")
local GamesFilter = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetMyCreationsFilterStore/GamesFilter")

return Signals.createComputed(function()
	local v5 = createMyCreationsFilterStore()
	v5.setFilter({ games = GamesFilter.SharedGames })
	return v5
end)
