local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/SharedFlags")
local FFlagGameInviteInExpUserListRenderer = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Flags/FFlagGameInviteInExpUserListRenderer")

return SharedFlags.FFlagGameInviteInExpJoinCta3
	and FFlagGameInviteInExpUserListRenderer
	and SharedFlags.FFlagUserListCtaIntegrationEnabled
	and SharedFlags.FFlagUserListComposeRenderRowWithCta
	and SharedFlags.FFlagGameJoinCardOptionalActions
