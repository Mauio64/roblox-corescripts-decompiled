local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")

local SduiUsageAnalytics = require(SduiCoreSystem.Analytics.SduiUsageAnalytics)

local defineFastInt = game:DefineFastInt("DiscoverySduiTypeUsageHundredthsPercent", 0)
local defineFastInt2 = game:DefineFastInt("DiscoverySduiParamUsageHundredthsPercent", 0)

local v = math.random(10000) <= defineFastInt
local v2 = math.random(10000) <= defineFastInt2

local v3 = {}

local v4 = {}

local function getOrCreateAccumulator(p: string, p2: string)
	local v5 = v3[p]

	if not v5 then
		v5 = {}
		v3[p] = v5
	end

	local v6 = v5[p2]

	if v6 then
		return v6
	end

	local v7 = {
		types = {},
		props = {},
		actionTypes = {},
		actionParams = {},
		hasRecorded = false
	}

	v5[p2] = v7
	return v7
end

local function getOrCreateGlobalSeen(p: string, p2: string)
	local v5 = v4[p]

	if not v5 then
		v5 = {}
		v4[p] = v5
	end

	local v6 = v5[p2]

	if v6 then
		return v6
	end

	local v7 = { types = {}, props = {}, actionTypes = {}, actionParams = {} }

	v5[p2] = v7
	return v7
end

local function deltaAndCommit(items, p)
	local result = {}

	for k, _ in items do
		if p[k] then
			continue
		end

		result[k] = true
		p[k] = true
	end

	return result
end

local function recordComponentType(p: string, p2: string, p3: string?)
	if not (v and p3) then
		return
	end

	local accumulator = getOrCreateAccumulator(p, p2)

	if not accumulator.types[p3] then
		accumulator.types[p3] = true
		accumulator.hasRecorded = true
	end
end

local function recordProp(p: string, p2: string, p3: string?, p4: string?)
	if not (v2 and p3 and p4) then
		return
	end

	local accumulator = getOrCreateAccumulator(p, p2)
	local formatted = `{p3}.{p4}`

	if not accumulator.props[formatted] then
		accumulator.props[formatted] = true
		accumulator.hasRecorded = true
	end
end

local function recordActionType(p: string, p2: string, p3: string?)
	if not (v and p3) then
		return
	end

	local accumulator = getOrCreateAccumulator(p, p2)

	if not accumulator.actionTypes[p3] then
		accumulator.actionTypes[p3] = true
		accumulator.hasRecorded = true
	end
end

local function recordActionParam(p: string, p2: string, p3: string?, p4: string?)
	if not (v2 and p3 and p4) then
		return
	end

	local accumulator = getOrCreateAccumulator(p, p2)
	local formatted = `{p3}.{p4}`

	if not accumulator.actionParams[formatted] then
		accumulator.actionParams[formatted] = true
		accumulator.hasRecorded = true
	end
end

local function flushPageVersion(page: string, version: string)
	local v5 = v3[page]
	local v6 = v5 and v5[version]

	if not (v6 and v6.hasRecorded) then
		return
	end

	local globalSeen = getOrCreateGlobalSeen(page, version)
	local componentTypes = deltaAndCommit(v6.types, globalSeen.types)
	local props = deltaAndCommit(v6.props, globalSeen.props)
	local actionTypes = deltaAndCommit(v6.actionTypes, globalSeen.actionTypes)
	local actionParams = deltaAndCommit(v6.actionParams, globalSeen.actionParams)

	v5[version] = nil

	if next(v5) == nil then
		v3[page] = nil
	end

	if next(componentTypes) ~= nil or next(actionTypes) ~= nil then
		SduiUsageAnalytics.sendTypeUsageEvent({
			page = page,
			version = version,
			componentTypes = componentTypes,
			actionTypes = actionTypes
		})
	end

	if next(props) ~= nil or next(actionParams) ~= nil then
		SduiUsageAnalytics.sendParamUsageEvent({
			page = page,
			version = version,
			props = props,
			actionParams = actionParams
		})
	end
end

local function flushAll()
	local v5 = {}

	for k, v6 in v3 do
		for k2, _ in v6 do
			table.insert(v5, { page = k, version = k2 })
		end
	end

	for _, v6 in v5 do
		flushPageVersion(v6.page, v6.version)
	end
end

local v5 = 1
local flag = false

local function scheduleFlush()
	if flag then
		return
	end

	flag = true
	task.delay(v5, function()
		flag = false
		flushAll()
	end)
end

local function isTypeSamplingEnabled()
	return v
end

local function isParamSamplingEnabled()
	return v2
end

local function _resetAllForTesting()
	v3 = {}
	v4 = {}
	flag = false
end

local function _setSamplingForTesting(flag2: boolean, flag3: boolean)
	v = flag2
	v2 = flag3
end

local function _setFlushDelayForTesting(p: number)
	v5 = p
end

return {
	recordComponentType = recordComponentType,
	recordProp = recordProp,
	recordActionType = recordActionType,
	recordActionParam = recordActionParam,
	scheduleFlush = scheduleFlush,
	isTypeSamplingEnabled = isTypeSamplingEnabled,
	isParamSamplingEnabled = isParamSamplingEnabled,
	_flushAllForTesting = flushAll,
	_resetAllForTesting = _resetAllForTesting,
	_setSamplingForTesting = _setSamplingForTesting,
	_setFlushDelayForTesting = _setFlushDelayForTesting
}
