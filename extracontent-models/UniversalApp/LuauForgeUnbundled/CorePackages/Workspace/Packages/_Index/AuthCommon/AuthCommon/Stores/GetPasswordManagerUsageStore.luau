local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Signals")
local createPasswordManagerUsageStore = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Stores/GetPasswordManagerUsageStore/createPasswordManagerUsageStore")

return Signals.createComputed(createPasswordManagerUsageStore)
