local parent = script:FindFirstAncestor("ExpChat").Parent
local SharedFlags = require(parent.SharedFlags)
return SharedFlags.FFlagAllowAmpV2FeatureAccessCall and game:DefineFastFlag("ExpChatRefactorEnabledMessageLogic", false)
