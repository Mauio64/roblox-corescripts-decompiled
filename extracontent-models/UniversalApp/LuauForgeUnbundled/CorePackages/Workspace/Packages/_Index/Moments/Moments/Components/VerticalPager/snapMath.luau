local v5 = {}

function v5.advanceCriticalDampedSpring(p2, p3, p4, p5, p6)
	local v6 = 6.283185307179586 * p6
	local v7 = p2 - p4
	local v8 = v6 * p5
	local v9 = math.exp(-v8)
	local v10 = p3 + v6 * v7

	local v11 = (v7 + v10 * p5) * v9
	local v12 = (p3 - v10 * v8) * v9

	return p4 + v11, v12
end

function v5.offsetForIndex(p2, p3)
	return (p2 - 1) * p3
end

function v5.clampIndex(value, max)
	if max <= 0 then
		return 1
	end

	return (math.clamp(value, 1, max))
end

function v5.projectSnapOffset(p2, p3, p4)
	return p2 - p3 * p4
end

function v5.resolveSnapIndex(p2, p3, p4, p5, p6)
	if p5 <= 0 or p4 <= 0 then
		return 1
	end

	local v6 = p2 / p4
	local v7 = v5.projectSnapOffset(p2, p3, p6) - p2
	local v8 = p4 * 0.5
	local v9

	if v8 < v7 then
		v9 = math.floor(v6) + 2
	else
		v9 = if v7 < -v8 then math.ceil(v6) else math.round(v6) + 1
	end

	return v5.clampIndex(v9, p5)
end

function v5.getVisibleWindow(p2, p3, p4)
	if p4 <= 0 then
		return { startIndex = 1, endIndex = 0 }
	end

	local clampIndex = v5.clampIndex(p2, p4)
	return {
		startIndex = math.max(1, clampIndex - p3),
		endIndex = math.min(p4, clampIndex + p3)
	}
end

function v5.reindexAfterRemoval(p2, p3, p4)
	if p4 <= 0 then
		return 1
	end

	if p3 < p2 then
		return v5.clampIndex(p2 - 1, p4)
	end

	return v5.clampIndex(p2, p4)
end

function v5.neighborForRemoval(p2, p3)
	if p2 < p3 then
		return p2 + 1
	end

	return p2 - 1
end

function v5.nearestIndexForOffset(p2, p3, p4)
	if p4 <= 0 or p3 <= 0 then
		return 1
	end

	return v5.clampIndex(math.round(p2 / p3) + 1, p4)
end

function v5.resolveSettleIndex(total, p2, p3, p4, p5, p6)
	if p4 <= 0 or p3 <= 0 then
		return v5.clampIndex(total, p4)
	end

	local v6 = (p2 - v5.offsetForIndex(total, p3)) / p3

	if p5 < v6 then
		local v7 = math.max(1, (math.round(v6)))

		if p6 ~= nil then
			v7 = math.min(v7, p6)
		end

		total += v7
	elseif v6 < -p5 then
		local v7 = math.min(-1, (math.round(v6)))

		if p6 ~= nil then
			v7 = math.max(v7, -p6)
		end

		total += v7
	end

	return v5.clampIndex(total, p4)
end

return v5
