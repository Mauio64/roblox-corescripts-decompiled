local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)

return dependencies.enumerate(script.Name, { Home = "Home", More = "More", SocialTab = "SocialTab" })
