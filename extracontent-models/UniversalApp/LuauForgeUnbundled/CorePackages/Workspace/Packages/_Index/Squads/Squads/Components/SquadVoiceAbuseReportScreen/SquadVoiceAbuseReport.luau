local HttpService = game:GetService("HttpService")

local GenericAbuseReporting = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/GenericAbuseReporting")

require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Common/ModelTypes")
local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")
local Logger = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Logger")

local react = dependencies.React
local defaultTwoStepReportFlow = GenericAbuseReporting.UXFlows.DefaultTwoStepReportFlow
local networkingSquads = dependencies.NetworkingSquads
local useDispatch = dependencies.Hooks.useDispatch

local v5 = {
	{
		localizationKey = "Feature.ReportAbuse.Label.CategoryInappropriate",
		value = "Swearing"
	},
	{
		localizationKey = "Feature.ReportAbuse.Label.CategoryBullyingV2",
		value = "Bullying"
	},
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
	local v6 = useDispatch()
	local v7 = react.useCallback(function(p2, p3)
		Logger:info(
			"Submitting abuse report. Reason: {}, Comment: {}, Data: {}",
			p2,
			p3,
			HttpService:JSONEncode(props.reportData)
		)

		local v8, v9 = v6(networkingSquads.SendSquadVoiceAbuseReport.API({
			submitterUserId = props.reportData.submitterUserId,
			abuserUserId = props.reportData.abuserUserId,
			reportBeginTimestampMs = props.reportData.reportBeginTimestampMs,
			voiceChannelId = props.reportData.voiceChannelId,
			voiceUserIds = props.reportData.voiceUserIds,
			voiceUserCount = props.reportData.voiceUserCount,
			abuseReason = p2,
			abuseComment = p3
		})):await()

		if v8 then
			Logger:info("Abuse report submitted successfully. Response: {}", HttpService:JSONEncode(v9))
			return v8
		end

		Logger:error("Failed to submit abuse report. Response: {}", HttpService:JSONEncode(v9))

		return v8
	end, { props.reportData, v6 })

	return react.createElement(defaultTwoStepReportFlow, {
		analyticsContext = "Squad",
		onSubmitProps = { hasNextSteps = false, onSubmit = v7 },
		onCloseProps = { hasPreviousSteps = false, onAbandon = props.onAbandon },
		onComplete = props.onComplete,
		reportCategories = v5
	})
end

return SquadVoiceAbuseReport
