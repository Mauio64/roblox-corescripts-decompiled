local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")

require(AbuseReportMenu.Components.Types)

local Constants = require(AbuseReportMenu.Components.Constants)
local ReportAnythingActions = Constants.ReportAnythingActions

local function reportAnythingReducer(p1, p2) -- line: 7
	-- upvalues: ReportAnythingActions (copy), Constants (copy)
	local v7 = table.clone(p1)
	local type = p2.type

	if type == ReportAnythingActions.ClearAll then
		return Constants.ReportAnythingInitialState
	end

	if type == ReportAnythingActions.ClearAnnotationFlowProperties then
		v7.annotationPoints = {}
		v7.attachCompleted = false
		v7.annotationPageSeen = false
		v7.annotationOptionSeen = false

		return v7
	end

	if type == ReportAnythingActions.SetScreenshotId then
		v7.screenshotId = p2.screenshotId

		return v7
	end

	if type == ReportAnythingActions.SetScreenshotContentId then
		v7.screenshotContentId = p2.screenshotContentId

		return v7
	end

	if type == ReportAnythingActions.SetAnnotationPoints then
		v7.annotationPoints = p2.annotationPoints
		v7.annotationPageSeen = true
		v7.annotationOptionSeen = true

		return v7
	end

	if type == ReportAnythingActions.SetIdentificationResults then
		v7.identificationResults = p2.identificationResults

		return v7
	end

	if type == ReportAnythingActions.CompleteAttachment then
		v7.attachCompleted = true

		return v7
	end

	if type == ReportAnythingActions.SetAnnotationCircleRadius then
		v7.annotationCircleRadius = p2.radius

		return v7
	end

	if type == ReportAnythingActions.SetAnnotationAreaDimensions then
		v7.annotationAreaWidth = p2.width
		v7.annotationAreaHeight = p2.height

		return v7
	end

	if type == ReportAnythingActions.SetAnnotationOptionSeen then
		v7.annotationOptionSeen = true
	end

	return v7
end

return reportAnythingReducer
