local parent = script:FindFirstAncestor("ProgressLoading").Parent

local Constants = require(script.Parent.Constants)
require(script.Parent.Types)
local LoadingMilestoneTelemetry = require(script.Parent.LoadingMilestoneTelemetry)
local LoadingMilestoneTracker = require(script.Parent.LoadingMilestoneTracker)
local tryMilestoneOperation = require(script.Parent.tryMilestoneOperation)

local AbortReason = Constants.AbortReason
local Outcome = Constants.Outcome
local Milestone = Constants.Milestone

local v = nil

local function getTreatmentSubcategory(data) -- 1 equivalent call inferred from this helper
	return (data.host == Constants.Host.DeferredJoin and "DeferredJoin_" or "") .. (data.reducedMotion and "ReducedMotion_" or "") .. (data.holdEnabled and "HoldOn" or "HoldOff")
end

return {
	start = function(data)
		if v then
			v.abort(AbortReason.Replaced)
		end

		local v2 = nil
		local v3 = nil
		local v4 = nil
		local set = {}
		local treatmentSubcategory = getTreatmentSubcategory(data) -- inferred equivalent call
		local page = data.page
		local v5 = { category = 0, page = 0, subcategory = 0 }
		v5.category = Constants.CATEGORY
		v5.page = page
		v5.subcategory = treatmentSubcategory

		local function discard() -- 5 equivalent calls inferred from this helper
			local v6 = v2
			v2 = nil

			if v6 then
				return LoadingMilestoneTracker.discardMilestoneTracker(v6)
			end

			return true
		end

		local function reportOutcome(p) -- 6 equivalent calls inferred from this helper
			LoadingMilestoneTelemetry.countMilestonesOutcome(v5, p)
		end

		local function record(p: string, p2)
			local v6

			if p2 then
				v6 = p .. "/" .. p2
			else
				v6 = p
			end

			if v ~= v3 or set[v6] then
				return
			end

			set[v6] = true
			local v7 = v2

			if v7 and not LoadingMilestoneTracker.recordMilestone(v7, p, p2) then
				v = nil
				discard() -- inferred equivalent call
				reportOutcome(Outcome.InstrumentationError) -- inferred equivalent call
			end
		end

		v3 = {
			dismissRequested = function(p)
				if v == v3 then
					v4 = v4 or p
				end

				local dismissRequested = Milestone.DismissRequested
				local v6

				if p then
					v6 = dismissRequested .. "/" .. p
				else
					v6 = dismissRequested
				end

				if v == v3 then
					if set[v6] then
						return
					end

					set[v6] = true
					local v7 = v2

					if v7 and not LoadingMilestoneTracker.recordMilestone(v7, dismissRequested, p) then
						v = nil
						discard() -- inferred equivalent call
						reportOutcome(Outcome.InstrumentationError) -- inferred equivalent call
					end
				end
			end,
			contentVisible = function(p)
				if not set[Milestone.ScreenVisible] or set[Milestone.DismissStarted] then
					return
				end

				local contentVisible = Milestone.ContentVisible
				local v6

				if p then
					v6 = contentVisible .. "/" .. p
				else
					v6 = contentVisible
				end

				if v == v3 then
					if set[v6] then
						return
					end

					set[v6] = true
					local v7 = v2

					if v7 and not LoadingMilestoneTracker.recordMilestone(v7, contentVisible, p) then
						v = nil
						discard() -- inferred equivalent call
						reportOutcome(Outcome.InstrumentationError) -- inferred equivalent call
					end
				end
			end,
			record = function(p)
				if v == v3 then
					if set[p] then
						return
					end

					set[p] = true
					local v6 = v2

					if v6 and not LoadingMilestoneTracker.recordMilestone(v6, p, nil) then
						v = nil
						discard() -- inferred equivalent call
						reportOutcome(Outcome.InstrumentationError) -- inferred equivalent call
					end
				end
			end,
			complete = function()
				if v ~= v3 then
					return
				end

				v = nil
				local v6 = Outcome.Completed
				local v7 = v2

				if v7 then
					local completeMilestoneTracker = LoadingMilestoneTracker.completeMilestoneTracker
					local v8

					if v4 == nil then
						v8 = false
					else
						v8 = set[Milestone.DismissStarted] == true
					end

					local v9 = v4
					local v10

					if treatmentSubcategory == "HoldOn" then
						v10 = v4 == Constants.DismissSource.NormalReady
					else
						v10 = false
					end

					local v11, v12, v13 = completeMilestoneTracker(v7, v8, v9, v10)

					if v11 and v12 ~= nil and v4 then
						v11 = LoadingMilestoneTelemetry.reportAddedWait(v5, v12, v4)
					end

					if v11 and set[Milestone.ScreenVisible] and set[Milestone.DismissStarted] then
						v11 = LoadingMilestoneTelemetry.reportContentVisibility(
							v5,
							set[Milestone.ContentVisible .. "/" .. Constants.ContentId.Title] == true,
							set[Milestone.ContentVisible .. "/" .. Constants.ContentId.Creator] == true,
							set[Milestone.ContentVisible .. "/" .. Constants.ContentId.Thumbnail] == true
						)
					end

					if v11 and v13 ~= nil then
						v11 = LoadingMilestoneTelemetry.reportHoldGateHit(v5, v13)
					end

					if not v11 then
						discard() -- inferred equivalent call
						v6 = Outcome.InstrumentationError
					end
				end

				v2 = nil
				reportOutcome(v6) -- inferred equivalent call
			end,
			abort = function(p)
				if v ~= v3 then
					return
				end

				v = nil
				local v6 = v2
				v2 = nil

				if v6 and not LoadingMilestoneTracker.discardMilestoneTracker(v6) then
					p = Outcome.InstrumentationError
				end

				reportOutcome(p) -- inferred equivalent call
			end
		}

		v = v3

		local v6 = false

		if tryMilestoneOperation(function()
			v5 = LoadingMilestoneTelemetry.getMilestoneSessionMetadata(treatmentSubcategory, page)

			if not LoadingMilestoneTelemetry.countMilestonesStarted(v5) then
				return
			end

			local TimeToInteractiveTracker = require(parent.TimeToInteractiveTracker)
			local timeToInteractiveTracker = TimeToInteractiveTracker.TimeToInteractiveTracker
			v2 = timeToInteractiveTracker
			v6 = LoadingMilestoneTracker.startMilestoneTracker(timeToInteractiveTracker, v5)
		end) and v6 then
			return v3
		end

		v3.abort(AbortReason.InitializationFailed)
		return nil
	end,
	AbortReason = AbortReason,
	Page = Constants.Page,
	Milestone = Milestone,
	DismissSource = Constants.DismissSource
}
