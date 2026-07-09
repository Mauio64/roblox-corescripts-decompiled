local t1 = {}

local function isNaN(n1: number) -- line: 65
	return n1 ~= n1
end

function t1.estimateVelocity(t2: {[any]: any}) -- line: 74
	local v5 = #t2

	if v5 < 2 then
		return 0
	end

	local v6 = t2[1]
	local v7 = t2[v5]
	local v8 = v7.time - v6.time

	if v8 <= 0 or v8 ~= v8 then
		return 0
	end

	local v9 = (v7.position - v6.position) / v8

	if v9 ~= v9 then
		return 0
	end

	return v9
end
function t1.planTargets(n2: number, n3: number, t3: {[any]: any}, t4: {[any]: any}) -- line: 97
	local granularity = t4.granularity

	if n2 ~= n2 or (granularity <= 0 or #t4.bands == 0 or t4.maxSamples <= 0) then
		return {}
	end

	local v15 = if n3 == n3 then n3 else 0
	local v16 = t4.maxLeadFraction * (t3.max - t3.min)
	local v17 = math.round((n2 + math.clamp(v15 * t4.predictionLead, -v16, v16)) / granularity)

	local function strideForDistance(n4: number) -- line: 111
		-- upvalues: t4 (copy)
		for _, v47 in t4.bands do
			if n4 <= v47.radius + 1E-09 then
				return v47.stride
			end
		end

		return nil
	end

	local v19 = math.floor(t4.bands[#t4.bands].radius / granularity + 1E-09)
	local t5 = {}
	local t6 = {}

	local function consider(n5: number) -- line: 126
		-- upvalues: t5 (copy), t4 (copy), granularity (copy), v17 (copy), t3 (copy), t6 (copy)
		if #t5 >= t4.maxSamples then
			return
		end

		local v49 = math.abs(n5) * granularity
		local g53 = nil
		local stride = nil

		for _, v51 in t4.bands do
			if v49 <= v51.radius + 1E-09 then
				stride = v51.stride
				g53 = true
			end

			if g53 then
				break
			end
		end

		if not g53 then
			stride = nil
		end

		g53 = false

		if stride == nil or n5 % stride ~= 0 then
			return
		end

		local v54 = (v17 + n5) * granularity

		if v54 < t3.min or v54 > t3.max or t6[v54] then
			return
		end

		t6[v54] = true
		table.insert(t5, v54)
	end

	if not (#t5 >= t4.maxSamples) then
		local v23 = granularity * 0
		local g27 = nil
		local stride = nil

		for _, v25 in t4.bands do
			if v23 <= v25.radius + 1E-09 then
				stride = v25.stride
				g27 = true
			end

			if g27 then
				break
			end
		end

		if not g27 then
			stride = nil
		end

		g27 = false

		if stride ~= nil and 0 % stride == 0 then
			local v28 = (v17 + 0) * granularity

			if not (v28 < t3.min) and not (v28 > t3.max) and not t6[v28] then
				t6[v28] = true
				table.insert(t5, v28)
			end
		end
	end

	for i = 1, v19 do
		if #t5 >= t4.maxSamples then
			break
		end

		consider(i)
		consider(-i)
	end

	table.sort(t5)

	return t5
end
function t1.diff(t7: {[any]: any}, t8: {[any]: any}) -- line: 160
	local t9 = {}
	local t10 = {}

	for _, v35 in t7 do
		t9[v35] = true

		if not t8[v35] then
			table.insert(t10, v35)
		end
	end

	local t11 = {}

	for v37 in t8 do
		if not t9[v37] then
			table.insert(t11, v37)
		end
	end

	table.sort(t11)

	return {
		fetch = t10,
		evict = t11
	}
end
function t1.selectFrameTime(n6: number, t12: {[any]: any}) -- line: 185
	local v40 = nil
	local n7 = 1e999

	for _, v43 in t12 do
		local v44 = math.abs(v43 - n6)

		if v44 < n7 then
			n7 = v44
			v40 = v43
		end
	end

	return v40
end

t1.defaultConfig = {
	granularity = 0.2,
	predictionLead = 0.4,
	maxLeadFraction = 0.2,
	maxSamples = 40,
	bands = {
		{
			radius = 1,
			stride = 1
		},
		{
			radius = 3,
			stride = 3
		},
		{
			radius = 8,
			stride = 8
		}
	}
}

return t1
