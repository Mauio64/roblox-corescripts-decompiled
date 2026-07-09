local Parent = script:FindFirstAncestor("PurchasePrompt").Parent
local FFlagBlackbirdUpsellVersion = require(Parent.SharedFlags).FFlagBlackbirdUpsellVersion

return game:DefineFastFlag("EnablePromptRobloxSubscriptionPurchaseBinding2", false) and (FFlagBlackbirdUpsellVersion and game:GetEngineFeature("EnablePromptRobloxSubscriptionPurchase"))
