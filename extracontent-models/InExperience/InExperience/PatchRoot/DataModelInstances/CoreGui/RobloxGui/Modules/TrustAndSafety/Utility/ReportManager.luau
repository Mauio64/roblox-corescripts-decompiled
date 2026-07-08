local CoreGui = game:GetService("CoreGui")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")

require(CorePackages.Packages.Dash)

local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local createVoiceAbuseReportRequest = require(RobloxGui.Modules.VoiceChat.createVoiceAbuseReportRequest)
local Url = require(CorePackages.Workspace.Packages.CoreScriptsCommon).Url
local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Resources.Constants)
local SendAnalytics = require(ParentParent.Utility.SendAnalytics)
local SessionUtility = require(ParentParent.Utility.SessionUtility)

function sendAnalytics(s1: string, n1: number, s2: string, s3: string?) -- line: 36
	-- upvalues: SendAnalytics (copy), Constants (copy)
	SendAnalytics(s1, Constants.Analytics.ReportSubmittedName, {
		reportType = s1,
		reportedEntityId = tostring(n1),
		reportSource = Constants.Analytics.ReportSourceInGame,
		reason = s2,
		abuseVector = s3
	})
end
function getAbuseVectorFromReportCategory(s4: string) -- line: 50
	-- upvalues: Constants (copy)
	if s4 == Constants.Category.Voice then
		return "voice"
	end

	if s4 == Constants.Category.Text then
		return "chat"
	end

	return "other"
end
function submitUserAbuseReport(t1: {[any]: any}, p1) -- line: 59
	-- upvalues: Constants (copy), Players (copy), createVoiceAbuseReportRequest (copy), default (copy), Url (copy), HttpRbxApiService (copy), SessionUtility (copy)
	local v21 = t1.reportCategory == Constants.Category.Voice
	local LocalPlayer = Players.LocalPlayer

	if LocalPlayer then
		pcall(function() -- line: 63
			-- upvalues: t1 (copy), v21 (copy), createVoiceAbuseReportRequest (copy), Players (copy), default (copy), LocalPlayer (copy), Url (copy), HttpRbxApiService (copy), Constants (copy), SessionUtility (copy), p1 (copy)
			coroutine.wrap(function() -- line: 64
				-- upvalues: t1 (copy), v21 (copy), createVoiceAbuseReportRequest (copy), Players (copy), default (copy), LocalPlayer (copy), Url (copy), HttpRbxApiService (copy), Constants (copy), SessionUtility (copy), p1 (copy)
				local v26 = getAbuseVectorFromReportCategory(t1.reportCategory)

				if v21 then
					local v27 = createVoiceAbuseReportRequest(Players, default, {
						localUserId = LocalPlayer.UserId,
						abuserUserId = t1.abusingPlayer.UserId,
						abuseComment = t1.comment,
						abuseReason = t1.reason,
						inExpMenuOpenedUnixMilli = math.floor(t1.beginningTimestamp * 1000),
						sortedPlayerListUserIds = t1.sortedUserIds,
						abuseVector = v26
					})

					if game:GetEngineFeature("AbuseReportV3") then
						Players:ReportAbuseV3(LocalPlayer, v27)
					else
						local v28 = Url.APIS_URL .. "/abuse-reporting/v2/abuse-report"

						HttpRbxApiService:PostAsyncFullUrl(v28, v27)
					end
				else
					Players:ReportAbuse(t1.abusingPlayer, t1.reason, t1.comment)
				end

				sendAnalytics(Constants.Analytics.ReportTypeUser, t1.abusingPlayer.UserId, t1.reason, v26)
				SessionUtility.endAbuseReportSession()

				if p1 then
					p1()
				end
			end)()
		end)
	end
end
function submitPlaceAbuseReport(t2: {[any]: any}, p2) -- line: 99
	-- upvalues: RunService (copy), Players (copy), Constants (copy), SessionUtility (copy)
	if t2.placeName ~= "" then
		coroutine.wrap(function() -- line: 101
			-- upvalues: RunService (copy), t2 (copy), Players (copy), Constants (copy), SessionUtility (copy), p2 (copy)
			if not RunService:IsStudio() then
				local v25 = string.format("User Report: \n    %s \nPlace Title: \n    %s \nPlaceId: \n    %s \nPlace Description: \n    %s \n", t2.comment, t2.placeName, tostring(t2.placeId), t2.placeDescription)

				Players:ReportAbuse(nil, t2.reason, v25)
			end

			sendAnalytics(Constants.Analytics.ReportTypeGame, t2.placeId, t2.reason)
			SessionUtility.endAbuseReportSession()

			if p2 then
				p2()
			end
		end)()
	end
end

return {
	submitUserAbuseReport = submitUserAbuseReport,
	submitPlaceAbuseReport = submitPlaceAbuseReport
}
