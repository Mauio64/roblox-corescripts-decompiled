local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Rodux = require(CorePackages.Packages.Rodux)
local Modules = CoreGui.RobloxGui.Modules

require(Modules.AvatarExperience.Common.Types)

return Rodux.makeActionCreator(script.Name, function(s1: string, n1: number, n2: number, t1: {[any]: any}, t2: {[any]: any}?, p1, n3: number?, p2, s2: string?, p3, s3: string?, p4, n4: number?, b1: boolean?, t3: {[any]: any}?) -- line: 33
	return {
		lookAssetInfos = t1,
		lookBundleInfos = t2,
		lookId = s1,
		lookType = p1,
		totalValue = n3,
		totalPrice = n1,
		totalPremiumPrice = n2,
		curator = p2,
		description = s2,
		moderationStatus = p3,
		name = s3,
		displayProperties = p4,
		favoriteCount = n4,
		isFavorited = b1,
		lookDiscounts = t3
	}
end)
