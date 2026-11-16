local BuildExperience = script:FindFirstAncestor("BuildExperience")
local Signals = require(BuildExperience.Parent.Signals)
local createAdsCampaignDeepLinkStore = require(script.createAdsCampaignDeepLinkStore)

return Signals.createComputed(createAdsCampaignDeepLinkStore)
