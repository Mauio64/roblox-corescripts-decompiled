local SduiUsageAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/Analytics/SduiUsageAnalytics")

local defineFastInt = game:DefineFastInt("DiscoverySduiTypeUsageHundredthsPercent", 0)
local defineFastInt2 = game:DefineFastInt("DiscoverySduiParamUsageHundredthsPercent", 0)

local v5 = math.random(10000) <= defineFastInt
local v6 = math.random(10000) <= defineFastInt2

local v7 = {}

local v8 = {}

local function getOrCreateAccumulator(p2, p3)
	local v9 = v7[p2]

	if not v9 then
		v9 = {}
		v7[p2] = v9
	end

	local v10 = v9[p3]

	if v10 then
		return v10
	end

	local v11 = {
		types = {},
		props = {},
		actionTypes = {},
		actionParams = {},
		hasRecorded = false
	}

	v9[p3] = v11
	return v11
end

local function getOrCreateGlobalSeen(p2, p3)
	local v9 = v8[p2]

	if not v9 then
		v9 = {}
		v8[p2] = v9
	end

	local v10 = v9[p3]

	if v10 then
		return v10
	end

	local v11 = { types = {}, props = {}, actionTypes = {}, actionParams = {} }

	v9[p3] = v11
	return v11
end

local function deltaAndCommit(items, p2)
	local result = {}

	for k, item in items do
		if p2[k] then
			continue
		end

		result[k] = true
		p2[k] = true
	end

	return result
end

local function recordComponentType(p2, p3, p4)
	if not (v5 and p4) then
		return
	end

	local accumulator = getOrCreateAccumulator(p2, p3)

	if not accumulator.types[p4] then
		accumulator.types[p4] = true
		accumulator.hasRecorded = true
	end
end

local function recordProp(p2, p3, p4, p5)
	if not (v6 and p4 and p5) then
		return
	end

	local accumulator = getOrCreateAccumulator(p2, p3)
	local formatted = `{p4}.{p5}`

	if not accumulator.props[formatted] then
		accumulator.props[formatted] = true
		accumulator.hasRecorded = true
	end
end

local function recordActionType(p2, p3, p4)
	if not (v5 and p4) then
		return
	end

	local accumulator = getOrCreateAccumulator(p2, p3)

	if not accumulator.actionTypes[p4] then
		accumulator.actionTypes[p4] = true
		accumulator.hasRecorded = true
	end
end

local function recordActionParam(p2, p3, p4, p5)
	if not (v6 and p4 and p5) then
		return
	end

	local accumulator = getOrCreateAccumulator(p2, p3)
	local formatted = `{p4}.{p5}`

	if not accumulator.actionParams[formatted] then
		accumulator.actionParams[formatted] = true
		accumulator.hasRecorded = true
	end
end

local function flushPageVersion(page, version)
	local v9 = v7[page]
	local v10 = v9 and v9[version]

	if not (v10 and v10.hasRecorded) then
		return
	end

	local globalSeen = getOrCreateGlobalSeen(page, version)
	local v11 = deltaAndCommit(v10.types, globalSeen.types)
	local v12 = deltaAndCommit(v10.props, globalSeen.props)
	local v13 = deltaAndCommit(v10.actionTypes, globalSeen.actionTypes)
	local v14 = deltaAndCommit(v10.actionParams, globalSeen.actionParams)

	v9[version] = nil

	if next(v9) == nil then
		v7[page] = nil
	end

	if next(v11) ~= nil or next(v13) ~= nil then
		SduiUsageAnalytics.sendTypeUsageEvent({
			page = page,
			version = version,
			componentTypes = v11,
			actionTypes = v13
		})
	end

	if next(v12) ~= nil or next(v14) ~= nil then
		SduiUsageAnalytics.sendParamUsageEvent({
			page = page,
			version = version,
			props = v12,
			actionParams = v14
		})
	end
end

local function flushAll()
	local v9 = {}

	for k, v10 in v7 do
		for k2, v11 in v10 do
			table.insert(v9, { page = k, version = k2 })
		end
	end

	for k, v10 in v9 do
		flushPageVersion(v10.page, v10.version)
	end
end

local v9 = 1
local flag = false

local function scheduleFlush()
	if flag then
		return
	end

	flag = true
	task.delay(v9, function()
		flag = false
		flushAll()
	end)
end

local function isTypeSamplingEnabled()
	return v5
end

local function isParamSamplingEnabled()
	return v6
end

local function _resetAllForTesting()
	v7 = {}
	v8 = {}
	flag = false
end

local function _setSamplingForTesting(p2, p3)
	v5 = p2
	v6 = p3
end

local function _setFlushDelayForTesting(p2)
	v9 = p2
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
