local VirtualEventsState = script:FindFirstAncestor("VirtualEventsState")
local NetworkingGames = require(VirtualEventsState.network).NetworkingGames

return require(script.Parent["experienceDetails.impl"])(NetworkingGames)
