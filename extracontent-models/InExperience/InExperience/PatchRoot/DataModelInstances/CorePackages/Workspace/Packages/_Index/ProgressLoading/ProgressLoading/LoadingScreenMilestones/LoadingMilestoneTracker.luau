local ProgressLoading = script:FindFirstAncestor("ProgressLoading")
local parent = ProgressLoading.Parent

require(script.Parent.Types)
local Constants = require(script.Parent.Constants)
local tryMilestoneOperation = require(script.Parent.tryMilestoneOperation)
local FIntLoadingScreenMilestonesSampleRate = require(ProgressLoading.Flags.FIntLoadingScreenMilestonesSampleRate)

local function getAddedWait(p)
	local v = p.getEvents(false)[Constants.EVENT_NAME]
	local deltaMs = nil
	local deltaMs2 = nil

	if v and v.milestones then
		for _, milestone in v.milestones do
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

local function getHoldGateHit(p): nil | boolean
	local v = p.getEvents(false)[Constants.EVENT_NAME]
	local deltaMs = nil
	local deltaMs2 = nil

	if v and v.milestones then
		for _, milestone in v.milestones do
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

local LoadingMilestoneTracker = {}

function LoadingMilestoneTracker.startMilestoneTracker(p, data)
	return tryMilestoneOperation(function()
		p.trackStart(Constants.EVENT_NAME)
		p.updateMetadata(Constants.EVENT_NAME, {
			category = data.category,
			page = data.page,
			subcategory = data.subcategory
		})
	end)
end

function LoadingMilestoneTracker.recordMilestone(p, p2: string, id)
	return tryMilestoneOperation(function()
		p.trackMilestone(Constants.EVENT_NAME, p2, id and { id = id } or nil)
	end)
end

function LoadingMilestoneTracker.completeMilestoneTracker(p, flag: boolean, dismissSource, flag2: boolean?)
	local v = nil
	local v2 = nil
	return tryMilestoneOperation(function()
		local v3

		if flag then
			v3 = getAddedWait(p)
		end

		v = v3
		local v4

		if flag2 then
			v4 = getHoldGateHit(p)
		end

		v2 = v4

		if dismissSource then
			p.updateMetadata(Constants.EVENT_NAME, { dismissSource = dismissSource })
		end

		p.trackEnd(Constants.EVENT_NAME, {
			samplingRateOverride = FIntLoadingScreenMilestonesSampleRate
		})
	end), v, v2
end

function LoadingMilestoneTracker.discardMilestoneTracker(p)
	return tryMilestoneOperation(function()
		p.destroyEvent(Constants.EVENT_NAME)
	end)
end

return LoadingMilestoneTracker
