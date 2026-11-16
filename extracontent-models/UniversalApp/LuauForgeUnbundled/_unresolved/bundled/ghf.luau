local timeToInteractiveTracker = require("@luauforge/bundled/ghc").TimeToInteractiveTracker
local milestone = timeToInteractiveTracker.Milestone
local module = require("@luauforge/bundled/ghg")
local fFlagEnablePLTPrefetchCallbacks = module.FFlagEnablePLTPrefetchCallbacks

local module2 = require("@luauforge/bundled/ghe")

local v5 = "AvatarExperience_" .. module2.Marketplace.WidgetThumbnails .. "_Percieved"
local v6 = "AvatarExperience_" .. module2.Marketplace.WidgetTiles .. "_Percieved"

local v7 = {
	FetchHydratedWidgets = "FetchHydratedWidgets",
	FetchCatalogSearchWithSponsoredItems = "FetchCatalogSearchWithSponsoredItems",
	FetchCatalogSearch = "FetchCatalogSearch"
}

return {
	Requests = v7,
	startPerceivedTracking = function()
		timeToInteractiveTracker.trackStart(v6)
		timeToInteractiveTracker.trackStart(v5)
	end,
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

			if fFlagEnablePLTPrefetchCallbacks then
				module.signal(module.Page.AvatarMarketplace, module.Milestone.FunctionallyReady)
			end
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
		requestFetchHydratedWidgets = function()
			timeToInteractiveTracker.trackRequest(
				v5,
				milestone.PrimaryDataReady.Name,
				v7.FetchHydratedWidgets
			)
		end,
		requestFetchCatalogSearch = function()
			timeToInteractiveTracker.trackRequest(
				v5,
				milestone.PrimaryDataReady.Name,
				v7.FetchCatalogSearchWithSponsoredItems
			)
		end,
		requestFetchCatalogSearchOrganic = function()
			timeToInteractiveTracker.trackRequest(
				v5,
				milestone.PrimaryDataReady.Name,
				v7.FetchCatalogSearch
			)
		end
	}
}
