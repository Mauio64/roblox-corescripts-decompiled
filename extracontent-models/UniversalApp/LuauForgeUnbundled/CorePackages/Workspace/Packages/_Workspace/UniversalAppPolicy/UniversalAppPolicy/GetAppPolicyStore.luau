local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/Signals")

local createAppPolicyStore = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/UniversalAppPolicy/GetAppPolicyStore/createAppPolicyStore")

return Signals.createComputed(createAppPolicyStore)
