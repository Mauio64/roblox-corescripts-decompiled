local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags")

return game:DefineFastFlag("FriendsPageUserListCtaEnabled", false)
	and SharedFlags.FFlagFriendsPageUserListEnabled
	and SharedFlags.FFlagUserListCtaIntegrationEnabled
	and SharedFlags.FFlagUserListComposeRenderRowWithCta
	and SharedFlags.FFlagUserListSurfacePresenceWins
	and SharedFlags.FFlagUserListDefaultCtaWidths
