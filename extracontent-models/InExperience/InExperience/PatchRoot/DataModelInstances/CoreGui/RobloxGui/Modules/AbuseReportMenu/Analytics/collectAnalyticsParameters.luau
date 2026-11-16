local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
require(AbuseReportMenu.Components.Types)
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Constants = require(AbuseReportMenu.Components.Constants)
require(AbuseReportMenu.ReportAnything.Utility.ReportAnythingAnalytics)
local AbuseReportBuilder = require(AbuseReportMenu.ReportAnything.Utility.AbuseReportBuilder)

local function fn(data, p, p2)
	local v = math.floor(workspace:GetServerTimeNow() * 1000)

	local timeSpentMs = not (data.menuOpenedUnixTimestampMilliseconds > 0) and 0
		or math.floor(v - data.menuOpenedUnixTimestampMilliseconds)

	local interpretAnnotations, _ = AbuseReportBuilder.interpretAnnotations(p)

	local v2 = {
		placeId = game.PlaceId,
		isPortraitMode = data.isPortraitMode,
		viewportSizeX = data.viewportSizeX,
		viewportSizeY = data.viewportSizeY,
		timeSpentMs = timeSpentMs,
		experiencePersonChangeCount = data.experiencePersonChangeCount,
		typeofabuseChangeCount = data.typeofabuseChangeCount,
		personChangeCount = data.personChangeCount,
		reasonChangeCount = data.reasonChangeCount,
		captureSceneCount = data.captureSceneCount,
		reasonSelection = data.reasonSelection,
		commentAdded = data.commentAdded,
		experiencePersonSelection = data.experiencePersonSelection,
		annotationFinalCount = #p.annotationPoints,
		avatarFinalCount = #interpretAnnotations,
		interactionType = data.isSubmissionCompleted and 1 or 2,
		typeofabuseSelection = data.typeofabuseSelection,
		memoryRequirementMet = data.memoryRequirementMet,
		preselectedAbuseSelection = data.preselectedAbuseSelection
	}

	return (Cryo.Dictionary.join(v2, p2))
end

local CollectAnalyticsParameters = {}

function CollectAnalyticsParameters.forPersonReport(p, p2, p3)
	local v = fn(p, p2, p3)

	local inferredTypeofabuseSelection = Constants.AnalyticsAbuseMethods.Chat
	local typeofabuseSelection = nil

	for k, v2 in pairs(Constants.AbuseMethodToAnalyticsMapping) do
		if k ~= p.typeofabuseSelection then
			continue
		end

		inferredTypeofabuseSelection = v2
		typeofabuseSelection = inferredTypeofabuseSelection
	end

	v.typeofabuseSelection = typeofabuseSelection
	v.inferredTypeofabuseSelection = inferredTypeofabuseSelection

	return v
end

function CollectAnalyticsParameters.forExperienceReport(p, p2, p3)
	local v = fn(p, p2, p3)

	v.typeofabuseSelection = Constants.AnalyticsAbuseMethods.Game
	v.inferredTypeofabuseSelection = Constants.AnalyticsAbuseMethods.Game

	return v
end

return CollectAnalyticsParameters
