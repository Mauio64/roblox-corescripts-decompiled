local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)

local presenceType = dependencies.RoduxPresence.Enums.PresenceType

return {
	[presenceType.Offline] = "Common.Presence.Label.Offline",
	[presenceType.Online] = "Common.Presence.Label.Online",
	[presenceType.InGame] = "Common.Presence.Label.Online",
	[presenceType.InStudio] = "Common.Presence.Label.Online"
}
