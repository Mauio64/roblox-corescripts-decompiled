local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")

require(AbuseReportMenu.Components.Types)

local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Constants = require(AbuseReportMenu.Components.Constants)

require(AbuseReportMenu.ReportAnything.Utility.ReportAnythingAnalytics)

local AbuseReportBuilder = require(AbuseReportMenu.ReportAnything.Utility.AbuseReportBuilder)
local FFlagAddPreselectedAbuseTypeAnalytics = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAddPreselectedAbuseTypeAnalytics

local function v7(p1, p2, p3) -- line: 15
	-- upvalues: AbuseReportBuilder (copy), FFlagAddPreselectedAbuseTypeAnalytics (copy), Cryo (copy)
	local v11 = math.floor(workspace:GetServerTimeNow() * 1000)
	local n1 = 0

	if p1.menuOpenedUnixTimestampMilliseconds > 0 then
		n1 = math.floor(v11 - p1.menuOpenedUnixTimestampMilliseconds)
	end

	local v13, _ = AbuseReportBuilder.interpretAnnotations(p2)
	local t1 = {
		placeId = game.PlaceId,
		isPortraitMode = p1.isPortraitMode,
		viewportSizeX = p1.viewportSizeX,
		viewportSizeY = p1.viewportSizeY,
		timeSpentMs = n1,
		experiencePersonChangeCount = p1.experiencePersonChangeCount,
		typeofabuseChangeCount = p1.typeofabuseChangeCount,
		personChangeCount = p1.personChangeCount,
		reasonChangeCount = p1.reasonChangeCount,
		captureSceneCount = p1.captureSceneCount,
		chatLineChangeCount = p1.chatLineChangeCount,
		reasonSelection = p1.reasonSelection,
		commentAdded = p1.commentAdded,
		experiencePersonSelection = p1.experiencePersonSelection,
		annotationFinalCount = #p2.annotationPoints,
		avatarFinalCount = #v13,
		interactionType = not p1.isSubmissionCompleted and 2 or 1,
		typeofabuseSelection = p1.typeofabuseSelection,
		memoryRequirementMet = p1.memoryRequirementMet,
		preselectedAbuseSelection = if not FFlagAddPreselectedAbuseTypeAnalytics then nil else p1.preselectedAbuseSelection
	}

	return (Cryo.Dictionary.join(t1, p3))
end

return {
	forPersonReport = function(p4, p5, p6) -- line: 65
		-- upvalues: v7 (copy), Constants (copy)
		local v19 = v7(p4, p5, p6)
		local v20 = nil
		local Chat = Constants.AnalyticsAbuseMethods.Chat

		for k, v in pairs(Constants.AbuseMethodToAnalyticsMapping) do
			if k == p4.typeofabuseSelection then
				v20 = v
				Chat = v
			end
		end

		v19.typeofabuseSelection = v20
		v19.inferredTypeofabuseSelection = Chat

		return v19
	end,
	forExperienceReport = function(p7, p8, p9) -- line: 87
		-- upvalues: v7 (copy), Constants (copy)
		local v27 = v7(p7, p8, p9)

		v27.typeofabuseSelection = Constants.AnalyticsAbuseMethods.Game
		v27.inferredTypeofabuseSelection = Constants.AnalyticsAbuseMethods.Game

		return v27
	end
}
