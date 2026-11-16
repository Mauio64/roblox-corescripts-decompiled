local function isNaN(p: number): boolean -- 4 equivalent calls inferred from this helper
	return p ~= p
end

local SampleWindow = {}

function SampleWindow.estimateVelocity(list)
	local count = #list

	if count < 2 then
		return 0
	end

	local item = list[1]
	local item2 = list[count]
	local v = item2.time - item.time

	if v <= 0 or isNaN(v) then -- inferred equivalent call
		return 0
	end

	local v2 = (item2.position - item.position) / v
	return if isNaN(v2) then 0 else v2 -- inferred equivalent call
end

function SampleWindow.planTargets(p: number, p2: number, p3, data)
	local granularity = data.granularity

	if isNaN(p) or granularity <= 0 or #data.bands == 0 or data.maxSamples <= 0 then -- inferred equivalent call
		return {}
	end

	local v = isNaN(p2) and 0 or p2 -- inferred equivalent call
	local v2 = data.maxLeadFraction * (p3.max - p3.min)
	local v3 = math.round((p + math.clamp(v * data.predictionLead, -v2, v2)) / granularity)

	local function strideForDistance(p4: number) -- 2 equivalent calls inferred from this helper
		for _, band in data.bands do
			if p4 <= band.radius + 1e-9 then
				return band.stride
			end
		end

		return nil
	end

	local v4 = math.floor(data.bands[#data.bands].radius / granularity + 1e-9)

	local v5 = {}
	local set = {}
	local function consider(p4: number)
		if #v5 >= data.maxSamples then
			return
		end

		local v6 = strideForDistance(math.abs(p4) * granularity) -- inferred equivalent call

		if v6 == nil or p4 % v6 ~= 0 then
			return
		end

		local v7 = (v3 + p4) * granularity

		if v7 < p3.min or p3.max < v7 or set[v7] then
			return
		end

		set[v7] = true
		table.insert(v5, v7)
	end

	if not (#v5 >= data.maxSamples) then
		local v6 = strideForDistance(granularity * 0) -- inferred equivalent call

		if v6 ~= nil and 0 % v6 == 0 then
			local v7 = (v3 + 0) * granularity

			if not (v7 < p3.min or p3.max < v7 or set[v7]) then
				set[v7] = true
				table.insert(v5, v7)
			end
		end
	end

	for i = 1, v4 do
		if #v5 >= data.maxSamples then
			break
		end

		consider(i)
		consider(-i)
	end

	table.sort(v5)
	return v5
end

function SampleWindow.diff(items, items2)
	local set = {}
	local fetch = {}

	for _, item in items do
		set[item] = true

		if not items2[item] then
			table.insert(fetch, item)
		end
	end

	local evict = {}

	for k in items2 do
		if not set[k] then
			table.insert(evict, k)
		end
	end

	table.sort(evict)

	return { fetch = fetch, evict = evict }
end

function SampleWindow.selectFrameTime(p: number, items)
	local v = 1e999
	local frameTime = nil

	for _, item in items do
		local v2 = math.abs(item - p)

		if not (v2 < v) then
			continue
		end

		frameTime = item
		v = v2
	end

	return frameTime
end

SampleWindow.defaultConfig = {
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
return SampleWindow
