local CorePackages = game:GetService("CorePackages")

task.spawn(function()
	local prefetchOffersOnGameJoin = require(CorePackages.Workspace.Packages.InExperienceOffers.prefetchOffersOnGameJoin)
	prefetchOffersOnGameJoin()
end)

return true
