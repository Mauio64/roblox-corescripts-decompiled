local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local createAgentAdCampaignStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetAgentAdCampaignStore/createAgentAdCampaignStore")

return Signals.createComputed(createAgentAdCampaignStore)
