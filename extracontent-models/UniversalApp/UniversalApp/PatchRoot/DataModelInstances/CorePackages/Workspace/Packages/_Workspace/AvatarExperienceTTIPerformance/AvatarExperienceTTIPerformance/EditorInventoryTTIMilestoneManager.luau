local Parent = script:FindFirstAncestor("AvatarExperienceTTIPerformance").Parent
local FFlagAXTTIEditorEnableMilestones = require(Parent.AvatarExperienceFlags).FFlagAXTTIEditorEnableMilestones
local TimeToInteractiveTracker = require(Parent.TimeToInteractiveTracker).TimeToInteractiveTracker
local Milestone = TimeToInteractiveTracker.Milestone
local TTIMetricNames = require(script.Parent.TTIMetricNames)
local AvatarExperienceTTIPerformanceManager = require(script.Parent.AvatarExperienceTTIPerformanceManager)
local v7 = "AvatarExperience_" .. TTIMetricNames.Editor.InventoryTiles
local v8 = if not FFlagAXTTIEditorEnableMilestones then nil else AvatarExperienceTTIPerformanceManager.Surface.AvatarEditor.Root

local function isSessionActive() -- line: 25
	-- upvalues: TimeToInteractiveTracker (copy), v7 (copy)
	local v13 = TimeToInteractiveTracker.getEvents()

	return v13 ~= nil and v13[v7] ~= nil
end

local n1 = 0
local t1 = {
	GetUserInventoryV2Started = "GetUserInventoryV2Started",
	GetUserInventoryV2Completed = "GetUserInventoryV2Completed",
	GetUserInventoryStarted = "GetUserInventoryStarted",
	GetUserInventoryCompleted = "GetUserInventoryCompleted",
	GetOutfitsStarted = "GetOutfitsStarted",
	GetOutfitsCompleted = "GetOutfitsCompleted"
}
local t2 = {
	BatchGetOutfits = "BatchGetOutfits",
	GetRecommendedItems = "GetRecommendedItems",
	GetAvatarData = "GetAvatarData"
}

return {
	CustomSubphases = t1,
	Requests = t2,
	startTracking = function() -- line: 59
		-- upvalues: n1 (ref), v8 (copy)
		n1 += 1
		v8.startTracking()
	end,
	getSessionGeneration = function() -- line: 63
		-- upvalues: n1 (ref)
		return n1
	end,
	endTilesTracking = function() -- line: 66
		-- upvalues: TimeToInteractiveTracker (copy), v7 (copy), v8 (copy), TTIMetricNames (copy)
		local v14 = TimeToInteractiveTracker.getEvents()

		if v14 == nil or v14[v7] == nil then
			return
		end

		v8.endTracking(TTIMetricNames.Editor.InventoryTiles)
	end,
	endThumbnailsTracking = function() -- line: 72
		-- upvalues: TimeToInteractiveTracker (copy), v7 (copy), v8 (copy), TTIMetricNames (copy)
		local v15 = TimeToInteractiveTracker.getEvents()

		if v15 == nil or v15[v7] == nil then
			return
		end

		v8.endTracking(TTIMetricNames.Editor.InventoryThumbnails)
	end,
	Hooks = {
		useRenderAndMountedTracking = function() -- line: 80
			-- upvalues: TimeToInteractiveTracker (copy), v7 (copy)
			TimeToInteractiveTracker.Hooks.useTTIRenderAndMountedTracking(v7)
		end
	},
	L2 = {
		primaryDataStarted = function() -- line: 86
			-- upvalues: TimeToInteractiveTracker (copy), v7 (copy), Milestone (copy)
			local v16 = TimeToInteractiveTracker.getEvents()

			if v16 == nil or v16[v7] == nil then
				return
			end

			TimeToInteractiveTracker.trackMilestone(v7, Milestone.PrimaryDataStarted.Name)
		end,
		primaryDataReady = function() -- line: 92
			-- upvalues: TimeToInteractiveTracker (copy), v7 (copy), Milestone (copy)
			local v17 = TimeToInteractiveTracker.getEvents()

			if v17 == nil or v17[v7] == nil then
				return
			end

			TimeToInteractiveTracker.trackMilestone(v7, Milestone.PrimaryDataReady.Name)
		end,
		dataProcessingStarted = function() -- line: 98
			-- upvalues: TimeToInteractiveTracker (copy), v7 (copy), Milestone (copy)
			local v18 = TimeToInteractiveTracker.getEvents()

			if v18 == nil or v18[v7] == nil then
				return
			end

			TimeToInteractiveTracker.trackMilestone(v7, Milestone.DataProcessingStarted.Name)
		end,
		dataProcessingCompleted = function() -- line: 104
			-- upvalues: TimeToInteractiveTracker (copy), v7 (copy), Milestone (copy)
			local v19 = TimeToInteractiveTracker.getEvents()

			if v19 == nil or v19[v7] == nil then
				return
			end

			TimeToInteractiveTracker.trackMilestone(v7, Milestone.DataProcessingCompleted.Name)
		end,
		functionallyReady = function() -- line: 110
			-- upvalues: TimeToInteractiveTracker (copy), v7 (copy), Milestone (copy)
			local v20 = TimeToInteractiveTracker.getEvents()

			if v20 == nil or v20[v7] == nil then
				return
			end

			TimeToInteractiveTracker.trackMilestone(v7, Milestone.FunctionallyReady)
		end,
		surfaceReady = function() -- line: 116
			-- upvalues: TimeToInteractiveTracker (copy), v7 (copy), Milestone (copy)
			local v21 = TimeToInteractiveTracker.getEvents()

			if v21 == nil or v21[v7] == nil then
				return
			end

			TimeToInteractiveTracker.trackMilestone(v7, Milestone.SurfaceReady)
		end
	},
	L3 = {
		networkFetch = function() -- line: 126
			-- upvalues: TimeToInteractiveTracker (copy), v7 (copy), Milestone (copy)
			local v22 = TimeToInteractiveTracker.getEvents()

			if v22 == nil or v22[v7] == nil then
				return
			end

			TimeToInteractiveTracker.trackSubphase(v7, Milestone.PrimaryDataStarted.Name, Milestone.PrimaryDataStarted.Subphase.NetworkFetch)
		end,
		getInventoryV2Started = function() -- line: 138
			-- upvalues: TimeToInteractiveTracker (copy), v7 (copy), Milestone (copy), t1 (copy)
			local v23 = TimeToInteractiveTracker.getEvents()

			if v23 == nil or v23[v7] == nil then
				return
			end

			TimeToInteractiveTracker.trackSubphase(v7, Milestone.PrimaryDataStarted.Name, t1.GetUserInventoryV2Started)
		end,
		getInventoryV2Completed = function() -- line: 148
			-- upvalues: TimeToInteractiveTracker (copy), v7 (copy), Milestone (copy), t1 (copy)
			local v24 = TimeToInteractiveTracker.getEvents()

			if v24 == nil or v24[v7] == nil then
				return
			end

			TimeToInteractiveTracker.trackSubphase(v7, Milestone.PrimaryDataStarted.Name, t1.GetUserInventoryV2Completed)
		end,
		getInventoryStarted = function() -- line: 160
			-- upvalues: TimeToInteractiveTracker (copy), v7 (copy), Milestone (copy), t1 (copy)
			local v25 = TimeToInteractiveTracker.getEvents()

			if v25 == nil or v25[v7] == nil then
				return
			end

			TimeToInteractiveTracker.trackSubphase(v7, Milestone.PrimaryDataStarted.Name, t1.GetUserInventoryStarted)
		end,
		getInventoryCompleted = function() -- line: 170
			-- upvalues: TimeToInteractiveTracker (copy), v7 (copy), Milestone (copy), t1 (copy)
			local v26 = TimeToInteractiveTracker.getEvents()

			if v26 == nil or v26[v7] == nil then
				return
			end

			TimeToInteractiveTracker.trackSubphase(v7, Milestone.PrimaryDataStarted.Name, t1.GetUserInventoryCompleted)
		end,
		getOutfitsStarted = function() -- line: 182
			-- upvalues: TimeToInteractiveTracker (copy), v7 (copy), Milestone (copy), t1 (copy)
			local v27 = TimeToInteractiveTracker.getEvents()

			if v27 == nil or v27[v7] == nil then
				return
			end

			TimeToInteractiveTracker.trackSubphase(v7, Milestone.PrimaryDataStarted.Name, t1.GetOutfitsStarted)
		end,
		getOutfitsCompleted = function() -- line: 192
			-- upvalues: TimeToInteractiveTracker (copy), v7 (copy), Milestone (copy), t1 (copy)
			local v28 = TimeToInteractiveTracker.getEvents()

			if v28 == nil or v28[v7] == nil then
				return
			end

			TimeToInteractiveTracker.trackSubphase(v7, Milestone.PrimaryDataStarted.Name, t1.GetOutfitsCompleted)
		end,
		requestBatchGetOutfits = function() -- line: 203
			-- upvalues: TimeToInteractiveTracker (copy), v7 (copy), Milestone (copy), t2 (copy)
			local v29 = TimeToInteractiveTracker.getEvents()

			if v29 == nil or v29[v7] == nil then
				return
			end

			TimeToInteractiveTracker.trackRequest(v7, Milestone.PrimaryDataReady.Name, t2.BatchGetOutfits)
		end,
		requestGetRecommendedItems = function() -- line: 209
			-- upvalues: TimeToInteractiveTracker (copy), v7 (copy), Milestone (copy), t2 (copy)
			local v30 = TimeToInteractiveTracker.getEvents()

			if v30 == nil or v30[v7] == nil then
				return
			end

			TimeToInteractiveTracker.trackRequest(v7, Milestone.PrimaryDataReady.Name, t2.GetRecommendedItems)
		end,
		requestGetAvatarData = function() -- line: 219
			-- upvalues: TimeToInteractiveTracker (copy), v7 (copy), Milestone (copy), t2 (copy)
			local v31 = TimeToInteractiveTracker.getEvents()

			if v31 == nil or v31[v7] == nil then
				return
			end

			TimeToInteractiveTracker.trackRequest(v7, Milestone.PrimaryDataReady.Name, t2.GetAvatarData)
		end
	}
}
