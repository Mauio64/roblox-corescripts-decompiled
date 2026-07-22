local Parent = script:FindFirstAncestor("PurchasePrompt").Parent
local SharedFlags = require(Parent.SharedFlags)
local FFlagPromptPurchaseClearStateOnCompletion = require(script.Parent.FFlagPromptPurchaseClearStateOnCompletion)

return SharedFlags.FFlagSkipBuyDelayForExperienceShop and FFlagPromptPurchaseClearStateOnCompletion
