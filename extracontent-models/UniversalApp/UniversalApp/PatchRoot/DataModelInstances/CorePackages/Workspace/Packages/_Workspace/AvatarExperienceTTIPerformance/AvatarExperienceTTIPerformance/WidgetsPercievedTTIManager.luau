local Parent = script:FindFirstAncestor("AvatarExperienceTTIPerformance").Parent
local TimeToInteractiveTracker = require(Parent.TimeToInteractiveTracker).TimeToInteractiveTracker
local Milestone = TimeToInteractiveTracker.Milestone
local TTIMetricNames = require(script.Parent.TTIMetricNames)
local v5 = "AvatarExperience_" .. TTIMetricNames.Marketplace.WidgetThumbnails .. "_Percieved"
local v6 = "AvatarExperience_" .. TTIMetricNames.Marketplace.WidgetTiles .. "_Percieved"
local t1 = {
	FetchHydratedWidgets = "FetchHydratedWidgets",
	FetchCatalogSearchWithSponsoredItems = "FetchCatalogSearchWithSponsoredItems",
	FetchCatalogSearch = "FetchCatalogSearch"
}

return {
	Requests = t1,
	startPerceivedTracking = function() -- line: 25
		-- upvalues: TimeToInteractiveTracker (copy), v6 (copy), v5 (copy)
		TimeToInteractiveTracker.trackStart(v6)
		TimeToInteractiveTracker.trackStart(v5)
	end,
	Hooks = {
		useRenderAndMountedTracking = function() -- line: 31
			-- upvalues: TimeToInteractiveTracker (copy), v5 (copy)
			TimeToInteractiveTracker.Hooks.useTTIRenderAndMountedTracking(v5)
		end
	},
	L2 = {
		primaryDataStarted = function() -- line: 37
			-- upvalues: TimeToInteractiveTracker (copy), v5 (copy), Milestone (copy)
			TimeToInteractiveTracker.trackMilestone(v5, Milestone.PrimaryDataStarted.Name)
		end,
		primaryDataReady = function() -- line: 40
			-- upvalues: TimeToInteractiveTracker (copy), v5 (copy), Milestone (copy)
			TimeToInteractiveTracker.trackMilestone(v5, Milestone.PrimaryDataReady.Name)
		end,
		dataProcessingStarted = function() -- line: 43
			-- upvalues: TimeToInteractiveTracker (copy), v5 (copy), Milestone (copy)
			TimeToInteractiveTracker.trackMilestone(v5, Milestone.DataProcessingStarted.Name)
		end,
		dataProcessingCompleted = function() -- line: 46
			-- upvalues: TimeToInteractiveTracker (copy), v5 (copy), Milestone (copy)
			TimeToInteractiveTracker.trackMilestone(v5, Milestone.DataProcessingCompleted.Name)
		end,
		functionallyReady = function() -- line: 49
			-- upvalues: TimeToInteractiveTracker (copy), v5 (copy), Milestone (copy)
			TimeToInteractiveTracker.trackMilestone(v5, Milestone.FunctionallyReady)
		end,
		surfaceReady = function() -- line: 52
			-- upvalues: TimeToInteractiveTracker (copy), v5 (copy), Milestone (copy)
			TimeToInteractiveTracker.trackMilestone(v5, Milestone.SurfaceReady)
		end
	},
	L3 = {
		networkFetch = function() -- line: 58
			-- upvalues: TimeToInteractiveTracker (copy), v5 (copy), Milestone (copy)
			TimeToInteractiveTracker.trackSubphase(v5, Milestone.PrimaryDataStarted.Name, Milestone.PrimaryDataStarted.Subphase.NetworkFetch)
		end,
		responseReceived = function() -- line: 65
			-- upvalues: TimeToInteractiveTracker (copy), v5 (copy), Milestone (copy)
			TimeToInteractiveTracker.trackSubphase(v5, Milestone.PrimaryDataStarted.Name, Milestone.PrimaryDataStarted.Subphase.ResponseReceived)
		end,
		requestFetchHydratedWidgets = function() -- line: 72
			-- upvalues: TimeToInteractiveTracker (copy), v5 (copy), Milestone (copy), t1 (copy)
			TimeToInteractiveTracker.trackRequest(v5, Milestone.PrimaryDataReady.Name, t1.FetchHydratedWidgets)
		end,
		requestFetchCatalogSearch = function() -- line: 79
			-- upvalues: TimeToInteractiveTracker (copy), v5 (copy), Milestone (copy), t1 (copy)
			TimeToInteractiveTracker.trackRequest(v5, Milestone.PrimaryDataReady.Name, t1.FetchCatalogSearchWithSponsoredItems)
		end,
		requestFetchCatalogSearchOrganic = function() -- line: 86
			-- upvalues: TimeToInteractiveTracker (copy), v5 (copy), Milestone (copy), t1 (copy)
			TimeToInteractiveTracker.trackRequest(v5, Milestone.PrimaryDataReady.Name, t1.FetchCatalogSearch)
		end
	}
}
