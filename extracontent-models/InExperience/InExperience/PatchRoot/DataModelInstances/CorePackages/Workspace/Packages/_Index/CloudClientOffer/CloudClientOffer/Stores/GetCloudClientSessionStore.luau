local parent = script:FindFirstAncestor("CloudClientOffer").Parent

local Signals = require(parent.Signals)
local createCloudClientSessionStore = require(script.createCloudClientSessionStore)

return Signals.createComputed(createCloudClientSessionStore)
