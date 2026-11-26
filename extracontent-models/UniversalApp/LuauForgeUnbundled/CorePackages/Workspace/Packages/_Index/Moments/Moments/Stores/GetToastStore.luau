local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local createToastStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetToastStore/createToastStore")

return Signals.createComputed(createToastStore)
