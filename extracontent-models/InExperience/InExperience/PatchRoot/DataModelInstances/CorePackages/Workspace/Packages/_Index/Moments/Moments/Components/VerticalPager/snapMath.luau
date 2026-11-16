local SnapMath = {}

function SnapMath.advanceCriticalDampedSpring(p: number, p2: number, p3: number, p4: number, p5: number)
	local v = 6.283185307179586 * p5
	local v2 = p - p3
	local v3 = v * p4
	local v4 = math.exp(-v3)
	local v5 = p2 + v * v2

	local v6 = (v2 + v5 * p4) * v4
	local v7 = (p2 - v5 * v3) * v4

	return p3 + v6, v7
end

function SnapMath.offsetForIndex(p: number, p2: number)
	return (p - 1) * p2
end

function SnapMath.clampIndex(value: number, max: number)
	if max <= 0 then
		return 1
	end

	return (math.clamp(value, 1, max))
end

function SnapMath.projectSnapOffset(p: number, p2: number, p3: number)
	return p - p2 * p3
end

function SnapMath.resolveSnapIndex(p: number, p2: number, p3: number, p4: number, p5: number)
	if p4 <= 0 or p3 <= 0 then
		return 1
	end

	local v = p / p3
	local v2 = SnapMath.projectSnapOffset(p, p2, p5) - p
	local v3 = p3 * 0.5
	local v4

	if v3 < v2 then
		v4 = math.floor(v) + 2
	elseif v2 < -v3 then
		v4 = math.ceil(v)
	else
		v4 = math.round(v) + 1
	end

	return SnapMath.clampIndex(v4, p4)
end

function SnapMath.getVisibleWindow(p: number, p2: number, p3: number)
	if p3 <= 0 then
		return { startIndex = 1, endIndex = 0 }
	end

	local clampIndex = SnapMath.clampIndex(p, p3)
	return {
		startIndex = math.max(1, clampIndex - p2),
		endIndex = math.min(p3, clampIndex + p2)
	}
end

function SnapMath.reindexAfterRemoval(p: number, p2: number, p3: number)
	if p3 <= 0 then
		return 1
	end

	if p2 < p then
		return SnapMath.clampIndex(p - 1, p3)
	end

	return SnapMath.clampIndex(p, p3)
end

function SnapMath.neighborForRemoval(p: number, p2: number)
	if p < p2 then
		return p + 1
	end

	return p - 1
end

function SnapMath.nearestIndexForOffset(p: number, p2: number, p3: number)
	if p3 <= 0 or p2 <= 0 then
		return 1
	end

	return SnapMath.clampIndex(math.round(p / p2) + 1, p3)
end

function SnapMath.resolveSettleIndex(total: number, p: number, p2: number, p3: number, p4: number, p5: number?)
	if p3 <= 0 or p2 <= 0 then
		return SnapMath.clampIndex(total, p3)
	end

	local v = (p - SnapMath.offsetForIndex(total, p2)) / p2

	if p4 < v then
		local v2 = math.max(1, (math.round(v)))

		if p5 ~= nil then
			v2 = math.min(v2, p5)
		end

		total += v2
	elseif v < -p4 then
		local v2 = math.min(-1, (math.round(v)))

		if p5 ~= nil then
			v2 = math.max(v2, -p5)
		end

		total += v2
	end

	return SnapMath.clampIndex(total, p3)
end

return SnapMath
