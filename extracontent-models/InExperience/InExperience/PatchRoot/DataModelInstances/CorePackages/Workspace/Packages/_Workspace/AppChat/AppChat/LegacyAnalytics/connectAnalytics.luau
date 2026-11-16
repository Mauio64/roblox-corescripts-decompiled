local AppChat = script:FindFirstAncestor("AppChat")

local AnalyticsContext = require(script.Parent.AnalyticsContext)

local SocialLibraries = require(AppChat.SocialLibraries)
return SocialLibraries.Context.getConnect(AnalyticsContext)
