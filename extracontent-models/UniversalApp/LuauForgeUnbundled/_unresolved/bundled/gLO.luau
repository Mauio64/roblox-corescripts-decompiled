local fFlagAXTTIEditorEnableMilestones = require("@luauforge/bundled/gLJ").FFlagAXTTIEditorEnableMilestones
local timeToInteractiveTracker = require("@luauforge/bundled/gLI").TimeToInteractiveTracker
local milestone = timeToInteractiveTracker.Milestone
local module = require("@luauforge/bundled/gLM")
local fFlagEnablePLTPrefetchCallbacks = module.FFlagEnablePLTPrefetchCallbacks

local module2 = require("@luauforge/bundled/gLK")
local module3 = require("@luauforge/bundled/gLH")

local v5 = "AvatarExperience_" .. module2.Editor.InventoryThumbnails

local root = if fFlagAXTTIEditorEnableMilestones then module3.Surface.AvatarEditor.Root else nil

local count = 0

local v6 = {
	GetUserInventoryV2Started = "GetUserInventoryV2Started",
	GetUserInventoryV2Completed = "GetUserInventoryV2Completed",
	GetUserInventoryStarted = "GetUserInventoryStarted",
	GetUserInventoryCompleted = "GetUserInventoryCompleted",
	GetOutfitsStarted = "GetOutfitsStarted",
	GetOutfitsCompleted = "GetOutfitsCompleted"
}

local v7 = {
	BatchGetOutfits = "BatchGetOutfits",
	GetRecommendedItems = "GetRecommendedItems",
	GetAvatarData = "GetAvatarData"
}
return {
	CustomSubphases = v6,
	Requests = v7,
	startTracking = function(p2)
		count += 1
		root.startTracking(p2)
	end,
	ensureSessionActive = function(p2): boolean
		local events = timeToInteractiveTracker.getEvents()
		local v8 = not (events == nil) and events[v5] ~= nil

		if v8 then
			if p2 then
				root.updateMetadata(module2.Editor.InventoryTiles, p2)
				root.updateMetadata(module2.Editor.InventoryThumbnails, p2)
			end

			return false
		end

		count += 1
		root.startTracking(p2)
		return true
	end,
	updateMetadata = function(p2)
		local events = timeToInteractiveTracker.getEvents()
		local v8 = not (events == nil) and events[v5] ~= nil

		if not v8 then
			return
		end

		root.updateMetadata(module2.Editor.InventoryTiles, p2)
		root.updateMetadata(module2.Editor.InventoryThumbnails, p2)
	end,
	isSessionActive = function(): boolean
		local events = timeToInteractiveTracker.getEvents()
		return events ~= nil and events[v5] ~= nil
	end,
	getSessionGeneration = function()
		return count
	end,
	endTilesTracking = function(p2)
		local events = timeToInteractiveTracker.getEvents()
		local v8 = not (events == nil) and events[v5] ~= nil

		if not v8 then
			return
		end

		root.endTracking(module2.Editor.InventoryTiles, p2)
	end,
	endThumbnailsTracking = function(p2)
		local events = timeToInteractiveTracker.getEvents()
		local v8 = not (events == nil) and events[v5] ~= nil

		if not v8 then
			return
		end

		root.endTracking(module2.Editor.InventoryThumbnails, p2)
	end,
	Hooks = {
		useRenderAndMountedTracking = function()
			timeToInteractiveTracker.Hooks.useTTIRenderAndMountedTracking(v5)
		end
	},
	L2 = {
		primaryDataStarted = function()
			local events = timeToInteractiveTracker.getEvents()
			local v8 = not (events == nil) and events[v5] ~= nil

			if not v8 then
				return
			end

			timeToInteractiveTracker.trackMilestone(v5, milestone.PrimaryDataStarted.Name)
		end,
		primaryDataReady = function()
			local events = timeToInteractiveTracker.getEvents()
			local v8 = not (events == nil) and events[v5] ~= nil

			if not v8 then
				return
			end

			timeToInteractiveTracker.trackMilestone(v5, milestone.PrimaryDataReady.Name)
		end,
		dataProcessingStarted = function()
			local events = timeToInteractiveTracker.getEvents()
			local v8 = not (events == nil) and events[v5] ~= nil

			if not v8 then
				return
			end

			timeToInteractiveTracker.trackMilestone(v5, milestone.DataProcessingStarted.Name)
		end,
		dataProcessingCompleted = function()
			local events = timeToInteractiveTracker.getEvents()
			local v8 = not (events == nil) and events[v5] ~= nil

			if not v8 then
				return
			end

			timeToInteractiveTracker.trackMilestone(v5, milestone.DataProcessingCompleted.Name)
		end,
		functionallyReady = function()
			local events = timeToInteractiveTracker.getEvents()
			local v8 = not (events == nil) and events[v5] ~= nil

			if not v8 then
				return
			end

			timeToInteractiveTracker.trackMilestone(v5, milestone.FunctionallyReady)

			if fFlagEnablePLTPrefetchCallbacks then
				module.signal(module.Page.AvatarEditor, module.Milestone.FunctionallyReady)
			end
		end,
		surfaceReady = function()
			local events = timeToInteractiveTracker.getEvents()
			local v8 = not (events == nil) and events[v5] ~= nil

			if not v8 then
				return
			end

			timeToInteractiveTracker.trackMilestone(v5, milestone.SurfaceReady)
		end
	},
	L3 = {
		networkFetch = function()
			local events = timeToInteractiveTracker.getEvents()
			local v8 = not (events == nil) and events[v5] ~= nil

			if not v8 then
				return
			end

			timeToInteractiveTracker.trackSubphase(
				v5,
				milestone.PrimaryDataStarted.Name,
				milestone.PrimaryDataStarted.Subphase.NetworkFetch
			)
		end,
		getInventoryV2Started = function()
			local events = timeToInteractiveTracker.getEvents()
			local v8 = not (events == nil) and events[v5] ~= nil

			if not v8 then
				return
			end

			timeToInteractiveTracker.trackSubphase(
				v5,
				milestone.PrimaryDataStarted.Name,
				v6.GetUserInventoryV2Started
			)
		end,
		getInventoryV2Completed = function()
			local events = timeToInteractiveTracker.getEvents()
			local v8 = not (events == nil) and events[v5] ~= nil

			if not v8 then
				return
			end

			timeToInteractiveTracker.trackSubphase(
				v5,
				milestone.PrimaryDataStarted.Name,
				v6.GetUserInventoryV2Completed
			)
		end,
		getInventoryStarted = function()
			local events = timeToInteractiveTracker.getEvents()
			local v8 = not (events == nil) and events[v5] ~= nil

			if not v8 then
				return
			end

			timeToInteractiveTracker.trackSubphase(
				v5,
				milestone.PrimaryDataStarted.Name,
				v6.GetUserInventoryStarted
			)
		end,
		getInventoryCompleted = function()
			local events = timeToInteractiveTracker.getEvents()
			local v8 = not (events == nil) and events[v5] ~= nil

			if not v8 then
				return
			end

			timeToInteractiveTracker.trackSubphase(
				v5,
				milestone.PrimaryDataStarted.Name,
				v6.GetUserInventoryCompleted
			)
		end,
		getOutfitsStarted = function()
			local events = timeToInteractiveTracker.getEvents()
			local v8 = not (events == nil) and events[v5] ~= nil

			if not v8 then
				return
			end

			timeToInteractiveTracker.trackSubphase(
				v5,
				milestone.PrimaryDataStarted.Name,
				v6.GetOutfitsStarted
			)
		end,
		getOutfitsCompleted = function()
			local events = timeToInteractiveTracker.getEvents()
			local v8 = not (events == nil) and events[v5] ~= nil

			if not v8 then
				return
			end

			timeToInteractiveTracker.trackSubphase(
				v5,
				milestone.PrimaryDataStarted.Name,
				v6.GetOutfitsCompleted
			)
		end,
		requestBatchGetOutfits = function()
			local events = timeToInteractiveTracker.getEvents()
			local v8 = not (events == nil) and events[v5] ~= nil

			if not v8 then
				return
			end

			timeToInteractiveTracker.trackRequest(v5, milestone.PrimaryDataReady.Name, v7.BatchGetOutfits)
		end,
		requestGetRecommendedItems = function()
			local events = timeToInteractiveTracker.getEvents()
			local v8 = not (events == nil) and events[v5] ~= nil

			if not v8 then
				return
			end

			timeToInteractiveTracker.trackRequest(
				v5,
				milestone.PrimaryDataReady.Name,
				v7.GetRecommendedItems
			)
		end,
		requestGetAvatarData = function()
			local events = timeToInteractiveTracker.getEvents()
			local v8 = not (events == nil) and events[v5] ~= nil

			if not v8 then
				return
			end

			timeToInteractiveTracker.trackRequest(v5, milestone.PrimaryDataReady.Name, v7.GetAvatarData)
		end
	}
}
