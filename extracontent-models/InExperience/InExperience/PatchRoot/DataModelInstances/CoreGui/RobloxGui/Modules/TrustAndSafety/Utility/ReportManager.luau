local CoreGui = game:GetService("CoreGui")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")

require(CorePackages.Packages.Dash)

local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default
local createVoiceAbuseReportRequest = require(RobloxGui.Modules.VoiceChat.createVoiceAbuseReportRequest)
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local Url = CoreScriptsCommon.Url

local parent = script.Parent.Parent
local Constants = require(parent.Resources.Constants)
local SendAnalytics = require(parent.Utility.SendAnalytics)
local SessionUtility = require(parent.Utility.SessionUtility)

function sendAnalytics(reportType: string, p: number, reason: string, abuseVector: string?)
	SendAnalytics(reportType, Constants.Analytics.ReportSubmittedName, {
		reportType = reportType,
		reportedEntityId = tostring(p),
		reportSource = Constants.Analytics.ReportSourceInGame,
		reason = reason,
		abuseVector = abuseVector
	})
end

function getAbuseVectorFromReportCategory(p: string): string
	if p == Constants.Category.Voice then
		return "voice"
	end

	return if p == Constants.Category.Text then "chat" else "other"
end

function submitUserAbuseReport(data, callback)
	local v = data.reportCategory == Constants.Category.Voice
	local localPlayer = Players.LocalPlayer

	if localPlayer then
		pcall(function()
			coroutine.wrap(function()
				local abuseVectorFromReportCategory = getAbuseVectorFromReportCategory(data.reportCategory)

				if v then
					local voiceAbuseReportRequest = createVoiceAbuseReportRequest(Players, default, {
						localUserId = localPlayer.UserId,
						abuserUserId = data.abusingPlayer.UserId,
						abuseComment = data.comment,
						abuseReason = data.reason,
						inExpMenuOpenedUnixMilli = math.floor(data.beginningTimestamp * 1000),
						sortedPlayerListUserIds = data.sortedUserIds,
						abuseVector = abuseVectorFromReportCategory
					})

					if game:GetEngineFeature("AbuseReportV3") then
						Players:ReportAbuseV3(localPlayer, voiceAbuseReportRequest)
					else
						HttpRbxApiService:PostAsyncFullUrl(
							Url.APIS_URL .. "/abuse-reporting/v2/abuse-report",
							voiceAbuseReportRequest
						)
					end
				else
					Players:ReportAbuse(data.abusingPlayer, data.reason, data.comment)
				end

				sendAnalytics(
					Constants.Analytics.ReportTypeUser,
					data.abusingPlayer.UserId,
					data.reason,
					abuseVectorFromReportCategory
				)
				SessionUtility.endAbuseReportSession()

				if callback then
					callback()
				end
			end)()
		end)
	end
end

function submitPlaceAbuseReport(data, callback)
	if data.placeName ~= "" then
		coroutine.wrap(function()
			if not RunService:IsStudio() then
				local v = string.format(
					"User Report: \n    %s \nPlace Title: \n    %s \nPlaceId: \n    %s \nPlace Description: \n    %s \n",
					data.comment,
					data.placeName,
					tostring(data.placeId),
					data.placeDescription
				)

				Players:ReportAbuse(nil, data.reason, v)
			end

			sendAnalytics(Constants.Analytics.ReportTypeGame, data.placeId, data.reason)
			SessionUtility.endAbuseReportSession()

			if callback then
				callback()
			end
		end)()
	end
end

return {
	submitUserAbuseReport = submitUserAbuseReport,
	submitPlaceAbuseReport = submitPlaceAbuseReport
}
