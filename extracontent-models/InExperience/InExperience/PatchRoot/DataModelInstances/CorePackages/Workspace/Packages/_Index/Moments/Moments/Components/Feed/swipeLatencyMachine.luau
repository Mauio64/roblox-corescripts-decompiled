local parent = script:FindFirstAncestor("Moments").Parent
require(parent.MomentsCommon)

local function swipeLatencyMachine(data)
	local now = data.now
	local v = nil

	local count = 0

	local function tryComplete()
		local v2 = v

		if v2 == nil then
			return
		end

		local settledAt = v2.settledAt
		local frameAt = v2.frameAt

		if settledAt == nil or frameAt == nil then
			return
		end

		v = nil
		data.onMeasurement(
			math.round((math.max(0, frameAt - settledAt))),
			math.round(math.max(frameAt, settledAt) - v2.committedAt),
			v2.dimensions
		)
	end

	local schedule = data.schedule or task.delay

	local function armCap(count2: number) -- 1 equivalent call inferred from this helper
		if data.capMs <= 0 then
			return
		end

		schedule(data.capMs / 1000, function()
			if count2 ~= count then
				return
			end

			v = nil
		end)
	end

	return {
		start = function(flag: boolean, flag2: boolean, dimensions)
			count += 1
			local v2 = now()
			local settledAt2

			if flag then
				settledAt2 = v2
			end

			local v3 = { committedAt = v2, settledAt = settledAt2, frameAt = nil, dimensions = nil }

			if not flag2 then
				v2 = nil
			end

			v3.frameAt = v2
			v3.dimensions = dimensions
			v = v3
			armCap(count) -- inferred equivalent call
			local v4 = v

			if v4 == nil then
				return
			end

			local settledAt = v4.settledAt
			local frameAt = v4.frameAt

			if settledAt ~= nil then
				if frameAt == nil then
					return
				end

				v = nil
				data.onMeasurement(
					math.round((math.max(0, frameAt - settledAt))),
					math.round(math.max(frameAt, settledAt) - v4.committedAt),
					v4.dimensions
				)
			end
		end,
		update = function(flag: boolean, flag2: boolean)
			local v2 = v

			if v2 == nil then
				return
			end

			if v2.settledAt == nil and flag then
				v2.settledAt = now()
			end

			if v2.frameAt == nil and flag2 then
				v2.frameAt = now()
			end

			local v3 = v

			if v3 == nil then
				return
			end

			local settledAt = v3.settledAt
			local frameAt = v3.frameAt

			if settledAt ~= nil then
				if frameAt == nil then
					return
				end

				v = nil
				data.onMeasurement(
					math.round((math.max(0, frameAt - settledAt))),
					math.round(math.max(frameAt, settledAt) - v3.committedAt),
					v3.dimensions
				)
			end
		end
	}
end

return swipeLatencyMachine
