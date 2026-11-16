local parent = script:FindFirstAncestor("AvatarExperienceFlags").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagUnifiedPurchaseOptimizeTTIMarketplace = SharedFlags.FFlagUnifiedPurchaseOptimizeTTIMarketplace

return game:DefineFastFlag("UnifiedPurchaseOptimizeTTIMarketplaceIntegration", false)
	and FFlagUnifiedPurchaseOptimizeTTIMarketplace
