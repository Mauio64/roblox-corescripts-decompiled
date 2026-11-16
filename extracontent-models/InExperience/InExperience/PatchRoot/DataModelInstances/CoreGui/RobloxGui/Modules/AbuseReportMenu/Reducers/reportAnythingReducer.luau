local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
require(AbuseReportMenu.Components.Types)
local Constants = require(AbuseReportMenu.Components.Constants)

local ReportAnythingActions = Constants.ReportAnythingActions

local function reportAnythingReducer(p, data)
	local clone = table.clone(p)
	local kind = data.type

	if kind == ReportAnythingActions.ClearAll then
		return Constants.ReportAnythingInitialState
	end

	if kind == ReportAnythingActions.ClearAnnotationFlowProperties then
		clone.annotationPoints = {}
		clone.attachCompleted = false
		clone.annotationPageSeen = false
		clone.annotationOptionSeen = false
	else
		if kind == ReportAnythingActions.SetScreenshotId then
			clone.screenshotId = data.screenshotId
			return clone
		end

		if kind == ReportAnythingActions.SetScreenshotContentId then
			clone.screenshotContentId = data.screenshotContentId
			return clone
		end

		if kind == ReportAnythingActions.SetAnnotationPoints then
			clone.annotationPoints = data.annotationPoints
			clone.annotationPageSeen = true
			clone.annotationOptionSeen = true
		else
			if kind == ReportAnythingActions.SetIdentificationResults then
				clone.identificationResults = data.identificationResults
				return clone
			end

			if kind == ReportAnythingActions.CompleteAttachment then
				clone.attachCompleted = true
				return clone
			end

			if kind == ReportAnythingActions.SetAnnotationCircleRadius then
				clone.annotationCircleRadius = data.radius
				return clone
			end

			if kind == ReportAnythingActions.SetAnnotationAreaDimensions then
				clone.annotationAreaWidth = data.width
				clone.annotationAreaHeight = data.height
			elseif kind == ReportAnythingActions.SetAnnotationOptionSeen then
				clone.annotationOptionSeen = true
			end
		end
	end

	return clone
end

return reportAnythingReducer
