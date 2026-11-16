local HttpService = game:GetService("HttpService")

require(script.Parent.Parent.Stores.types)

local FFlagDebugTimeToInteractiveTracker = require(script.Parent.FFlagDebugTimeToInteractiveTracker)

local function formatPayload(p)
	if p == nil then
		return ""
	end

	if type(p) ~= "table" then
		return (tostring(p))
	end

	local success, result = pcall(function()
		return HttpService:JSONEncode(p)
	end)

	if success then
		return result
	end

	return (tostring(p))
end

local function formatMilestones(list)
	if not list or #list == 0 then
		return ""
	end

	local v = {}

	for _, item in list do
		local v2 = not (item.totalMemoryMB or item.luaHeapMB) and ""
			or (" [mem: total=%.1fMB lua=%.1fMB]"):format(item.totalMemoryMB or 0, item.luaHeapMB or 0)

		table.insert(v, ("  %s %.0fms%s"):format(item.name, item.deltaMs, v2))

		if item.subphases then
			for _, subphas in item.subphases do
				table.insert(v, ("    -> %s %.0fms"):format(subphas.name, subphas.deltaMs or 0))
			end
		end

		if not item.requests then
			continue
		end

		for _, request in item.requests do
			table.insert(v, ("    -> [req] %s %.0fms"):format(request.name, request.deltaMs or 0))
		end
	end

	return "\n" .. table.concat(v, "\n")
end

return function(p: string, p2: string, p3: number?, p4, p5)
	if not FFlagDebugTimeToInteractiveTracker then
		return
	end

	local formatted = ("[TimeToInteractiveTracker][%s]"):format(p)
	local result

	if p4 == nil then
		result = ""
	elseif type(p4) == "table" then
		local success
		success, result = pcall(function()
			return HttpService:JSONEncode(p4)
		end)

		if not success then
			result = tostring(p4)
		end
	else
		result = tostring(p4)
	end

	local v = { formatted, p2 }

	if p3 ~= nil then
		table.insert(v, ("%.0fms"):format(p3))
	end

	if result ~= "" then
		table.insert(v, result)
	end

	local v2 = formatMilestones(p5)

	if v2 ~= "" then
		table.insert(v, v2)
	end

	print(table.unpack(v))
end
