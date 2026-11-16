local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Signals = require(parent.Signals)

local createMyCreationsFilterStore = require(BuildExperience.Stores.GetMyCreationsFilterStore.createMyCreationsFilterStore)
local GamesFilter = require(BuildExperience.Stores.GetMyCreationsFilterStore.GamesFilter)

return Signals.createComputed(function()
	local myCreationsFilterStore = createMyCreationsFilterStore()
	myCreationsFilterStore.setFilter({ games = GamesFilter.SharedGames })
	return myCreationsFilterStore
end)
