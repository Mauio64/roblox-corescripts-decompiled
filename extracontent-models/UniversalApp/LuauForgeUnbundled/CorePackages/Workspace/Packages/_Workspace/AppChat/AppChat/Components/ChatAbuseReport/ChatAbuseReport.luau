local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local defaultTwoStepReportFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/GenericAbuseReporting").UXFlows.DefaultTwoStepReportFlow

local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("ChatAbuseReport")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local Players = game:GetService("Players")

local v6 = {
	{
		localizationKey = "Feature.ReportAbuse.Label.CategoryInappropriate",
		value = "ABUSE_TYPE_PROFANITY"
	},
	{
		localizationKey = "Feature.ReportAbuse.Label.CategoryPrivateInfo",
		value = "ABUSE_TYPE_PRIVACY_ASKING_FOR_PII"
	},
	{
		localizationKey = "Feature.ReportAbuse.Label.CategoryBullyingV2",
		value = "ABUSE_TYPE_HARASSMENT"
	},
	{
		localizationKey = "Feature.ReportAbuse.Label.CategoryDating",
		value = "ABUSE_TYPE_DATING_AND_ROMANTIC_CONTENT"
	},
	{
		localizationKey = "Feature.ReportAbuse.Label.CategoryScamming",
		value = "ABUSE_TYPE_CHEAT_AND_EXPLOITS"
	},
	{
		localizationKey = "Feature.ReportAbuse.Label.CategoryTheft",
		value = "ABUSE_TYPE_SCAMMING"
	},
	{
		localizationKey = "Feature.ReportAbuse.Label.CategoryContent",
		value = "ABUSE_TYPE_SEXUAL_CONTENT"
	},
	{
		localizationKey = "Feature.ReportAbuse.Label.CategoryThreats",
		value = "ABUSE_TYPE_REAL_LIFE_THREATS"
	},
	{
		localizationKey = "Feature.ReportAbuse.Label.CategoryOther",
		value = "ABUSE_TYPE_OTHER"
	}
}

local function getLocalPlayerUserId()
	local localPlayer = Players.LocalPlayer

	if localPlayer then
		return localPlayer.UserId
	end

	return 0
end

local function ChatAbuseReport(props)
	local v7 = useDispatch()

	local v8 = React.useCallback(function(p2, p3)
		local api = AppChatNetworking.rodux.SubmitAppChatAbuseReport.API
		local v10 = {
			comment = p3,
			reportedUserId = props.participantId,
			reportCategory = p2,
			conversationId = props.conversationId,
			submitterUserId = 0
		}
		local localPlayer = Players.LocalPlayer
		v10.submitterUserId = not localPlayer and 0 or localPlayer.UserId
		local v11, v12 = v7(api(v10)):await()

		if v11 then
			v5:info("Abuse report submitted successfully. Response: {}", (tostring(v12)))
			return v11
		end

		v5:error("Failed to submit abuse report. Response: {}", (tostring(v12)))

		return v11
	end, { v7, props.conversationId, props.participantId })

	return React.createElement(defaultTwoStepReportFlow, {
		analyticsContext = "AppChat",
		onSubmitProps = { hasNextSteps = false, onSubmit = v8 },
		onCloseProps = { hasPreviousSteps = false, onAbandon = props.onAbandon },
		onComplete = props.onComplete,
		reportCategories = v6
	})
end

return ChatAbuseReport
