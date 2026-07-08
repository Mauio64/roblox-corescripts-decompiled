local HttpService = game:GetService("HttpService")

require(script.Parent.Parent.Stores.types)

local FFlagDebugTimeToInteractiveTracker = require(script.Parent.FFlagDebugTimeToInteractiveTracker)

local function formatPayload(p1) -- line: 9
	-- upvalues: HttpService (copy)
	if p1 == nil then
		return ""
	end

	if type(p1) ~= "table" then
		return (tostring(p1))
	end

	local ok, result = pcall(function() -- line: 18
		-- upvalues: HttpService (copy), p1 (copy)
		return HttpService:JSONEncode(p1)
	end)

	if ok then
		return result
	end

	return (tostring(p1))
end
local function formatMilestones(t1: {[any]: any}?) -- line: 28
	if not t1 or #t1 == 0 then
		return ""
	end

	local t2 = {}

	for _, v11 in t1 do
		local s1 = ""

		if v11.totalMemoryMB or v11.luaHeapMB then
			s1 = (" [mem: total=%.1fMB lua=%.1fMB]"):format(v11.totalMemoryMB or 0, v11.luaHeapMB or 0)
		end

		table.insert(t2, ("  %s %.0fms%s"):format(v11.name, v11.deltaMs, s1))

		if v11.subphases then
			for _, v14 in v11.subphases do
				table.insert(t2, ("    -> %s %.0fms"):format(v14.name, v14.deltaMs or 0))
			end
		end

		if v11.requests then
			for _, v16 in v11.requests do
				table.insert(t2, ("    -> [req] %s %.0fms"):format(v16.name, v16.deltaMs or 0))
			end
		end
	end

	return "\n" .. table.concat(t2, "\n")
end

return function(s2: string, s3: string, n1: number?, p2, t3: {[any]: any}?) -- line: 57
	-- upvalues: FFlagDebugTimeToInteractiveTracker (copy), HttpService (copy), formatMilestones (copy)
	if not FFlagDebugTimeToInteractiveTracker then
		return
	end

	local v22 = ("[TimeToInteractiveTracker][%s]"):format(s2)
	local s4

	if p2 == nil then
		s4 = ""
	elseif type(p2) ~= "table" then
		s4 = tostring(p2)
	else
		local ok, result = pcall(function() -- line: 18
			-- upvalues: HttpService (copy), p2 (copy)
			return HttpService:JSONEncode(p2)
		end)

		s4 = if not ok then tostring(p2) else result
	end

	local t4 = {
		v22,
		s3
	}

	if n1 ~= nil then
		table.insert(t4, ("%.0fms"):format(n1))
	end

	if s4 ~= "" then
		table.insert(t4, s4)
	end

	local v27 = formatMilestones(t3)

	if v27 ~= "" then
		table.insert(t4, v27)
	end

	print(table.unpack(t4))
end
