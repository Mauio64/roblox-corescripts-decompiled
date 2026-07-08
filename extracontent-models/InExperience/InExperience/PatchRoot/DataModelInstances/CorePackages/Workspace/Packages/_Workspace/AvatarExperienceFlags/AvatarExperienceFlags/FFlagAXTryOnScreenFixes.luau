local Parent = script:FindFirstAncestor("AvatarExperienceFlags").Parent

return require(Parent.SharedFlags).FFlagAXTryOnScreenImprovements and game:DefineFastFlag("AXTryOnScreenFixes", false)
