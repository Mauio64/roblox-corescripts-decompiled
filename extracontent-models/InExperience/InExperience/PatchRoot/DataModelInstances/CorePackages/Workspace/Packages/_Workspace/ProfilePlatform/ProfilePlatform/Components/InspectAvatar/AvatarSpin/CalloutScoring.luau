require(script.Parent.ItemAnchors)
local ItemVisibility = require(script.Parent.ItemVisibility)

local v = { purchasable = 3, resale = 3, owned = 2, unavailable = 1 }

local CalloutScoring = {
	APPEAR_WEIGHT = 0.45,
	KEEP_WEIGHT = 0.3,
	PIN_WEIGHT = 0.15,
	viewCoverage = function(items)
		local count = 0

		for i = 0, 71 do
			local v2 = i / 72 * 2 * 3.141592653589793
			local vector3 = Vector3.new(math.sin(v2), 0, -math.cos(v2))
			local maxValue = 0

			for _, item in items do
				maxValue = math.max(
					maxValue,
					ItemVisibility.facingWeight(item, CFrame.identity, vector3, Vector3.new(0, 0, 0))
				)
			end

			if maxValue >= 0.6 then
				count += 1
			end
		end

		return count / 72
	end
}

function CalloutScoring.priceRanks(items)
	local set = {}
	local v2 = {}

	for _, item in items do
		if set[item] then
			continue
		end

		set[item] = true
		table.insert(v2, item)
	end

	table.sort(v2)
	local v3 = {}

	for k, v4 in v2 do
		v3[v4] = k - 1
	end

	local result = {}

	for k, item in items do
		result[k] = v3[item]
	end

	return result
end

function CalloutScoring.score(p: number, p2: string, p3: number, p4: number)
	local v2 = p * ((1 - p3) * 0.8 + 1)
	return v[p2] * 10000 + p4 * 2 + v2
end

function CalloutScoring.isLastResort(p: string): boolean
	return p == "unavailable"
end

function CalloutScoring.isEligible(p: number, flag: boolean, flag2: boolean): boolean
	if flag2 then
		return p > 0.15
	end

	return (flag and 0.3 or 0.45) <= p
end

return CalloutScoring
