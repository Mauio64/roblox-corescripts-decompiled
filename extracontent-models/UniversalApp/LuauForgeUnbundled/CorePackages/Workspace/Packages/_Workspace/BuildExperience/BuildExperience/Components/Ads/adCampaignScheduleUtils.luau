return {
	MS_PER_DAY = 86400000,
	toStartMs = function(value)
		if type(value) ~= "string" then
			return 0
		end

		local success, result = pcall(DateTime.fromIsoDate, value)

		if success and result ~= nil then
			return result.UnixTimestampMillis
		end

		return 0
	end,
	campaignEndMs = function(p2, p3)
		return p2 + math.max(0, p3 - 1) * 86400000
	end,
	campaignEndExclusiveMs = function(p2, p3)
		return p2 + math.max(0, p3) * 86400000
	end,
	hasActiveCampaign = function(items, p2, p3): boolean
		if items == nil or p2 == nil or p2 == 0 then
			return false
		end

		local v5 = tostring(p2)

		for k, item in items do
			if not (item.targetUniverseId == v5 and item.status ~= "CANCELLED" and item.deliveryStatus ~= "REJECTED") then
				continue
			end

			if item.deliveryStatus == "IN_REVIEW" then
				return true
			end

			if item.status == "PAUSED" then
				continue
			end

			local startTime = item.schedule.startTime
			local v6

			if type(startTime) == "string" then
				local success, result = pcall(DateTime.fromIsoDate, startTime)

				v6 = (not success or result == nil) and 0 or result.UnixTimestampMillis
			else
				v6 = 0
			end

			local v7 = v6 > 0 and item.schedule.durationInDays > 0

			if
				item.deliveryStatus == "SERVING" and not v7
				or p3 < v6 + math.max(0, item.schedule.durationInDays) * 86400000
			then
				return true
			end
		end

		return false
	end
}
