local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local createAdsCampaignDeepLinkStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetAdsCampaignDeepLinkStore/createAdsCampaignDeepLinkStore")

return Signals.createComputed(createAdsCampaignDeepLinkStore)
