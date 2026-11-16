local FFlagUFRAppealsAndModNoteFix = require(script.Parent.Parent.Flags.FFlagUFRAppealsAndModNoteFix)

local function determineAppealsState(data)
	local dateTime

	if data.beginDate and data.beginDate ~= "" then
		dateTime = DateTime.fromIsoDate(data.beginDate)
	end

	local dateTime2

	if data.endDate and data.endDate ~= "" then
		dateTime2 = DateTime.fromIsoDate(data.endDate)
	end

	if dateTime and dateTime2 then
		local shouldOpenAppealsPortal = dateTime2.UnixTimestamp - dateTime.UnixTimestamp > 1800
			or FFlagUFRAppealsAndModNoteFix and data.acknowledgeable
		return {
			isAppealable = shouldOpenAppealsPortal or data.onAppeal ~= nil,
			shouldOpenAppealsPortal = shouldOpenAppealsPortal
		}
	end

	return {
		isAppealable = data.onAppeal ~= nil or data.acknowledgeable,
		shouldOpenAppealsPortal = data.acknowledgeable
	}
end

return determineAppealsState
