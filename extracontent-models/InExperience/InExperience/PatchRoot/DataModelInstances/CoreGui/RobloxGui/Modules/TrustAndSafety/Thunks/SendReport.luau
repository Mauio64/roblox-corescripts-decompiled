game:GetService("Players")

local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")

require(RobloxGui.Modules.VoiceChat.ReportAbuseLogic)

local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Resources.Constants)
local ShowToast = require(ParentParent.Actions.ShowToast)
local OpenReportSentDialog = require(ParentParent.Actions.OpenReportSentDialog)
local EndReportFlow = require(ParentParent.Actions.EndReportFlow)
local ReportManager = require(ParentParent.Utility.ReportManager)

return function(p1, p2, p3, p4, p5, p6, p7) -- line: 15
	-- upvalues: Constants (copy), ReportManager (copy), OpenReportSentDialog (copy), ShowToast (copy), EndReportFlow (copy)
	return function(p8) -- line: 16
		-- upvalues: p1 (copy), Constants (copy), ReportManager (copy), p5 (copy), p2 (copy), p3 (copy), p4 (copy), OpenReportSentDialog (copy), ShowToast (copy), p6 (copy), p7 (copy), EndReportFlow (copy)
		local v16 = p8:getState()

		if p1 == Constants.ReportType.Player then
			ReportManager.submitUserAbuseReport({
				reportCategory = p5,
				abusingPlayer = p2,
				reason = p3,
				comment = p4,
				beginningTimestamp = v16.report.beginningTimestamp,
				sortedUserIds = v16.report.sortedUserIds
			}, function() -- line: 26
				-- upvalues: p8 (copy), OpenReportSentDialog (copy), p1 (copy), p2 (copy)
				p8:dispatch(OpenReportSentDialog(p1, p2))
			end)

			return
		end

		if p1 == Constants.ReportType.Place then
			ReportManager.submitPlaceAbuseReport({
				placeId = game.PlaceId,
				placeName = v16.placeInfo.name,
				placeDescription = v16.placeInfo.description,
				reason = p3,
				comment = p4
			}, function() -- line: 36
				-- upvalues: p8 (copy), ShowToast (copy), p6 (copy), p7 (copy)
				p8:dispatch(ShowToast(p6, p7))
			end)
			p8:dispatch(EndReportFlow())
		end
	end
end
