local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppTopBanner/Signals")

local createAppTopBannerStore = require("@game/CorePackages/Workspace/Packages/_Index/AppTopBanner/AppTopBanner/Stores/GetAppTopBannerStore/createAppTopBannerStore")

return Signals.createComputed(createAppTopBannerStore)
