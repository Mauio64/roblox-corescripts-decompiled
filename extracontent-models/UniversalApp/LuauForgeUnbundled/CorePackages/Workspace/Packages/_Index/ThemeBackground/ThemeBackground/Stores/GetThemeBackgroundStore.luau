local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ThemeBackground/Signals")

local createThemeBackgroundStore = require("@game/CorePackages/Workspace/Packages/_Index/ThemeBackground/ThemeBackground/Stores/GetThemeBackgroundStore/createThemeBackgroundStore")

return Signals.createComputed(createThemeBackgroundStore)
