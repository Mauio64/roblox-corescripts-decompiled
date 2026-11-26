local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Signals")
local createCredentialsAvailabilityStore = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Stores/GetCredentialsAvailabilityStore/createCredentialsAvailabilityStore")

return Signals.createComputed(createCredentialsAvailabilityStore)
