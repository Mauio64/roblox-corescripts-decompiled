local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local createMomentsShellStackStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsShellStackStore/createMomentsShellStackStore")

return Signals.createComputed(createMomentsShellStackStore)
