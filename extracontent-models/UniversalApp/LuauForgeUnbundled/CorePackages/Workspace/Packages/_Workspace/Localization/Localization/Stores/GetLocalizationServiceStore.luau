local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Localization/Signals")
local createLocalizationServiceStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Localization/Localization/Stores/GetLocalizationServiceStore/createLocalizationServiceStore")

return Signals.createComputed(createLocalizationServiceStore)
