local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Signals")

local createCatalogPageRequestIdStore = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Stores/GetCatalogPageRequestIdStore/createCatalogPageRequestIdStore")

return Signals.createComputed(createCatalogPageRequestIdStore)
