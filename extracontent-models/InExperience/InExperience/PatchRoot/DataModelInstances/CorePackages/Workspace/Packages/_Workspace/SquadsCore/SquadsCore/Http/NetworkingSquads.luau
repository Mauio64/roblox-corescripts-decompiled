local parent = script:FindFirstAncestor("SquadsCore").Parent

local RoduxNetworking = require(script.Parent.RoduxNetworking)

local NetworkingSquads = require(parent.NetworkingSquads)
return NetworkingSquads.config({ roduxNetworking = RoduxNetworking })
