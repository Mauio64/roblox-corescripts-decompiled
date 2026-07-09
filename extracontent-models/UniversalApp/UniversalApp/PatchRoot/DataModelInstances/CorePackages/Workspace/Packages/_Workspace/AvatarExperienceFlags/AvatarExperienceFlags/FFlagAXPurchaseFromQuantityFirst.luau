local Parent = script:FindFirstAncestor("AvatarExperienceFlags").Parent

return require(Parent.SharedFlags).FFlagEnableInspectAndBuyV2RootFlag and game:DefineFastFlag("AXPurchaseFromQuantityFirst", false)
