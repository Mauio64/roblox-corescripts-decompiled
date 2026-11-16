local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)

return dependencies.enumerate(script.Name, {
	StudioPresenceTextGlobal = "Roblox Studio",
	StudioPresenceTextLuobu = "LuoBu Studio"
})
