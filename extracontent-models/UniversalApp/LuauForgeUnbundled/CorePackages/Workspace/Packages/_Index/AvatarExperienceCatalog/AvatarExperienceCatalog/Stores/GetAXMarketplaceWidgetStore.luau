local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Signals")

local createAXMarketplaceWidgetStore = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Stores/GetAXMarketplaceWidgetStore/createAXMarketplaceWidgetStore")

return Signals.createComputed(createAXMarketplaceWidgetStore)
