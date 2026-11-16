local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags")

local FFlagPromptPurchaseClearStateOnCompletion = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagPromptPurchaseClearStateOnCompletion")

return SharedFlags.FFlagSkipBuyDelayForExperienceShop and FFlagPromptPurchaseClearStateOnCompletion
