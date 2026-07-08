local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")

require(AbuseReportMenu.Components.Types)

local Constants = require(AbuseReportMenu.Components.Constants)
local Cryo = require(CorePackages.Packages.Cryo)
local AnalyticsActions = Constants.AnalyticsActions
local FFlagInGameMenuAddChatLineReporting = require(CorePackages.Workspace.Packages.SharedFlags).FFlagInGameMenuAddChatLineReporting
local FFlagAddPreselectedAbuseTypeAnalytics = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAddPreselectedAbuseTypeAnalytics
local t1 = {
	typeofabuseSelection = Cryo.None,
	reasonSelection = Cryo.None
}

local function analyticsReducer(p1, p2) -- line: 20
	-- upvalues: AnalyticsActions (copy), Constants (copy), FFlagInGameMenuAddChatLineReporting (copy), FFlagAddPreselectedAbuseTypeAnalytics (copy), Cryo (copy), t1 (copy)
	local v12 = table.clone(p1)
	local type = p2.type

	if type == AnalyticsActions.Reset then
		local menuEverShown = v12.menuEverShown
		local AnalyticsInitialState = Constants.AnalyticsInitialState

		AnalyticsInitialState.menuEverShown = menuEverShown

		return AnalyticsInitialState
	end

	if type == AnalyticsActions.SetMenuOpenedTimestamp then
		v12.menuEverShown = true
		v12.menuOpenedUnixTimestampMilliseconds = p2.timestamp

		return v12
	end

	if type == AnalyticsActions.IncrementExperiencePersonChanged then
		v12.experiencePersonChangeCount = v12.experiencePersonChangeCount + 1

		return v12
	end

	if type == AnalyticsActions.IncrementTypeofabuseChanged then
		v12.typeofabuseChangeCount = v12.typeofabuseChangeCount + 1

		return v12
	end

	if type == AnalyticsActions.IncrementPersonChanged then
		v12.personChangeCount = v12.personChangeCount + 1

		return v12
	end

	if type == AnalyticsActions.IncrementReasonChanged then
		v12.reasonChangeCount = v12.reasonChangeCount + 1

		return v12
	end

	if type == AnalyticsActions.IncrementCaptureScene then
		v12.captureSceneCount = v12.captureSceneCount + 1

		return v12
	end

	if FFlagInGameMenuAddChatLineReporting and type == AnalyticsActions.IncrementChatLineChanged then
		v12.chatLineChangeCount = v12.chatLineChangeCount + 1

		return v12
	end

	if type == AnalyticsActions.SetViewportInformation then
		v12.viewportSizeX = p2.viewportSizeX
		v12.viewportSizeY = p2.viewportSizeY
		v12.isPortraitMode = p2.viewportSizeX < p2.viewportSizeY

		return v12
	end

	if type == AnalyticsActions.SetMemoryRequirementMet then
		v12.memoryRequirementMet = p2.memoryRequirementMet

		return v12
	end

	if type == AnalyticsActions.SetSubmissionCompleted then
		v12.isSubmissionCompleted = true

		return v12
	end

	if type == AnalyticsActions.SetTypeOfAbuseSelection then
		v12.typeofabuseSelection = p2.selection

		return v12
	end

	if FFlagAddPreselectedAbuseTypeAnalytics and type == AnalyticsActions.SetPreselectedAbuseSelection then
		v12.preselectedAbuseSelection = p2.selection

		return v12
	end

	if type == AnalyticsActions.SetReasonSelection then
		v12.reasonSelection = p2.selection

		return v12
	end

	if type == AnalyticsActions.SetCommentAdded then
		v12.commentAdded = p2.commentAdded

		return v12
	end

	if type == AnalyticsActions.SwitchToExperienceInitialSelections then
		return (Cryo.Dictionary.join(v12, t1, Constants.AnalyticsExpeirenceInitialSelections))
	end

	if type == AnalyticsActions.SwitchToPersonInitialSelections then
		v12 = Cryo.Dictionary.join(v12, t1, Constants.AnalyticsPersonInitialSelections)
	end

	return v12
end

return analyticsReducer
