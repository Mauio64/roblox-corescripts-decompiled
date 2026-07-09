local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(t1: {[any]: any}?) -- line: 12
	return {
		subscriptionProductsThumbnails = t1
	}
end)
