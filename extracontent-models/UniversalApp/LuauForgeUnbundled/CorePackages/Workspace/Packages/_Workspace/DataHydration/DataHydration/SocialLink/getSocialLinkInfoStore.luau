local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createSocialLinkInfoStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/SocialLink/createSocialLinkInfoStore")

return Signals.createComputed(createSocialLinkInfoStore)
