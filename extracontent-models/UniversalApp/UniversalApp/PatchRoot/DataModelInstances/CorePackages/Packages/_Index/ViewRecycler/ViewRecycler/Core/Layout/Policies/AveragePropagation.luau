return {
	new = function(options)
		local v = options or {}
		local sampleInterval = v.sampleInterval or 8
		local driftThreshold = v.driftThreshold or 8

		local count = 0
		local v2 = v.initialAverage or 0

		return {
			recordMeasurementAndShouldUpdateEstimates = function(p: number): boolean
				count += 1

				if count < sampleInterval or math.abs(p - v2) < driftThreshold then
					return false
				end

				v2 = p
				count = 0
				return true
			end
		}
	end
}
