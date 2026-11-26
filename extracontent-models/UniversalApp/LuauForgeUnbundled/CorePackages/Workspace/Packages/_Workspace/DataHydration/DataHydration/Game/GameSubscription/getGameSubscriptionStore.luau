local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createGameSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameSubscription/createGameSubscriptionStore")

return Signals.createComputed(createGameSubscriptionStore)
