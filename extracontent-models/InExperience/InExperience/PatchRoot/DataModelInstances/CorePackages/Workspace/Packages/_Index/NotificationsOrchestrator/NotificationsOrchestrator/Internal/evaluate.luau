local NotificationsOrchestrator = script:FindFirstAncestor("NotificationsOrchestrator")
require(NotificationsOrchestrator.Types)

local function countWithin(items, p: number, p2: number)
	local v = p - p2
	local count = 0

	for _, item in items do
		if v <= item then
			count += 1
		end
	end

	return count
end

local function evaluate(p, p2, callback, p3: number): boolean
	if p == nil then
		return true
	end

	local v = p.cooldownSeconds ~= nil
	local v2 = p.maxImpressions ~= nil

	if not (v or v2) then
		return true
	end

	local v3 = callback()
	local cooldownSeconds = p.cooldownSeconds

	if cooldownSeconds ~= nil and v3.lastShownAt > 0 and p3 - v3.lastShownAt < cooldownSeconds then
		return false
	end

	if p.maxImpressions == nil then
		return true
	end

	local v4

	if typeof(p2) == "table" and p2.kind == "rolling" then
		local shownAt = v3.shownAt
		local v5 = p3 - p2.seconds
		v4 = 0

		for _, v6 in shownAt do
			if v5 <= v6 then
				v4 += 1
			end
		end
	else
		v4 = v3.count
	end

	return v4 < p.maxImpressions
end

return evaluate
