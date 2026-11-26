local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createCommunityUserMembershipStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CommunityUserMembership/createCommunityUserMembershipStore")

return Signals.createComputed(createCommunityUserMembershipStore)
