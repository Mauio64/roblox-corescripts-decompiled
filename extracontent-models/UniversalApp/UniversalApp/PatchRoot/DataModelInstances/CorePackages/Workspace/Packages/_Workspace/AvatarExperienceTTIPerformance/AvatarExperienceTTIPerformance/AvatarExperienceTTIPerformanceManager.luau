local Parent = script:FindFirstAncestor("AvatarExperienceTTIPerformance").Parent
local TimeToInteractiveTracker = require(Parent.TimeToInteractiveTracker).TimeToInteractiveTracker
local Milestone = TimeToInteractiveTracker.Milestone
local FFlagAXTTIEditorEnableMilestones = require(Parent.AvatarExperienceFlags).FFlagAXTTIEditorEnableMilestones
local TTIMetricNames = require(script.Parent.TTIMetricNames)

local function resolveTTIName(p1, b1: boolean?) -- line: 21
	local v12 = "AvatarExperience_" .. p1

	if b1 then
		v12 ..= "_Percieved"
	end

	return v12
end
local function applyMetadata(s1: string, p2) -- line: 30
	-- upvalues: TimeToInteractiveTracker (copy)
	if p2 then
		TimeToInteractiveTracker.updateMetadata(s1, p2)
	end
end
local function eventExists(s2: string) -- line: 36
	-- upvalues: TimeToInteractiveTracker (copy)
	local v16 = TimeToInteractiveTracker.getEvents()

	return v16 ~= nil and v16[s2] ~= nil
end
local function createSurface(t1: {[any]: any}) -- line: 48
	-- upvalues: TimeToInteractiveTracker (copy)
	local function batchStart(b2: boolean?, p3) -- line: 49
		-- upvalues: t1 (copy), TimeToInteractiveTracker (copy)
		for _, v23 in t1 do
			local v24 = "AvatarExperience_" .. v23

			if b2 then
				v24 ..= "_Percieved"
			end

			TimeToInteractiveTracker.trackStart(v24)

			if p3 then
				TimeToInteractiveTracker.updateMetadata(v24, p3)
			end
		end
	end
	local function endSingle(p4, b3: boolean?, p5) -- line: 57
		-- upvalues: TimeToInteractiveTracker (copy)
		local v28 = "AvatarExperience_" .. p4

		if b3 then
			v28 ..= "_Percieved"
		end

		if b3 then
			local v29 = TimeToInteractiveTracker.getEvents()

			if v29 == nil or v29[v28] == nil then
				return
			end
		end

		if p5 then
			TimeToInteractiveTracker.updateMetadata(v28, p5)
		end

		TimeToInteractiveTracker.trackEnd(v28, if not b3 then nil else {
			cleanupAfterSend = false
		})
	end

	return {
		eventNames = t1,
		startTracking = function(p6) -- line: 69
			-- upvalues: batchStart (copy)
			batchStart(false, p6)
		end,
		startPerceivedTracking = function(p7) -- line: 73
			-- upvalues: batchStart (copy)
			batchStart(true, p7)
		end,
		endTracking = function(p8, p9) -- line: 77
			-- upvalues: TimeToInteractiveTracker (copy)
			local v34 = "AvatarExperience_" .. p8

			if p9 then
				TimeToInteractiveTracker.updateMetadata(v34, p9)
			end

			TimeToInteractiveTracker.trackEnd(v34, nil)
		end,
		endPerceivedTracking = function(p10, p11) -- line: 81
			-- upvalues: TimeToInteractiveTracker (copy)
			local v37 = ("AvatarExperience_" .. p10) .. "_Percieved"
			local v38 = TimeToInteractiveTracker.getEvents()

			if v38 == nil or v38[v37] == nil then
				return
			end

			if p11 then
				TimeToInteractiveTracker.updateMetadata(v37, p11)
			end

			TimeToInteractiveTracker.trackEnd(v37, nil)
		end,
		updateMetadata = function(p12, p13) -- line: 85
			-- upvalues: TimeToInteractiveTracker (copy)
			local v41 = "AvatarExperience_" .. p12

			if p13 then
				TimeToInteractiveTracker.updateMetadata(v41, p13)
			end
		end,
		trackMilestone = function(p14, p15, p16) -- line: 89
			-- upvalues: TimeToInteractiveTracker (copy)
			TimeToInteractiveTracker.trackMilestone("AvatarExperience_" .. p14, p15, p16)
		end,
		trackSubphase = function(p17, p18, p19) -- line: 93
			-- upvalues: TimeToInteractiveTracker (copy)
			TimeToInteractiveTracker.trackSubphase("AvatarExperience_" .. p17, p18, p19)
		end,
		trackRequest = function(p20, p21, s3: string) -- line: 97
			-- upvalues: TimeToInteractiveTracker (copy)
			TimeToInteractiveTracker.trackRequest("AvatarExperience_" .. p20, p21, s3)
		end
	}
end

return {
	Surface = {
		Marketplace = {
			Root = createSurface({
				TTIMetricNames.Marketplace.OrganicTiles,
				TTIMetricNames.Marketplace.OrganicThumbnails,
				TTIMetricNames.Marketplace.WidgetTiles,
				TTIMetricNames.Marketplace.WidgetThumbnails
			})
		},
		AvatarEditor = if not FFlagAXTTIEditorEnableMilestones then nil else {
			Root = createSurface({
				TTIMetricNames.Editor.InventoryTiles,
				TTIMetricNames.Editor.InventoryThumbnails
			})
		}
	},
	Milestone = Milestone,
	TTIMetricNames = TTIMetricNames
}
