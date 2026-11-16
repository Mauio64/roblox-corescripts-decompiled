local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local Constants = require(AbuseReportMenu.Components.Constants)
local ReportSuccessToast = Constants.ReportSuccessToast
local PlayerAbuseTypes = Constants.PlayerAbuseTypes

local function getToastMessageFromAbuseReason(p: string, flag: boolean?)
	local toastMessage = ReportSuccessToast.ChatGeneric

	if p == PlayerAbuseTypes.Cheating then
		toastMessage = ReportSuccessToast.Cheating
	elseif p == PlayerAbuseTypes.Username then
		toastMessage = ReportSuccessToast.BadUserName
	elseif p == PlayerAbuseTypes.Links or p == Constants.InappropriateContentAbuseReason then
		toastMessage = ReportSuccessToast.Place
	end

	if flag then
		toastMessage = ReportSuccessToast.ReportAnythingGeneric
	end

	return toastMessage
end

return getToastMessageFromAbuseReason
