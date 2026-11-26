local shareGameAnalytics = require("@luauforge/deferred/gGN").SocialLibraries.Analytics.ShareGameAnalytics

return function(p2, p3)
	return (shareGameAnalytics.new(p2, p3, shareGameAnalytics.ButtonName.LuaGameDetails))
end
