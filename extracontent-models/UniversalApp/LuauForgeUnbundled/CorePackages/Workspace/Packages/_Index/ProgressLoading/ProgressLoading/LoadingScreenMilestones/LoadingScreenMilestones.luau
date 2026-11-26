local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenMilestones/Constants")
require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenMilestones/Types")
local LoadingMilestoneTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenMilestones/LoadingMilestoneTelemetry")
local LoadingMilestoneTracker = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenMilestones/LoadingMilestoneTracker")
local tryMilestoneOperation = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenMilestones/tryMilestoneOperation")

local abortReason = Constants.AbortReason
local outcome = Constants.Outcome
local milestone = Constants.Milestone

local v5 = nil

local function getTreatmentSubcategory(data)
	return (data.host == Constants.Host.DeferredJoin and "DeferredJoin_" or "") .. (data.reducedMotion and "ReducedMotion_" or "") .. (data.holdEnabled and "HoldOn" or "HoldOff")
end

return {
	start = function(data)
		if v5 then
			v5.abort(abortReason.Replaced)
		end

		local v6 = nil
		local v7 = nil
		local v8 = nil
		local set = {}
		local v9 = (data.host == Constants.Host.DeferredJoin and "DeferredJoin_" or "") .. (data.reducedMotion and "ReducedMotion_" or "") .. (data.holdEnabled and "HoldOn" or "HoldOff")

		local page = data.page
		local v10 = { category = 0, page = 0, subcategory = 0 }
		v10.category = Constants.CATEGORY
		v10.page = page
		v10.subcategory = v9

		local function discard()
			local v11 = v6
			v6 = nil

			if v11 then
				return LoadingMilestoneTracker.discardMilestoneTracker(v11)
			end

			return true
		end

		local function reportOutcome(p2)
			LoadingMilestoneTelemetry.countMilestonesOutcome(v10, p2)
		end

		local function record(p2, p3)
			local v11 = if p3 then p2 .. "/" .. p3 else p2

			if v5 ~= v7 or set[v11] then
				return
			end

			set[v11] = true
			local v12 = v6

			if v12 and not LoadingMilestoneTracker.recordMilestone(v12, p2, p3) then
				v5 = nil
				local v13 = v6
				v6 = nil

				if v13 then
					LoadingMilestoneTracker.discardMilestoneTracker(v13)
				end

				local instrumentationError = outcome.InstrumentationError
				LoadingMilestoneTelemetry.countMilestonesOutcome(v10, instrumentationError)
			end
		end

		v7 = {
			dismissRequested = function(p2)
				if v5 == v7 then
					v8 = v8 or p2
				end

				local dismissRequested = milestone.DismissRequested
				local v11 = if p2 then dismissRequested .. "/" .. p2 else dismissRequested

				if v5 == v7 then
					if set[v11] then
						return
					end

					set[v11] = true
					local v12 = v6

					if v12 and not LoadingMilestoneTracker.recordMilestone(v12, dismissRequested, p2) then
						v5 = nil
						local v13 = v6
						v6 = nil

						if v13 then
							LoadingMilestoneTracker.discardMilestoneTracker(v13)
						end

						local instrumentationError = outcome.InstrumentationError
						LoadingMilestoneTelemetry.countMilestonesOutcome(v10, instrumentationError)
					end
				end
			end,
			contentVisible = function(p2)
				if not set[milestone.ScreenVisible] or set[milestone.DismissStarted] then
					return
				end

				local contentVisible = milestone.ContentVisible
				local v11 = if p2 then contentVisible .. "/" .. p2 else contentVisible

				if v5 == v7 then
					if set[v11] then
						return
					end

					set[v11] = true
					local v12 = v6

					if v12 and not LoadingMilestoneTracker.recordMilestone(v12, contentVisible, p2) then
						v5 = nil
						local v13 = v6
						v6 = nil

						if v13 then
							LoadingMilestoneTracker.discardMilestoneTracker(v13)
						end

						local instrumentationError = outcome.InstrumentationError
						LoadingMilestoneTelemetry.countMilestonesOutcome(v10, instrumentationError)
					end
				end
			end,
			record = function(p2)
				if v5 == v7 then
					if set[p2] then
						return
					end

					set[p2] = true
					local v11 = v6

					if v11 and not LoadingMilestoneTracker.recordMilestone(v11, p2, nil) then
						v5 = nil
						local v12 = v6
						v6 = nil

						if v12 then
							LoadingMilestoneTracker.discardMilestoneTracker(v12)
						end

						local instrumentationError = outcome.InstrumentationError
						LoadingMilestoneTelemetry.countMilestonesOutcome(v10, instrumentationError)
					end
				end
			end,
			complete = function()
				if v5 ~= v7 then
					return
				end

				v5 = nil
				local v11 = outcome.Completed
				local v12 = v6

				if v12 then
					local completeMilestoneTracker = LoadingMilestoneTracker.completeMilestoneTracker

					local v13 = not (v8 == nil) and set[milestone.DismissStarted] == true
					local v14 = v8
					local v15 = v9 == "HoldOn" and v8 == Constants.DismissSource.NormalReady
					local v16, v17, v18 = completeMilestoneTracker(v12, v13, v14, v15)

					if v16 and v17 ~= nil and v8 then
						v16 = LoadingMilestoneTelemetry.reportAddedWait(v10, v17, v8)
					end

					if v16 and set[milestone.ScreenVisible] and set[milestone.DismissStarted] then
						v16 = LoadingMilestoneTelemetry.reportContentVisibility(
							v10,
							set[milestone.ContentVisible .. "/" .. Constants.ContentId.Title] == true,
							set[milestone.ContentVisible .. "/" .. Constants.ContentId.Creator] == true,
							set[milestone.ContentVisible .. "/" .. Constants.ContentId.Thumbnail] == true
						)
					end

					if v16 and v18 ~= nil then
						v16 = LoadingMilestoneTelemetry.reportHoldGateHit(v10, v18)
					end

					if not v16 then
						local v19 = v6
						v6 = nil

						if v19 then
							LoadingMilestoneTracker.discardMilestoneTracker(v19)
						end

						v11 = outcome.InstrumentationError
					end
				end

				v6 = nil
				LoadingMilestoneTelemetry.countMilestonesOutcome(v10, v11)
			end,
			abort = function(p2)
				if v5 ~= v7 then
					return
				end

				v5 = nil
				local v11 = v6
				v6 = nil

				if v11 and not LoadingMilestoneTracker.discardMilestoneTracker(v11) then
					p2 = outcome.InstrumentationError
				end

				LoadingMilestoneTelemetry.countMilestonesOutcome(v10, p2)
			end
		}

		v5 = v7

		local v11 = false

		if tryMilestoneOperation(function()
			v10 = LoadingMilestoneTelemetry.getMilestoneSessionMetadata(v9, page)

			if not LoadingMilestoneTelemetry.countMilestonesStarted(v10) then
				return
			end

			local timeToInteractiveTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/TimeToInteractiveTracker").TimeToInteractiveTracker
			v6 = timeToInteractiveTracker
			v11 = LoadingMilestoneTracker.startMilestoneTracker(timeToInteractiveTracker, v10)
		end) and v11 then
			return v7
		end

		v7.abort(abortReason.InitializationFailed)
		return nil
	end,
	AbortReason = abortReason,
	Page = Constants.Page,
	Milestone = milestone,
	DismissSource = Constants.DismissSource
}
