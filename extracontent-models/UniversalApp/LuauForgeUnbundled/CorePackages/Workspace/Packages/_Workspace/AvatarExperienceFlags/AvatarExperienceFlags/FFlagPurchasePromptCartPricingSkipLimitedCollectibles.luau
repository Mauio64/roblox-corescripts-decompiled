local fFlagMarketplaceOffersOptOutRoot = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceFlags/SharedFlags").FFlagMarketplaceOffersOptOutRoot

return game:DefineFastFlag("PurchasePromptCartPricingSkipLimitedCollectibles2", false)
	and fFlagMarketplaceOffersOptOutRoot
