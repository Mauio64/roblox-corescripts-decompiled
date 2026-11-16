local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
require(AbuseReportMenu.Components.Types)
local Constants = require(AbuseReportMenu.Components.Constants)
local Cryo = require(CorePackages.Packages.Cryo)

local AnalyticsActions = Constants.AnalyticsActions

local v = { typeofabuseSelection = Cryo.None, reasonSelection = Cryo.None }

local function analyticsReducer(p, data)
	local clone = table.clone(p)
	local kind = data.type

	if kind == AnalyticsActions.Reset then
		local menuEverShown = clone.menuEverShown
		local analyticsInitialState = Constants.AnalyticsInitialState
		analyticsInitialState.menuEverShown = menuEverShown
		return analyticsInitialState
	end

	if kind == AnalyticsActions.SetMenuOpenedTimestamp then
		clone.menuEverShown = true
		clone.menuOpenedUnixTimestampMilliseconds = data.timestamp
	else
		if kind == AnalyticsActions.IncrementExperiencePersonChanged then
			clone.experiencePersonChangeCount += 1
			return clone
		end

		if kind == AnalyticsActions.IncrementTypeofabuseChanged then
			clone.typeofabuseChangeCount += 1
			return clone
		end

		if kind == AnalyticsActions.IncrementPersonChanged then
			clone.personChangeCount += 1
			return clone
		end

		if kind == AnalyticsActions.IncrementReasonChanged then
			clone.reasonChangeCount += 1
			return clone
		end

		if kind == AnalyticsActions.IncrementCaptureScene then
			clone.captureSceneCount += 1
			return clone
		end

		if kind == AnalyticsActions.SetViewportInformation then
			clone.viewportSizeX = data.viewportSizeX
			clone.viewportSizeY = data.viewportSizeY
			clone.isPortraitMode = data.viewportSizeX < data.viewportSizeY
		else
			if kind == AnalyticsActions.SetMemoryRequirementMet then
				clone.memoryRequirementMet = data.memoryRequirementMet
				return clone
			end

			if kind == AnalyticsActions.SetSubmissionCompleted then
				clone.isSubmissionCompleted = true
				return clone
			end

			if kind == AnalyticsActions.SetTypeOfAbuseSelection then
				clone.typeofabuseSelection = data.selection
				return clone
			end

			if kind == AnalyticsActions.SetPreselectedAbuseSelection then
				clone.preselectedAbuseSelection = data.selection
				return clone
			end

			if kind == AnalyticsActions.SetReasonSelection then
				clone.reasonSelection = data.selection
				return clone
			end

			if kind == AnalyticsActions.SetCommentAdded then
				clone.commentAdded = data.commentAdded
				return clone
			end

			if kind == AnalyticsActions.SwitchToExperienceInitialSelections then
				return (Cryo.Dictionary.join(clone, v, Constants.AnalyticsExpeirenceInitialSelections))
			end

			if kind == AnalyticsActions.SwitchToPersonInitialSelections then
				clone = Cryo.Dictionary.join(clone, v, Constants.AnalyticsPersonInitialSelections)
			end
		end
	end

	return clone
end

return analyticsReducer
