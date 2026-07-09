local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(s1: string, t1: {[any]: any}, t2: {[any]: any}?, b1: boolean?) -- line: 18
	return {
		lookId = s1,
		purchasedAssetIds = t1,
		purchasedBundleIds = t2,
		isOwnedAfterPurchase = b1
	}
end)
