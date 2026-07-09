local ShareTargetGame = script:FindFirstAncestor("ShareTargetGame")
local ShareGameAnalytics = require(ShareTargetGame.dependencies).SocialLibraries.Analytics.ShareGameAnalytics

return function(p1, p2) -- line: 6
	-- upvalues: ShareGameAnalytics (copy)
	return (ShareGameAnalytics.new(p1, p2, ShareGameAnalytics.ButtonName.LuaGameDetails))
end
