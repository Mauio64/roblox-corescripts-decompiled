local function determineAppealsState(t1: {[any]: any}) -- line: 30
	local v3 = if not t1.beginDate or t1.beginDate == "" then nil else DateTime.fromIsoDate(t1.beginDate)
	local v4 = if not t1.endDate or t1.endDate == "" then nil else DateTime.fromIsoDate(t1.endDate)

	if v3 and v4 then
		local v5 = v4.UnixTimestamp - v3.UnixTimestamp > 1800

		return {
			isAppealable = v5 or t1.onAppeal ~= nil,
			shouldOpenAppealsPortal = v5
		}
	end

	return {
		isAppealable = t1.onAppeal ~= nil or t1.acknowledgeable,
		shouldOpenAppealsPortal = t1.acknowledgeable
	}
end

return determineAppealsState
