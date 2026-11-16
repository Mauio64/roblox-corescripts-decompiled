local BuildExperience = script:FindFirstAncestor("BuildExperience")
local Signals = require(BuildExperience.Parent.Signals)
local createAgentAdCampaignStore = require(script.createAgentAdCampaignStore)

return Signals.createComputed(createAgentAdCampaignStore)
