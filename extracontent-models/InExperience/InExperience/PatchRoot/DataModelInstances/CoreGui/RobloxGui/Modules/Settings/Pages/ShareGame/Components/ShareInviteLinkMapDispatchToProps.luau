local CorePackages = game:GetService("CorePackages")
local ReducerDependencies = require(CorePackages.Workspace.Packages.NotificationsCommon).ReducerDependencies
local ShareLinksNetworking = ReducerDependencies.ShareLinksNetworking
local ShareLinksRodux = ReducerDependencies.ShareLinksRodux

return function(p1) -- line: 7
	-- upvalues: ShareLinksNetworking (copy), ShareLinksRodux (copy)
	return {
		fetchShareInviteLink = function() -- line: 9
			-- upvalues: p1 (copy), ShareLinksNetworking (copy), ShareLinksRodux (copy)
			p1(ShareLinksNetworking.GenerateLink.API({
				linkType = ShareLinksRodux.Enums.LinkType.ExperienceInvite.rawValue()
			}))
		end
	}
end
