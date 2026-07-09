local Parent = script:FindFirstAncestor("AvatarExperienceTTIPerformance").Parent
local TimeToInteractiveTracker = require(Parent.TimeToInteractiveTracker).TimeToInteractiveTracker
local Milestone = TimeToInteractiveTracker.Milestone
local v4 = "AvatarExperience_" .. require(script.Parent.TTIMetricNames).Marketplace.OrganicThumbnails
local t1 = {
	SponsoredSearchStarted = "SponsoredSearchStarted",
	SponsoredSearchCompleted = "SponsoredSearchCompleted",
	CatalogApiSearchStarted = "CatalogApiSearchStarted",
	CatalogApiSearchCompleted = "CatalogApiSearchCompleted"
}

return {
	CustomSubphases = t1,
	Hooks = {
		useRenderAndMountedTracking = function() -- line: 26
			-- upvalues: TimeToInteractiveTracker (copy), v4 (copy)
			TimeToInteractiveTracker.Hooks.useTTIRenderAndMountedTracking(v4)
		end
	},
	L2 = {
		primaryDataStarted = function() -- line: 32
			-- upvalues: TimeToInteractiveTracker (copy), v4 (copy), Milestone (copy)
			TimeToInteractiveTracker.trackMilestone(v4, Milestone.PrimaryDataStarted.Name)
		end,
		primaryDataReady = function() -- line: 35
			-- upvalues: TimeToInteractiveTracker (copy), v4 (copy), Milestone (copy)
			TimeToInteractiveTracker.trackMilestone(v4, Milestone.PrimaryDataReady.Name)
		end,
		dataProcessingStarted = function() -- line: 38
			-- upvalues: TimeToInteractiveTracker (copy), v4 (copy), Milestone (copy)
			TimeToInteractiveTracker.trackMilestone(v4, Milestone.DataProcessingStarted.Name)
		end,
		dataProcessingCompleted = function() -- line: 41
			-- upvalues: TimeToInteractiveTracker (copy), v4 (copy), Milestone (copy)
			TimeToInteractiveTracker.trackMilestone(v4, Milestone.DataProcessingCompleted.Name)
		end,
		functionallyReady = function() -- line: 44
			-- upvalues: TimeToInteractiveTracker (copy), v4 (copy), Milestone (copy)
			TimeToInteractiveTracker.trackMilestone(v4, Milestone.FunctionallyReady)
		end,
		surfaceReady = function() -- line: 47
			-- upvalues: TimeToInteractiveTracker (copy), v4 (copy), Milestone (copy)
			TimeToInteractiveTracker.trackMilestone(v4, Milestone.SurfaceReady)
		end
	},
	L3 = {
		networkFetch = function() -- line: 53
			-- upvalues: TimeToInteractiveTracker (copy), v4 (copy), Milestone (copy)
			TimeToInteractiveTracker.trackSubphase(v4, Milestone.PrimaryDataStarted.Name, Milestone.PrimaryDataStarted.Subphase.NetworkFetch)
		end,
		responseReceived = function() -- line: 60
			-- upvalues: TimeToInteractiveTracker (copy), v4 (copy), Milestone (copy)
			TimeToInteractiveTracker.trackSubphase(v4, Milestone.PrimaryDataStarted.Name, Milestone.PrimaryDataStarted.Subphase.ResponseReceived)
		end,
		sponsoredSearchStarted = function() -- line: 67
			-- upvalues: TimeToInteractiveTracker (copy), v4 (copy), Milestone (copy), t1 (copy)
			TimeToInteractiveTracker.trackSubphase(v4, Milestone.PrimaryDataStarted.Name, t1.SponsoredSearchStarted)
		end,
		sponsoredSearchCompleted = function() -- line: 74
			-- upvalues: TimeToInteractiveTracker (copy), v4 (copy), Milestone (copy), t1 (copy)
			TimeToInteractiveTracker.trackSubphase(v4, Milestone.PrimaryDataStarted.Name, t1.SponsoredSearchCompleted)
		end,
		catalogApiSearchStarted = function() -- line: 81
			-- upvalues: TimeToInteractiveTracker (copy), v4 (copy), Milestone (copy), t1 (copy)
			TimeToInteractiveTracker.trackSubphase(v4, Milestone.PrimaryDataStarted.Name, t1.CatalogApiSearchStarted)
		end,
		catalogApiSearchCompleted = function() -- line: 88
			-- upvalues: TimeToInteractiveTracker (copy), v4 (copy), Milestone (copy), t1 (copy)
			TimeToInteractiveTracker.trackSubphase(v4, Milestone.PrimaryDataStarted.Name, t1.CatalogApiSearchCompleted)
		end
	}
}
