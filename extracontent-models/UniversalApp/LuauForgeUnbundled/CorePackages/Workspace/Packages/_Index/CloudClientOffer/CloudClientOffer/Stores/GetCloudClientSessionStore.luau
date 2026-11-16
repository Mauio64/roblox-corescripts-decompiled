local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/CloudClientOffer/Signals")
local createCloudClientSessionStore = require("@game/CorePackages/Workspace/Packages/_Index/CloudClientOffer/CloudClientOffer/Stores/GetCloudClientSessionStore/createCloudClientSessionStore")

return Signals.createComputed(createCloudClientSessionStore)
