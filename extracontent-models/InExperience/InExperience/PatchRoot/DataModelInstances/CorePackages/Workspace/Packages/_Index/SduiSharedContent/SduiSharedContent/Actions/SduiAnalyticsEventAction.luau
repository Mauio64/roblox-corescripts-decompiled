local Parent = script:FindFirstAncestor("SduiSharedContent").Parent

require(Parent.SduiCoreSystem)

local function isScalar(p1) -- line: 11
	local v7 = typeof(p1)

	return v7 == "string" or (v7 == "number" or v7 == "boolean")
end
local function mergeScalars(t1: {[any]: any}, t2: {[any]: any}?, t3: {[any]: any}?) -- line: 16
	if t2 == nil then
		return
	end

	for v11, v12 in t2 do
		if not t3 or not t3[v11] then
			local v13 = typeof(v12)

			if v13 == "string" or (v13 == "number" or v13 == "boolean") then
				t1[v11] = v12
			end
		end
	end
end

local t4 = {
	eventName = true,
	eventFields = true
}

local function SduiAnalyticsEventAction(p2, p3, p4) -- line: 32
	-- upvalues: mergeScalars (copy), t4 (copy)
	local v17 = p2 and p2.actionParams or nil

	if v17 == nil then
		return
	end

	local eventName = v17.eventName

	if typeof(eventName) ~= "string" or eventName == "" then
		return
	end

	local t5 = {}
	local ancestorAnalyticsData = p3.ancestorAnalyticsData

	if ancestorAnalyticsData ~= nil then
		for v21, v22 in ancestorAnalyticsData do
			local v23 = typeof(v22)

			if v23 == "string" or (v23 == "number" or v23 == "boolean") then
				t5[v21] = v22
			end
		end
	end

	local analyticsData = p3.analyticsData

	if analyticsData ~= nil then
		for v25, v26 in analyticsData do
			local v27 = typeof(v26)

			if v27 == "string" or (v27 == "number" or v27 == "boolean") then
				t5[v25] = v26
			end
		end
	end

	mergeScalars(t5, v17, t4)

	local eventFields = v17.eventFields

	if typeof(eventFields) == "table" and eventFields ~= nil then
		for v29, v30 in eventFields do
			local v31 = typeof(v30)

			if v31 == "string" or (v31 == "number" or v31 == "boolean") then
				t5[v29] = v30
			end
		end
	end

	p4.dependencies.eventIngest:sendEventDeferred(p4.appPage, eventName, t5)
end

return SduiAnalyticsEventAction
