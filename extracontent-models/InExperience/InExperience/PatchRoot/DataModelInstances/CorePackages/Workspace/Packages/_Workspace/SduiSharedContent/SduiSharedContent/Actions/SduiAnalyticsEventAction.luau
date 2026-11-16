local parent = script:FindFirstAncestor("SduiSharedContent").Parent

require(parent.SduiCoreSystem)

local function isScalar(item): boolean -- 1 equivalent call inferred from this helper
	local typeName = typeof(item)
	return typeName == "string" or typeName == "number" or typeName == "boolean"
end

local function mergeScalars(p, actionParams, p2) -- 3 equivalent calls inferred from this helper
	if actionParams == nil then
		return
	end

	for k, item in actionParams do
		if p2 and p2[k] or not isScalar(item) then -- inferred equivalent call
			continue
		end

		p[k] = item
	end
end

local v = { eventName = true, eventFields = true }

local function SduiAnalyticsEventAction(p, p2, p3)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		return
	end

	local eventName = actionParams.eventName

	if typeof(eventName) ~= "string" or eventName == "" then
		return
	end

	local v2 = {}

	mergeScalars(v2, p2.ancestorAnalyticsData) -- inferred equivalent call
	mergeScalars(v2, p2.analyticsData) -- inferred equivalent call
	mergeScalars(v2, actionParams, v)

	local eventFields = actionParams.eventFields

	if typeof(eventFields) == "table" then
		mergeScalars(v2, eventFields) -- inferred equivalent call
	end

	p3.dependencies.eventIngest:sendEventDeferred(p3.appPage, eventName, v2)
end

return SduiAnalyticsEventAction
