local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createCommunityUserMembershipStore = require(script.Parent.createCommunityUserMembershipStore)

return Signals.createComputed(createCommunityUserMembershipStore)
