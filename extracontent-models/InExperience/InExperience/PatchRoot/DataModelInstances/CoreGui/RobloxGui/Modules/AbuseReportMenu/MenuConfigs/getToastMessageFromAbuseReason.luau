local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local Constants = require(AbuseReportMenu.Components.Constants)
local ReportSuccessToast = Constants.ReportSuccessToast
local PlayerAbuseTypes = Constants.PlayerAbuseTypes

local function getToastMessageFromAbuseReason(s1: string, b1: boolean?) -- line: 6
	-- upvalues: ReportSuccessToast (copy), PlayerAbuseTypes (copy), Constants (copy)
	local ChatGeneric = ReportSuccessToast.ChatGeneric

	if s1 == PlayerAbuseTypes.Cheating then
		ChatGeneric = ReportSuccessToast.Cheating
	elseif s1 == PlayerAbuseTypes.Username then
		ChatGeneric = ReportSuccessToast.BadUserName
	elseif s1 == PlayerAbuseTypes.Links or s1 == Constants.InappropriateContentAbuseReason then
		ChatGeneric = ReportSuccessToast.Place
	end

	if b1 then
		ChatGeneric = ReportSuccessToast.ReportAnythingGeneric
	end

	return ChatGeneric
end

return getToastMessageFromAbuseReason
