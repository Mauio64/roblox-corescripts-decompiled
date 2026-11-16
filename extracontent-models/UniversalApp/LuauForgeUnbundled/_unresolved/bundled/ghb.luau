local timeToInteractiveTracker = require("@luauforge/bundled/ghc").TimeToInteractiveTracker
local milestone = timeToInteractiveTracker.Milestone

local fFlagAXTTIEditorEnableMilestones = require("@luauforge/bundled/ghd").FFlagAXTTIEditorEnableMilestones
local fFlagAXTTIEditorColdStartDetection = require("@luauforge/bundled/ghd").FFlagAXTTIEditorColdStartDetection

local module = require("@luauforge/bundled/ghe")

local function resolveTTIName(p2, p3)
	local ttiName = "AvatarExperience_" .. p2

	if p3 then
		ttiName ..= "_Percieved"
	end

	return ttiName
end

local function applyMetadata(p2, p3)
	if p3 then
		timeToInteractiveTracker.updateMetadata(p2, p3)
	end
end

local function eventExists(p2): boolean
	local events = timeToInteractiveTracker.getEvents()
	return events ~= nil and events[p2] ~= nil
end

local function createSurface(items, p2)
	local function batchStart(p3, p4)
		for k, item in items do
			local v5 = "AvatarExperience_" .. item

			if p3 then
				v5 ..= "_Percieved"
			end

			if fFlagAXTTIEditorColdStartDetection and p2 then
				timeToInteractiveTracker.trackStart(v5, true)
			else
				timeToInteractiveTracker.trackStart(v5)
			end

			if p4 then
				timeToInteractiveTracker.updateMetadata(v5, p4)
			end
		end
	end

	local function endSingle(p3, p4, p5)
		local v5 = "AvatarExperience_" .. p3

		if p4 then
			v5 ..= "_Percieved"
		end

		if p4 then
			local events = timeToInteractiveTracker.getEvents()
			local v6 = not (events == nil) and events[v5] ~= nil

			if not v6 then
				return
			end
		end

		if p5 then
			timeToInteractiveTracker.updateMetadata(v5, p5)
		end

		timeToInteractiveTracker.trackEnd(v5, p4 and { cleanupAfterSend = false } or nil)
	end

	return {
		eventNames = items,
		startTracking = function(p3)
			batchStart(false, p3)
		end,
		startPerceivedTracking = function(p3)
			batchStart(true, p3)
		end,
		endTracking = function(p3, p4)
			local v5 = "AvatarExperience_" .. p3

			if p4 then
				timeToInteractiveTracker.updateMetadata(v5, p4)
			end

			timeToInteractiveTracker.trackEnd(v5, nil)
		end,
		endPerceivedTracking = function(p3, p4)
			local v5 = ("AvatarExperience_" .. p3) .. "_Percieved"

			local events = timeToInteractiveTracker.getEvents()
			local v6 = not (events == nil) and events[v5] ~= nil

			if not v6 then
				return
			end

			if p4 then
				timeToInteractiveTracker.updateMetadata(v5, p4)
			end

			timeToInteractiveTracker.trackEnd(v5, nil)
		end,
		updateMetadata = function(p3, p4)
			local v5 = "AvatarExperience_" .. p3

			if p4 then
				timeToInteractiveTracker.updateMetadata(v5, p4)
			end
		end,
		trackMilestone = function(p3, p4, p5)
			timeToInteractiveTracker.trackMilestone("AvatarExperience_" .. p3, p4, p5)
		end,
		trackSubphase = function(p3, p4, p5)
			timeToInteractiveTracker.trackSubphase("AvatarExperience_" .. p3, p4, p5)
		end,
		trackRequest = function(p3, p4, p5)
			timeToInteractiveTracker.trackRequest("AvatarExperience_" .. p3, p4, p5)
		end
	}
end

return {
	Surface = {
		Marketplace = {
			Root = createSurface({
				module.Marketplace.OrganicTiles,
				module.Marketplace.OrganicThumbnails,
				module.Marketplace.WidgetTiles,
				module.Marketplace.WidgetThumbnails
			})
		},
		AvatarEditor = fFlagAXTTIEditorEnableMilestones and {
			Root = createSurface(
				{ module.Editor.InventoryTiles, module.Editor.InventoryThumbnails },
				fFlagAXTTIEditorColdStartDetection
			)
		} or nil
	},
	Milestone = milestone,
	TTIMetricNames = module
}
