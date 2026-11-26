local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Signals")

local createAvatarsTabSearchInfoStore = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Stores/GetAvatarsTabSearchInfoStore/createAvatarsTabSearchInfoStore")

return Signals.createComputed(createAvatarsTabSearchInfoStore)
