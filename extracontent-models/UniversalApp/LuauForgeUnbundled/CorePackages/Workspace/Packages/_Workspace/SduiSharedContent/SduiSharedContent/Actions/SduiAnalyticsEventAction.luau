require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")

local function isScalar(p2): boolean
	local typeName = typeof(p2)
	return typeName == "string" or typeName == "number" or typeName == "boolean"
end

local function mergeScalars(p2, actionParams, p3)
	if actionParams == nil then
		return
	end

	for k, item in actionParams do
		if p3 and p3[k] then
			continue
		end

		local typeName = typeof(item)

		if typeName == "string" or typeName == "number" or typeName == "boolean" then
			p2[k] = item
		end
	end
end

local v5 = { eventName = true, eventFields = true }

local function SduiAnalyticsEventAction(p2, p3, p4)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		return
	end

	local eventName = actionParams.eventName

	if typeof(eventName) ~= "string" or eventName == "" then
		return
	end

	local v6 = {}

	local ancestorAnalyticsData = p3.ancestorAnalyticsData

	if ancestorAnalyticsData ~= nil then
		for k, v7 in ancestorAnalyticsData do
			local typeName = typeof(v7)

			if typeName == "string" or typeName == "number" or typeName == "boolean" then
				v6[k] = v7
			end
		end
	end

	local analyticsData = p3.analyticsData

	if analyticsData ~= nil then
		for k, v7 in analyticsData do
			local typeName = typeof(v7)

			if typeName == "string" or typeName == "number" or typeName == "boolean" then
				v6[k] = v7
			end
		end
	end

	mergeScalars(v6, actionParams, v5)

	local eventFields = actionParams.eventFields

	if typeof(eventFields) == "table" and eventFields ~= nil then
		for k, eventField in eventFields do
			local typeName = typeof(eventField)

			if typeName == "string" or typeName == "number" or typeName == "boolean" then
				v6[k] = eventField
			end
		end
	end

	p4.dependencies.eventIngest:sendEventDeferred(p4.appPage, eventName, v6)
end

return SduiAnalyticsEventAction
