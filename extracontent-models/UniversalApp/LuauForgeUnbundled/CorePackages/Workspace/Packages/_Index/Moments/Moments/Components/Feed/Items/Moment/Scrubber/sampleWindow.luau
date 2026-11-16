local function isNaN(p2): boolean
	return p2 ~= p2
end

return {
	estimateVelocity = function(list)
		local count = #list

		if count < 2 then
			return 0
		end

		local item = list[1]
		local item2 = list[count]
		local v6 = item2.time - item.time

		if v6 <= 0 or v6 ~= v6 then
			return 0
		end

		local v7 = (item2.position - item.position) / v6

		if v7 ~= v7 then
			return 0
		end

		return v7
	end,
	planTargets = function(p2, p3, p4, data)
		local granularity = data.granularity

		if p2 ~= p2 or granularity <= 0 or #data.bands == 0 or data.maxSamples <= 0 then
			return {}
		end

		local v6 = p3 ~= p3 and 0 or p3
		local v7 = data.maxLeadFraction * (p4.max - p4.min)
		local v8 = math.round((p2 + math.clamp(v6 * data.predictionLead, -v7, v7)) / granularity)

		local function strideForDistance(p5)
			for k, band in data.bands do
				if p5 <= band.radius + 1e-9 then
					return band.stride
				end
			end

			return nil
		end

		local v9 = math.floor(data.bands[#data.bands].radius / granularity + 1e-9)

		local v10 = {}
		local set = {}
		local function consider(p5)
			if #v10 >= data.maxSamples then
				return
			end

			local v11 = math.abs(p5) * granularity
			local flag = true
			local stride

			for k, band in data.bands do
				if v11 <= band.radius + 1e-9 then
					stride = band.stride
					flag = false
					break
				end
			end

			if flag then
				stride = nil
			end

			if stride == nil or p5 % stride ~= 0 then
				return
			end

			local v12 = (v8 + p5) * granularity

			if v12 < p4.min or p4.max < v12 or set[v12] then
				return
			end

			set[v12] = true
			table.insert(v10, v12)
		end

		if not (#v10 >= data.maxSamples) then
			local v11 = 0 * granularity
			local flag = true
			local stride

			for k, band in data.bands do
				if v11 <= band.radius + 1e-9 then
					stride = band.stride
					flag = false
					break
				end
			end

			if flag then
				stride = nil
			end

			if stride ~= nil and 0 % stride == 0 then
				local v12 = (v8 + 0) * granularity

				if not (v12 < p4.min or p4.max < v12 or set[v12]) then
					set[v12] = true
					table.insert(v10, v12)
				end
			end
		end

		for i = 1, v9 do
			if #v10 >= data.maxSamples then
				break
			end

			consider(i)
			consider(-i)
		end

		table.sort(v10)
		return v10
	end,
	diff = function(items, items2)
		local set = {}
		local v6 = {}

		for k, item in items do
			set[item] = true

			if not items2[item] then
				table.insert(v6, item)
			end
		end

		local v7 = {}

		for k in items2 do
			if not set[k] then
				table.insert(v7, k)
			end
		end

		table.sort(v7)

		return { fetch = v6, evict = v7 }
	end,
	selectFrameTime = function(p2, items)
		local v6 = 1e999
		local frameTime = nil

		for k, item in items do
			local v7 = math.abs(item - p2)

			if not (v7 < v6) then
				continue
			end

			frameTime = item
			v6 = v7
		end

		return frameTime
	end,
	defaultConfig = {
		granularity = 0.2,
		bands = {
			{ radius = 1, stride = 1 },
			{ radius = 3, stride = 3 },
			{ radius = 8, stride = 8 }
		},
		predictionLead = 0.4,
		maxLeadFraction = 0.2,
		maxSamples = 40
	}
}
