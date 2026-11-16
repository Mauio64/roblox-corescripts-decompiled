local parent = script:FindFirstAncestor("PurchasePrompt").Parent
local SharedFlags = require(parent.SharedFlags)

local FFlagPromptPurchaseClearStateOnCompletion = require(script.Parent.FFlagPromptPurchaseClearStateOnCompletion)

return SharedFlags.FFlagSkipBuyDelayForExperienceShop and FFlagPromptPurchaseClearStateOnCompletion
