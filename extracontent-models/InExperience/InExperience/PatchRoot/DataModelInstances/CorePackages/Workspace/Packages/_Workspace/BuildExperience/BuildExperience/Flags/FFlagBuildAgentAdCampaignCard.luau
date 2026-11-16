local parent = script:FindFirstAncestor("BuildExperience").Parent
local FFlagEnablePaidAds = require(script.Parent.FFlagEnablePaidAds)
local SharedFlags = require(parent.SharedFlags)
return SharedFlags.FFlagBuildAgentAdCampaignCard and FFlagEnablePaidAds
