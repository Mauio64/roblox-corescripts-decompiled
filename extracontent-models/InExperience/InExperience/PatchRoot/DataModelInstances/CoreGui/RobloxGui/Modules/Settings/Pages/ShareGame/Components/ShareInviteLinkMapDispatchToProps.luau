local CorePackages = game:GetService("CorePackages")
local NotificationsCommon = require(CorePackages.Workspace.Packages.NotificationsCommon)
local ReducerDependencies = NotificationsCommon.ReducerDependencies

local ShareLinksNetworking = ReducerDependencies.ShareLinksNetworking
local ShareLinksRodux = ReducerDependencies.ShareLinksRodux

return function(callback)
	return {
		fetchShareInviteLink = function()
			callback(ShareLinksNetworking.GenerateLink.API({
				linkType = ShareLinksRodux.Enums.LinkType.ExperienceInvite.rawValue()
			}))
		end
	}
end
