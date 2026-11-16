local timeToInteractiveTracker = require("@luauforge/bundled/ghc").TimeToInteractiveTracker
local milestone = timeToInteractiveTracker.Milestone

local v5 = "AvatarExperience_" .. require("@luauforge/bundled/ghe").Marketplace.OrganicThumbnails

local v6 = {
	SponsoredSearchStarted = "SponsoredSearchStarted",
	SponsoredSearchCompleted = "SponsoredSearchCompleted",
	CatalogApiSearchStarted = "CatalogApiSearchStarted",
	CatalogApiSearchCompleted = "CatalogApiSearchCompleted"
}

return {
	CustomSubphases = v6,
	Hooks = {
		useRenderAndMountedTracking = function()
			timeToInteractiveTracker.Hooks.useTTIRenderAndMountedTracking(v5)
		end
	},
	L2 = {
		primaryDataStarted = function()
			timeToInteractiveTracker.trackMilestone(v5, milestone.PrimaryDataStarted.Name)
		end,
		primaryDataReady = function()
			timeToInteractiveTracker.trackMilestone(v5, milestone.PrimaryDataReady.Name)
		end,
		dataProcessingStarted = function()
			timeToInteractiveTracker.trackMilestone(v5, milestone.DataProcessingStarted.Name)
		end,
		dataProcessingCompleted = function()
			timeToInteractiveTracker.trackMilestone(v5, milestone.DataProcessingCompleted.Name)
		end,
		functionallyReady = function()
			timeToInteractiveTracker.trackMilestone(v5, milestone.FunctionallyReady)
		end,
		surfaceReady = function()
			timeToInteractiveTracker.trackMilestone(v5, milestone.SurfaceReady)
		end
	},
	L3 = {
		networkFetch = function()
			timeToInteractiveTracker.trackSubphase(
				v5,
				milestone.PrimaryDataStarted.Name,
				milestone.PrimaryDataStarted.Subphase.NetworkFetch
			)
		end,
		responseReceived = function()
			timeToInteractiveTracker.trackSubphase(
				v5,
				milestone.PrimaryDataStarted.Name,
				milestone.PrimaryDataStarted.Subphase.ResponseReceived
			)
		end,
		sponsoredSearchStarted = function()
			timeToInteractiveTracker.trackSubphase(
				v5,
				milestone.PrimaryDataStarted.Name,
				v6.SponsoredSearchStarted
			)
		end,
		sponsoredSearchCompleted = function()
			timeToInteractiveTracker.trackSubphase(
				v5,
				milestone.PrimaryDataStarted.Name,
				v6.SponsoredSearchCompleted
			)
		end,
		catalogApiSearchStarted = function()
			timeToInteractiveTracker.trackSubphase(
				v5,
				milestone.PrimaryDataStarted.Name,
				v6.CatalogApiSearchStarted
			)
		end,
		catalogApiSearchCompleted = function()
			timeToInteractiveTracker.trackSubphase(
				v5,
				milestone.PrimaryDataStarted.Name,
				v6.CatalogApiSearchCompleted
			)
		end
	}
}
