local Squads = script:FindFirstAncestor("Squads")
local HttpService = game:GetService("HttpService")

local parent = Squads.Parent
local AbuseReporting = require(parent.AbuseReporting)

require(Squads.Common.ModelTypes)
local dependencies = require(Squads.dependencies)
local Logger = require(Squads.Logger)

local react = dependencies.React
local DefaultTwoStepReportFlow = AbuseReporting.UXFlows.DefaultTwoStepReportFlow
local networkingSquads = dependencies.NetworkingSquads
local useDispatch = dependencies.Hooks.useDispatch

local reportCategories = {
	{ localizationKey = "Feature.ReportAbuse.Label.CategoryInappropriate", value = "Swearing" },
	{ localizationKey = "Feature.ReportAbuse.Label.CategoryBullyingV2", value = "Bullying" },
	{ localizationKey = "Feature.ReportAbuse.Label.CategoryTheft", value = "Scamming" },
	{ localizationKey = "Feature.ReportAbuse.Label.CategoryDating", value = "Dating" },
	{
		localizationKey = "Feature.ReportAbuse.Label.CategoryScamming",
		value = "Cheating/Exploiting"
	},
	{
		localizationKey = "Feature.ReportAbuse.Label.CategoryPrivateInfo",
		value = "Personal Question"
	}
}

local function SquadVoiceAbuseReport(props)
	local v = useDispatch()
	local onSubmit = react.useCallback(function(abuseReason, abuseComment)
		Logger:info(
			"Submitting abuse report. Reason: {}, Comment: {}, Data: {}",
			abuseReason,
			abuseComment,
			HttpService:JSONEncode(props.reportData)
		)

		local v2, v3 = v(networkingSquads.SendSquadVoiceAbuseReport.API({
			submitterUserId = props.reportData.submitterUserId,
			abuserUserId = props.reportData.abuserUserId,
			reportBeginTimestampMs = props.reportData.reportBeginTimestampMs,
			voiceChannelId = props.reportData.voiceChannelId,
			voiceUserIds = props.reportData.voiceUserIds,
			voiceUserCount = props.reportData.voiceUserCount,
			abuseReason = abuseReason,
			abuseComment = abuseComment
		})):await()

		if v2 then
			Logger:info("Abuse report submitted successfully. Response: {}", HttpService:JSONEncode(v3))
			return v2
		end

		Logger:error("Failed to submit abuse report. Response: {}", HttpService:JSONEncode(v3))

		return v2
	end, { props.reportData, v })

	return react.createElement(DefaultTwoStepReportFlow, {
		analyticsContext = "Squad",
		onSubmitProps = { hasNextSteps = false, onSubmit = onSubmit },
		onCloseProps = { hasPreviousSteps = false, onAbandon = props.onAbandon },
		onComplete = props.onComplete,
		reportCategories = reportCategories
	})
end

return SquadVoiceAbuseReport
