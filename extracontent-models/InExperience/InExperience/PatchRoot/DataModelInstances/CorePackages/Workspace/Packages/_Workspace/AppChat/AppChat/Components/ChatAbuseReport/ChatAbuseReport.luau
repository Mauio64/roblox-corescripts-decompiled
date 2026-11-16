local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local AbuseReporting = require(parent.AbuseReporting)
local DefaultTwoStepReportFlow = AbuseReporting.UXFlows.DefaultTwoStepReportFlow

local AppChatNetworking = require(parent.AppChatNetworking)
local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Players = game:GetService("Players")

local reportCategories = {
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
	{ localizationKey = "Feature.ReportAbuse.Label.CategoryTheft", value = "ABUSE_TYPE_SCAMMING" },
	{
		localizationKey = "Feature.ReportAbuse.Label.CategoryContent",
		value = "ABUSE_TYPE_SEXUAL_CONTENT"
	},
	{
		localizationKey = "Feature.ReportAbuse.Label.CategoryThreats",
		value = "ABUSE_TYPE_REAL_LIFE_THREATS"
	},
	{ localizationKey = "Feature.ReportAbuse.Label.CategoryOther", value = "ABUSE_TYPE_OTHER" }
}

local function getLocalPlayerUserId() -- 1 equivalent call inferred from this helper
	local localPlayer = Players.LocalPlayer
	return if localPlayer then localPlayer.UserId else 0
end

local function ChatAbuseReport(props)
	local v2 = useDispatch()

	local onSubmit = React.useCallback(function(reportCategory, comment)
		local v3, v4 = v2(AppChatNetworking.rodux.SubmitAppChatAbuseReport.API({
			comment = comment,
			reportedUserId = props.participantId,
			reportCategory = reportCategory,
			conversationId = props.conversationId,
			submitterUserId = getLocalPlayerUserId() -- inferred equivalent call
		})):await()

		if v3 then
			v:info("Abuse report submitted successfully. Response: {}", (tostring(v4)))
			return v3
		end

		v:error("Failed to submit abuse report. Response: {}", (tostring(v4)))

		return v3
	end, { v2, props.conversationId, props.participantId })

	return React.createElement(DefaultTwoStepReportFlow, {
		analyticsContext = "AppChat",
		onSubmitProps = { hasNextSteps = false, onSubmit = onSubmit },
		onCloseProps = { hasPreviousSteps = false, onAbandon = props.onAbandon },
		onComplete = props.onComplete,
		reportCategories = reportCategories
	})
end

return ChatAbuseReport
