local CorePackages = game:GetService("CorePackages")
local NotificationsCommon = require(CorePackages.Workspace.Packages.NotificationsCommon)
local ReducerDependencies = NotificationsCommon.ReducerDependencies

local ShareLinksNetworking = ReducerDependencies.ShareLinksNetworking
local ShareLinksRodux = ReducerDependencies.ShareLinksRodux

return function(p)
	return {
		shareInviteLink = p.ShareLinks.Invites.ShareInviteLink,
		fetchShareInviteLinkNetworkStatus = ShareLinksNetworking.GenerateLink.getStatus(p, {
			linkType = ShareLinksRodux.Enums.LinkType.ExperienceInvite.rawValue()
		})
	}
end
