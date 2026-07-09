local Parent = script:FindFirstAncestor("ExpChat").Parent

return require(Parent.SharedFlags).FFlagAllowAmpV2FeatureAccessCall and game:DefineFastFlag("ExpChatRefactorEnabledMessageLogic", false)
