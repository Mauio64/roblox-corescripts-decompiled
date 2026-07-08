local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 5
	return {
		newParticipants = t1
	}
end)
