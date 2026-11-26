require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenMilestones/Types")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenMilestones/Constants")
local tryMilestoneOperation = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenMilestones/tryMilestoneOperation")
local FIntLoadingScreenMilestonesSampleRate = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Flags/FIntLoadingScreenMilestonesSampleRate")

local function getAddedWait(p2)
	local v5 = p2.getEvents(false)[Constants.EVENT_NAME]
	local deltaMs = nil
	local deltaMs2 = nil

	if v5 and v5.milestones then
		for k, milestone in v5.milestones do
			local name = milestone.name

			if name == Constants.Milestone.DismissRequested and deltaMs == nil then
				deltaMs = milestone.deltaMs
			elseif name == Constants.Milestone.DismissStarted then
				deltaMs2 = milestone.deltaMs
			end
		end
	end

	if deltaMs and deltaMs2 and deltaMs <= deltaMs2 then
		return deltaMs2 - deltaMs
	end

	return nil
end

local function getHoldGateHit(p2): nil | boolean
	local v5 = p2.getEvents(false)[Constants.EVENT_NAME]
	local deltaMs = nil
	local deltaMs2 = nil

	if v5 and v5.milestones then
		for k, milestone in v5.milestones do
			local name = milestone.name

			if
				name == Constants.Milestone.DismissRequested
				and milestone.id == Constants.DismissSource.NormalReady
				and deltaMs == nil
			then
				deltaMs = milestone.deltaMs
			elseif name == Constants.Milestone.DismissGateReleased and deltaMs2 == nil then
				deltaMs2 = milestone.deltaMs
			end
		end
	end

	if deltaMs == nil or deltaMs2 == nil then
		return nil
	end

	return deltaMs < deltaMs2
end

return {
	startMilestoneTracker = function(p2, data)
		return tryMilestoneOperation(function()
			p2.trackStart(Constants.EVENT_NAME)
			p2.updateMetadata(Constants.EVENT_NAME, {
				category = data.category,
				page = data.page,
				subcategory = data.subcategory
			})
		end)
	end,
	recordMilestone = function(p2, p3, p4)
		return tryMilestoneOperation(function()
			p2.trackMilestone(Constants.EVENT_NAME, p3, p4 and { id = p4 } or nil)
		end)
	end,
	completeMilestoneTracker = function(p2, p3, p4, p5)
		local v5 = nil
		local v6 = nil
		return tryMilestoneOperation(function()
			v5 = if p3 then getAddedWait(p2) else nil
			v6 = if p5 then getHoldGateHit(p2) else nil

			if p4 then
				p2.updateMetadata(Constants.EVENT_NAME, { dismissSource = p4 })
			end

			p2.trackEnd(Constants.EVENT_NAME, { samplingRateOverride = FIntLoadingScreenMilestonesSampleRate })
		end), v5, v6
	end,
	discardMilestoneTracker = function(p2)
		return tryMilestoneOperation(function()
			p2.destroyEvent(Constants.EVENT_NAME)
		end)
	end
}
