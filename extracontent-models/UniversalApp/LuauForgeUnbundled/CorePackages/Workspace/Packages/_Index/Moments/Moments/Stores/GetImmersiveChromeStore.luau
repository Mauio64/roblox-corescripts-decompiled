local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")

local createImmersiveChromeStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetImmersiveChromeStore/createImmersiveChromeStore")

return Signals.createComputed(createImmersiveChromeStore)
