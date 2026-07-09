local Parent = script:FindFirstAncestor("AvatarExperienceFlags").Parent

return require(Parent.SharedFlags).FFlagEnableUnifiedProductPurchaseFlow and game:DefineFastFlag("AXEnableUnifiedProductPurchaseForMarketplace2", false)
