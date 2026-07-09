local Squads = script:FindFirstAncestor("Squads")
local HttpService = game:GetService("HttpService")
local SquadsParent = Squads.Parent
local AbuseReporting = require(SquadsParent.AbuseReporting)

require(Squads.Common.ModelTypes)

local dependencies = require(Squads.dependencies)
local Logger = require(Squads.Logger)
local React = dependencies.React
local DefaultTwoStepReportFlow = AbuseReporting.UXFlows.DefaultTwoStepReportFlow
local NetworkingSquads = dependencies.NetworkingSquads
local useDispatch = dependencies.Hooks.useDispatch
local t1 = {
	{
		localizationKey = "Feature.ReportAbuse.Label.CategoryInappropriate",
		value = "Swearing"
	},
	{
		localizationKey = "Feature.ReportAbuse.Label.CategoryBullyingV2",
		value = "Bullying"
	},
	{
		localizationKey = "Feature.ReportAbuse.Label.CategoryTheft",
		value = "Scamming"
	},
	{
		localizationKey = "Feature.ReportAbuse.Label.CategoryDating",
		value = "Dating"
	},
	{
		localizationKey = "Feature.ReportAbuse.Label.CategoryScamming",
		value = "Cheating/Exploiting"
	},
	{
		localizationKey = "Feature.ReportAbuse.Label.CategoryPrivateInfo",
		value = "Personal Question"
	}
}

local function SquadVoiceAbuseReport(t2: {[any]: any}) -- line: 33
	-- upvalues: useDispatch (copy), React (copy), Logger (copy), HttpService (copy), NetworkingSquads (copy), DefaultTwoStepReportFlow (copy), t1 (copy)
	local v14 = useDispatch()
	local v15 = React.useCallback(function(p1, p2) -- line: 35
		-- upvalues: Logger (copy), HttpService (copy), t2 (copy), v14 (copy), NetworkingSquads (copy)
		Logger:info("Submitting abuse report. Reason: {}, Comment: {}, Data: {}", p1, p2, HttpService:JSONEncode(t2.reportData))

		local v18, v19 = v14(NetworkingSquads.SendSquadVoiceAbuseReport.API({
			submitterUserId = t2.reportData.submitterUserId,
			abuserUserId = t2.reportData.abuserUserId,
			reportBeginTimestampMs = t2.reportData.reportBeginTimestampMs,
			voiceChannelId = t2.reportData.voiceChannelId,
			voiceUserIds = t2.reportData.voiceUserIds,
			voiceUserCount = t2.reportData.voiceUserCount,
			abuseReason = p1,
			abuseComment = p2
		})):await()

		if v18 then
			Logger:info("Abuse report submitted successfully. Response: {}", HttpService:JSONEncode(v19))

			return v18
		end

		Logger:error("Failed to submit abuse report. Response: {}", HttpService:JSONEncode(v19))

		return v18
	end, {
		t2.reportData,
		v14
	})

	return React.createElement(DefaultTwoStepReportFlow, {
		analyticsContext = "Squad",
		onSubmitProps = {
			hasNextSteps = false,
			onSubmit = v15
		},
		onCloseProps = {
			hasPreviousSteps = false,
			onAbandon = t2.onAbandon
		},
		onComplete = t2.onComplete,
		reportCategories = t1
	})
end

return SquadVoiceAbuseReport
