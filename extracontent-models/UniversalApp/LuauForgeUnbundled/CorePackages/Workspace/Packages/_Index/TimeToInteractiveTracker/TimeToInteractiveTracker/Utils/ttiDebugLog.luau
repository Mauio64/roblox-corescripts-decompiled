local HttpService = game:GetService("HttpService")

require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/types")

local FFlagDebugTimeToInteractiveTracker = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/FFlagDebugTimeToInteractiveTracker")

local function formatPayload(p2)
	if p2 == nil then
		return ""
	end

	if type(p2) ~= "table" then
		return (tostring(p2))
	end

	local success, result = pcall(function()
		return HttpService:JSONEncode(p2)
	end)

	if success then
		return result
	end

	return (tostring(p2))
end

local function formatMilestones(list)
	if not list or #list == 0 then
		return ""
	end

	local v5 = {}

	for k, item in list do
		local v6 = not (item.totalMemoryMB or item.luaHeapMB) and ""
			or (" [mem: total=%.1fMB lua=%.1fMB]"):format(item.totalMemoryMB or 0, item.luaHeapMB or 0)

		table.insert(v5, ("  %s %.0fms%s"):format(item.name, item.deltaMs, v6))

		if item.subphases then
			for k2, subphas in item.subphases do
				table.insert(v5, ("    -> %s %.0fms"):format(subphas.name, subphas.deltaMs or 0))
			end
		end

		if not item.requests then
			continue
		end

		for k2, request in item.requests do
			table.insert(v5, ("    -> [req] %s %.0fms"):format(request.name, request.deltaMs or 0))
		end
	end

	return "\n" .. table.concat(v5, "\n")
end

return function(p2, p3, p4, p5, p6)
	if not FFlagDebugTimeToInteractiveTracker then
		return
	end

	local formatted = ("[TimeToInteractiveTracker][%s]"):format(p2)
	local result

	if p5 == nil then
		result = ""
	elseif type(p5) == "table" then
		local success
		success, result = pcall(function()
			return HttpService:JSONEncode(p5)
		end)

		if not success then
			result = tostring(p5)
		end
	else
		result = tostring(p5)
	end

	local v5 = { formatted, p3 }

	if p4 ~= nil then
		table.insert(v5, ("%.0fms"):format(p4))
	end

	if result ~= "" then
		table.insert(v5, result)
	end

	local v6 = formatMilestones(p6)

	if v6 ~= "" then
		table.insert(v5, v6)
	end

	print(table.unpack(v5))
end
