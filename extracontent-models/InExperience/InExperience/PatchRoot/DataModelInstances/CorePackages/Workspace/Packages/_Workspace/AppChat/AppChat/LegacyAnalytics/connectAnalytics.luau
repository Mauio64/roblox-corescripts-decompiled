local AppChat = script:FindFirstAncestor("AppChat")
local AnalyticsContext = require(script.Parent.AnalyticsContext)

return require(AppChat.SocialLibraries).Context.getConnect(AnalyticsContext)
