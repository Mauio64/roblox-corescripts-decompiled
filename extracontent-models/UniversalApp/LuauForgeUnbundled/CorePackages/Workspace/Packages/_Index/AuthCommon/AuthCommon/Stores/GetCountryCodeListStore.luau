local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Signals")
local createCountryCodeListStore = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Stores/GetCountryCodeListStore/createCountryCodeListStore")

return Signals.createComputed(createCountryCodeListStore)
