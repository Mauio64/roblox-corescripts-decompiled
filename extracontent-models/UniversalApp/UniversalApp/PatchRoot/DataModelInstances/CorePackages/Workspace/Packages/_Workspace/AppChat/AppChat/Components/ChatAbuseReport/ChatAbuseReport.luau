local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local DefaultTwoStepReportFlow = require(AppChatParent.AbuseReporting).UXFlows.DefaultTwoStepReportFlow
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local FFlagAppChatUseAbuseReportingApi = require(AppChat.Flags).FFlagAppChatUseAbuseReportingApi
local v7 = require(AppChat.Logger):new(script.Name)
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local Players = game:GetService("Players")
local useChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext).useChatPlacementContext
local t1 = {
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

local function getLocalPlayerUserId() -- line: 48
	-- upvalues: Players (copy)
	local LocalPlayer = Players.LocalPlayer

	if LocalPlayer then
		return LocalPlayer.UserId
	end

	return 0
end
local function ChatAbuseReport(t2: {[any]: any}) -- line: 53
	-- upvalues: useDispatch (copy), useChatPlacementContext (copy), React (copy), FFlagAppChatUseAbuseReportingApi (copy), AppChatNetworking (copy), Players (copy), v7 (copy), DefaultTwoStepReportFlow (copy), t1 (copy)
	local v16 = useDispatch()
	local chatPlacement = useChatPlacementContext().chatPlacement
	local v18 = React.useCallback(function(p1, p2) -- line: 58
		-- upvalues: t2 (copy), chatPlacement (copy), FFlagAppChatUseAbuseReportingApi (copy), v16 (copy), AppChatNetworking (copy), Players (copy), v7 (copy)
		local t3 = {
			comment = p2,
			reportedUserId = t2.participantId,
			reportCategory = p1,
			conversationId = t2.conversationId,
			entryPoint = chatPlacement
		}
		local v26, v27

		if FFlagAppChatUseAbuseReportingApi then
			local v22 = v16
			local API = AppChatNetworking.rodux.SubmitAppChatAbuseReport.API
			local t4 = {
				comment = t3.comment,
				reportedUserId = t3.reportedUserId,
				reportCategory = t3.reportCategory,
				conversationId = t3.conversationId
			}
			local LocalPlayer = Players.LocalPlayer

			t4.submitterUserId = not LocalPlayer and 0 or LocalPlayer.UserId
			v26, v27 = v22(API(t4)):await()
		else
			v26, v27 = v16(AppChatNetworking.rodux.CreateChatAbuseReport.API(t3)):await()
		end

		if v26 then
			v7:info("Abuse report submitted successfully. Response: {}", (tostring(v27)))

			return v26
		end

		v7:error("Failed to submit abuse report. Response: {}", (tostring(v27)))

		return v26
	end, {
		v16,
		t2.conversationId,
		t2.participantId,
		chatPlacement
	})

	return React.createElement(DefaultTwoStepReportFlow, {
		analyticsContext = "AppChat",
		onSubmitProps = {
			hasNextSteps = false,
			onSubmit = v18
		},
		onCloseProps = {
			hasPreviousSteps = false,
			onAbandon = t2.onAbandon
		},
		onComplete = t2.onComplete,
		reportCategories = t1
	})
end

return ChatAbuseReport
