local parent = script:FindFirstAncestor("FriendsLanding").Parent

local SharedFlags = require(parent.SharedFlags)

return game:DefineFastFlag("FriendsPageUserListCtaEnabled", false)
	and SharedFlags.FFlagFriendsPageUserListEnabled
	and SharedFlags.FFlagUserListCtaIntegrationEnabled
	and SharedFlags.FFlagUserListSurfacePresenceWins
	and SharedFlags.FFlagUserListDefaultCtaWidths
