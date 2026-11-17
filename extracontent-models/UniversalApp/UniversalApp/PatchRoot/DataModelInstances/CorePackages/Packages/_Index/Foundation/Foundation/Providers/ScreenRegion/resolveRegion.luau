local Foundation = script:FindFirstAncestor("Foundation")

local DisplacedBehavior = require(Foundation.Providers.ScreenRegion.DisplacedBehavior)
local RegionOrder = require(Foundation.Providers.ScreenRegion.RegionOrder)
require(Foundation.Providers.ScreenRegion.ScreenRegionKind)
require(Foundation.Providers.ScreenRegion.regionPolicies)

local function ranksAbove(data, data2, p): boolean
	if p.order == RegionOrder.Priority then
		local priority = data.priority or 0
		local priority2 = data2.priority or 0

		if priority ~= priority2 then
			return priority2 < priority
		end
	end

	local claimedAt = data.claimedAt or 0
	local claimedAt2 = data2.claimedAt or 0

	if claimedAt == claimedAt2 then
		return data.id > data2.id
	end

	return claimedAt2 < claimedAt
end

local function resolveRegion(items, data)
	local v = {}

	for _, item in items do
		if not item.isOpen or item.isDismissed then
			continue
		end

		table.insert(v, item)
	end

	table.sort(v, function(a, b): boolean
		if data.order == RegionOrder.Priority then
			local priority = a.priority or 0
			local priority2 = b.priority or 0

			if priority ~= priority2 then
				return priority2 < priority
			end
		end

		local claimedAt = a.claimedAt or 0
		local claimedAt2 = b.claimedAt or 0

		if claimedAt == claimedAt2 then
			return a.id > b.id
		end

		return claimedAt2 < claimedAt
	end)

	local v2 = {}
	local count = 0
	local v3 = {}
	local idSet = {}

	for _, v4 in v do
		local v5

		if data.capacityPerKind then
			v5 = data.capacityPerKind[v4.kind]
		end

		local v6 = v2[v4.kind] or 0

		if count < data.capacity and (v5 == nil or v6 < v5) then
			v3[v4.id] = v4
			count += 1
			v2[v4.kind] = v6 + 1
		elseif data.displaced[v4.kind] == DisplacedBehavior.Dismiss then
			idSet[v4.id] = true
		end
	end

	local visible = {}

	for k, v4 in v3 do
		local v5 = false

		if data.sequential and not v4.isMounted then
			for _, item in items do
				if item.isMounted and v3[item.id] == nil then
					v5 = true
					break
				end
			end
		end

		visible[k] = not v5
	end

	return { visible = visible, dismissed = idSet }
end

return resolveRegion
