require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")

local function swipeLatencyMachine(data)
	local now = data.now
	local v5 = nil

	local count = 0

	local function tryComplete()
		local v6 = v5

		if v6 == nil then
			return
		end

		local settledAt = v6.settledAt
		local frameAt = v6.frameAt

		if settledAt == nil or frameAt == nil then
			return
		end

		v5 = nil
		data.onMeasurement(
			math.round((math.max(0, frameAt - settledAt))),
			math.round(math.max(frameAt, settledAt) - v6.committedAt),
			v6.dimensions
		)
	end

	local schedule = data.schedule or task.delay

	local function armCap(p2)
		if data.capMs <= 0 then
			return
		end

		schedule(data.capMs / 1000, function()
			if p2 ~= count then
				return
			end

			v5 = nil
		end)
	end

	return {
		start = function(p2, p3, dimensions)
			count += 1
			local v6 = now()
			local v7 = {
				committedAt = v6,
				settledAt = if p2 then v6 else nil,
				frameAt = nil,
				dimensions = nil
			}

			if not p3 then
				v6 = nil
			end

			v7.frameAt = v6
			v7.dimensions = dimensions
			v5 = v7

			local v9 = count

			if not (data.capMs <= 0) then
				schedule(data.capMs / 1000, function()
					if v9 ~= count then
						return
					end

					v5 = nil
				end)
			end

			local v10 = v5

			if v10 == nil then
				return
			end

			local settledAt = v10.settledAt
			local frameAt = v10.frameAt

			if settledAt ~= nil then
				if frameAt == nil then
					return
				end

				v5 = nil
				data.onMeasurement(
					math.round((math.max(0, frameAt - settledAt))),
					math.round(math.max(frameAt, settledAt) - v10.committedAt),
					v10.dimensions
				)
			end
		end,
		update = function(p2, p3)
			local v6 = v5

			if v6 == nil then
				return
			end

			if v6.settledAt == nil and p2 then
				v6.settledAt = now()
			end

			if v6.frameAt == nil and p3 then
				v6.frameAt = now()
			end

			local v7 = v5

			if v7 == nil then
				return
			end

			local settledAt = v7.settledAt
			local frameAt = v7.frameAt

			if settledAt ~= nil then
				if frameAt == nil then
					return
				end

				v5 = nil
				data.onMeasurement(
					math.round((math.max(0, frameAt - settledAt))),
					math.round(math.max(frameAt, settledAt) - v7.committedAt),
					v7.dimensions
				)
			end
		end
	}
end

return swipeLatencyMachine
