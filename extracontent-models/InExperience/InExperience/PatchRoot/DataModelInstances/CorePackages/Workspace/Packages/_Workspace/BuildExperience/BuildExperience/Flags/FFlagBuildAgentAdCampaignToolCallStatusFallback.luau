local FFlagBuildAgentAdCampaignCard = require(script.Parent.FFlagBuildAgentAdCampaignCard)

local parent = script:FindFirstAncestor("BuildExperience").Parent

local SharedFlags = require(parent.SharedFlags)
return SharedFlags.FFlagBuildAgentAdCampaignToolCallStatusFallback and FFlagBuildAgentAdCampaignCard
