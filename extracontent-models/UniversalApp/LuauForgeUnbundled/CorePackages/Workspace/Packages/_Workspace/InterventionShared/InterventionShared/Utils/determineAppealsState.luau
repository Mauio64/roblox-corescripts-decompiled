local FFlagUFRAppealsAndModNoteFix = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Flags/FFlagUFRAppealsAndModNoteFix")

local function determineAppealsState(data)
	local dateTime

	if data.beginDate and data.beginDate ~= "" then
		dateTime = DateTime.fromIsoDate(data.beginDate)
	end

	local dateTime2 = if data.endDate and data.endDate ~= "" then DateTime.fromIsoDate(data.endDate) else nil

	if dateTime and dateTime2 then
		local v5 = dateTime2.UnixTimestamp - dateTime.UnixTimestamp > 1800
			or FFlagUFRAppealsAndModNoteFix and data.acknowledgeable
		return {
			isAppealable = v5 or data.onAppeal ~= nil,
			shouldOpenAppealsPortal = v5
		}
	end

	return {
		isAppealable = data.onAppeal ~= nil or data.acknowledgeable,
		shouldOpenAppealsPortal = data.acknowledgeable
	}
end

return determineAppealsState
