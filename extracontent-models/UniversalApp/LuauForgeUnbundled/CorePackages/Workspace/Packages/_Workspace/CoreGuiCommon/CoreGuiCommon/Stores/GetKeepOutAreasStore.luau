local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/Signals")
local createKeepOutAreasStore = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/CoreGuiCommon/Stores/GetKeepOutAreasStore/createKeepOutAreasStore")

return Signals.createComputed(createKeepOutAreasStore)
