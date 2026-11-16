local VirtualEventsState = script:FindFirstAncestor("VirtualEventsState")

local network = require(VirtualEventsState.network)
local networkingGames = network.NetworkingGames
local mediaimpl = require(script.Parent["media.impl"])

return mediaimpl(networkingGames)
