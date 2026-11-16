local parent = script:FindFirstAncestor("GameInvite").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagGameInviteInExpUserListRenderer = require(script.Parent.FFlagGameInviteInExpUserListRenderer)

return SharedFlags.FFlagGameInviteInExpJoinCta3
	and FFlagGameInviteInExpUserListRenderer
	and SharedFlags.FFlagUserListCtaIntegrationEnabled
	and SharedFlags.FFlagUserListComposeRenderRowWithCta
	and SharedFlags.FFlagGameJoinCardOptionalActions
