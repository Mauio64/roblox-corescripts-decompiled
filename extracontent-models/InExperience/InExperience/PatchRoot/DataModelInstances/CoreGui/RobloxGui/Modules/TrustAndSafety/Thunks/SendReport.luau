game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
require(RobloxGui.Modules.VoiceChat.ReportAbuseLogic)

local parent = script.Parent.Parent
local Constants = require(parent.Resources.Constants)
local ShowToast = require(parent.Actions.ShowToast)
local OpenReportSentDialog = require(parent.Actions.OpenReportSentDialog)
local EndReportFlow = require(parent.Actions.EndReportFlow)
local ReportManager = require(parent.Utility.ReportManager)

return function(p, abusingPlayer, reason, comment, reportCategory, p2, p3)
	return function(object)
		local state = object:getState()

		if p == Constants.ReportType.Player then
			ReportManager.submitUserAbuseReport({
				reportCategory = reportCategory,
				abusingPlayer = abusingPlayer,
				reason = reason,
				comment = comment,
				beginningTimestamp = state.report.beginningTimestamp,
				sortedUserIds = state.report.sortedUserIds
			}, function()
				object:dispatch(OpenReportSentDialog(p, abusingPlayer))
			end)
		elseif p == Constants.ReportType.Place then
			ReportManager.submitPlaceAbuseReport({
				placeId = game.PlaceId,
				placeName = state.placeInfo.name,
				placeDescription = state.placeInfo.description,
				reason = reason,
				comment = comment
			}, function()
				object:dispatch(ShowToast(p2, p3))
			end)
			object:dispatch(EndReportFlow())
		end
	end
end
