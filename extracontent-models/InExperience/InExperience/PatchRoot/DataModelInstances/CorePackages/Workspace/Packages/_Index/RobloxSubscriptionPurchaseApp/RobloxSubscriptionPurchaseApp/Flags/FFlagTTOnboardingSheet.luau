local parent = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagSubscriptionSheetCampaignLocalizations = SharedFlags.FFlagSubscriptionSheetCampaignLocalizations

return game:DefineFastFlag("TTOnboardingSheet2", false) and FFlagSubscriptionSheetCampaignLocalizations
