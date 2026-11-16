local parent = script:FindFirstAncestor("PurchasePrompt").Parent

local SharedFlags = require(parent.SharedFlags)
return SharedFlags.FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell
