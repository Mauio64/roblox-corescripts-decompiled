local function getAgeMilliseconds(p2, p3)
	return (math.max(p3 - p2, 0))
end

local function getNextBucketBoundary(p2, p3, p4, p5)
	return p2 + math.min((math.floor(p3 / p4) + 1) * p4, p5)
end

return {
	parseTimestamp = function(p2)
		if p2 == "" then
			return nil
		end

		local success, result = pcall(DateTime.fromIsoDate, p2)

		if success and result ~= nil then
			return result.UnixTimestampMillis
		end

		return nil
	end,
	getRelativeAge = function(p2, p3)
		if p2 == nil then
			return nil
		end

		local v5 = math.max(p3 - p2, 0)

		if v5 < 60000 then
			return { unit = "now", count = 0 }
		end

		if v5 < 3600000 then
			return {
				unit = "minutes",
				count = math.floor(v5 / 60000)
			}
		end

		if v5 < 86400000 then
			return {
				unit = "hours",
				count = math.floor(v5 / 3600000)
			}
		end

		if v5 < 604800000 then
			return {
				unit = "days",
				count = math.floor(v5 / 86400000)
			}
		end

		if v5 < 2592000000 then
			return {
				unit = "weeks",
				count = math.floor(v5 / 604800000)
			}
		end

		if v5 < 31536000000 then
			return {
				unit = "months",
				count = math.floor(v5 / 2592000000)
			}
		end

		return {
			unit = "years",
			count = math.floor(v5 / 31536000000)
		}
	end,
	getNextChangeTimestamp = function(p2, p3)
		if p2 == nil then
			return nil
		end

		local v5 = math.max(p3 - p2, 0)

		if v5 < 60000 then
			return p2 + 60000
		end

		if v5 < 3600000 then
			return p2 + math.min((math.floor(v5 / 60000) + 1) * 60000, 3600000)
		end

		if v5 < 86400000 then
			return p2 + math.min((math.floor(v5 / 3600000) + 1) * 3600000, 86400000)
		end

		if v5 < 604800000 then
			return p2 + math.min((math.floor(v5 / 86400000) + 1) * 86400000, 604800000)
		end

		if v5 < 2592000000 then
			return p2 + math.min((math.floor(v5 / 604800000) + 1) * 604800000, 2592000000)
		end

		if v5 < 31536000000 then
			return p2 + math.min((math.floor(v5 / 2592000000) + 1) * 2592000000, 31536000000)
		end

		return p2 + math.min((math.floor(v5 / 31536000000) + 1) * 31536000000, 1e999)
	end
}
