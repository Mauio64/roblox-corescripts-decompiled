local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/TextSize/Signals")
local createTextSizeStore = require("@game/CorePackages/Workspace/Packages/_Index/TextSize/TextSize/createTextSizeStore")

return Signals.createComputed(createTextSizeStore)
