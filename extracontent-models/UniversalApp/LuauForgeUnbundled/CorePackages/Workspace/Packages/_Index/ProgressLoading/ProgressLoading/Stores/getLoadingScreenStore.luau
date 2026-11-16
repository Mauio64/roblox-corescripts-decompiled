local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Signals")

local createLoadingScreenStore = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Stores/createLoadingScreenStore")

return Signals.createComputed(createLoadingScreenStore)
