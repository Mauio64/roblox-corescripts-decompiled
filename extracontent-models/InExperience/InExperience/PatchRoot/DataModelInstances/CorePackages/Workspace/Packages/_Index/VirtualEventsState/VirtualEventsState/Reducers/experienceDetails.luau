local VirtualEventsState = script:FindFirstAncestor("VirtualEventsState")

local network = require(VirtualEventsState.network)
local networkingGames = network.NetworkingGames
local experienceDetailsimpl = require(script.Parent["experienceDetails.impl"])

return experienceDetailsimpl(networkingGames)
