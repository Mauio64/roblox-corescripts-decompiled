local fFlagMarketplaceOffersOptOutRoot = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceFlags/SharedFlags").FFlagMarketplaceOffersOptOutRoot

return game:DefineFastFlag("PurchasePromptCartPricingSkipFreeItems2", false)
	and fFlagMarketplaceOffersOptOutRoot
