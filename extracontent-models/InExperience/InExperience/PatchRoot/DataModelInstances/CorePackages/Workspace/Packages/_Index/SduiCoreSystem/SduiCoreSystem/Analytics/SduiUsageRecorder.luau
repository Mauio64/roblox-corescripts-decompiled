local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local SduiUsageAnalytics = require(SduiCoreSystem.Analytics.SduiUsageAnalytics)
local FFlagSduiUsageTelemetry = require(SduiCoreSystemParent.SharedFlags).FFlagSduiUsageTelemetry
local v5 = game:DefineFastInt("DiscoverySduiTypeUsageHundredthsPercent", 0)
local v6 = game:DefineFastInt("DiscoverySduiParamUsageHundredthsPercent", 0)
local u7 = false
local u8 = false

if FFlagSduiUsageTelemetry then
	u7 = v5 >= math.random(10000)
	u8 = v6 >= math.random(10000)
end

local t1 = {}
local t2 = {}

local function getOrCreateAccumulator(s1: string, s2: string) -- line: 73
	-- upvalues: t1 (ref)
	local v20 = t1[s1]

	if not v20 then
		v20 = {}
		t1[s1] = v20
	end

	local v21 = v20[s2]

	if v21 then
		return v21
	end

	local t3 = {
		hasRecorded = false,
		types = {},
		props = {},
		actionTypes = {},
		actionParams = {}
	}

	v20[s2] = t3

	return t3
end
local function getOrCreateGlobalSeen(s3: string, s4: string) -- line: 94
	-- upvalues: t2 (ref)
	local v25 = t2[s3]

	if not v25 then
		v25 = {}
		t2[s3] = v25
	end

	local v26 = v25[s4]

	if v26 then
		return v26
	end

	local t4 = {
		types = {},
		props = {},
		actionTypes = {},
		actionParams = {}
	}

	v25[s4] = t4

	return t4
end
local function deltaAndCommit(t5: {[any]: any}, t6: {[any]: any}) -- line: 115
	local t7 = {}

	for v31, _ in t5 do
		if not t6[v31] then
			t7[v31] = true
			t6[v31] = true
		end
	end

	return t7
end
local function flushPageVersion(s5: string, s6: string) -- line: 172
	-- upvalues: t1 (ref), getOrCreateGlobalSeen (copy), deltaAndCommit (copy), SduiUsageAnalytics (copy)
	local v55 = t1[s5]
	local v56 = v55 and v55[s6]

	if not v56 or not v56.hasRecorded then
		return
	end

	local v57 = getOrCreateGlobalSeen(s5, s6)
	local v58 = deltaAndCommit(v56.types, v57.types)
	local v59 = deltaAndCommit(v56.props, v57.props)
	local v60 = deltaAndCommit(v56.actionTypes, v57.actionTypes)
	local v61 = deltaAndCommit(v56.actionParams, v57.actionParams)

	v55[s6] = nil

	if next(v55) == nil then
		t1[s5] = nil
	end

	if next(v58) ~= nil or next(v60) ~= nil then
		SduiUsageAnalytics.sendTypeUsageEvent({
			page = s5,
			version = s6,
			componentTypes = v58,
			actionTypes = v60
		})
	end

	if next(v59) ~= nil or next(v61) ~= nil then
		SduiUsageAnalytics.sendParamUsageEvent({
			page = s5,
			version = s6,
			props = v59,
			actionParams = v61
		})
	end
end
local function flushAll() -- line: 211
	-- upvalues: t1 (ref), flushPageVersion (copy)
	local t8 = {}

	for v63, v64 in t1 do
		for v65, _ in v64 do
			table.insert(t8, {
				page = v63,
				version = v65
			})
		end
	end

	for _, v68 in t8 do
		flushPageVersion(v68.page, v68.version)
	end
end

local n1 = 1
local u17 = false

return {
	recordComponentType = function(s7: string, s8: string, s9: string?) -- line: 126
		-- upvalues: u7 (ref), getOrCreateAccumulator (copy)
		if not u7 or not s9 then
			return
		end

		local v36 = getOrCreateAccumulator(s7, s8)

		if not v36.types[s9] then
			v36.types[s9] = true
			v36.hasRecorded = true
		end
	end,
	recordProp = function(s10: string, s11: string, s12: string?, s13: string?) -- line: 137
		-- upvalues: u8 (ref), getOrCreateAccumulator (copy)
		if not u8 or (not s12 or not s13) then
			return
		end

		local v41 = getOrCreateAccumulator(s10, s11)
		local v42 = `{ s12 }.{ s13 }`

		if not v41.props[v42] then
			v41.props[v42] = true
			v41.hasRecorded = true
		end
	end,
	recordActionType = function(s14: string, s15: string, s16: string?) -- line: 149
		-- upvalues: u7 (ref), getOrCreateAccumulator (copy)
		if not u7 or not s16 then
			return
		end

		local v46 = getOrCreateAccumulator(s14, s15)

		if not v46.actionTypes[s16] then
			v46.actionTypes[s16] = true
			v46.hasRecorded = true
		end
	end,
	recordActionParam = function(s17: string, s18: string, s19: string?, s20: string?) -- line: 160
		-- upvalues: u8 (ref), getOrCreateAccumulator (copy)
		if not u8 or (not s19 or not s20) then
			return
		end

		local v51 = getOrCreateAccumulator(s17, s18)
		local v52 = `{ s19 }.{ s20 }`

		if not v51.actionParams[v52] then
			v51.actionParams[v52] = true
			v51.hasRecorded = true
		end
	end,
	scheduleFlush = function() -- line: 228
		-- upvalues: u17 (ref), n1 (ref), flushAll (copy)
		if u17 then
			return
		end

		u17 = true
		task.delay(n1, function() -- line: 233
			-- upvalues: u17 (ref), flushAll (copy)
			u17 = false
			flushAll()
		end)
	end,
	isTypeSamplingEnabled = function() -- line: 239
		-- upvalues: u7 (ref)
		return u7
	end,
	isParamSamplingEnabled = function() -- line: 243
		-- upvalues: u8 (ref)
		return u8
	end,
	_flushAllForTesting = flushAll,
	_resetAllForTesting = function() -- line: 247
		-- upvalues: t1 (ref), t2 (ref), u17 (ref)
		t1 = {}
		t2 = {}
		u17 = false
	end,
	_setSamplingForTesting = function(b1: boolean, b2: boolean) -- line: 253
		-- upvalues: u7 (ref), u8 (ref)
		u7 = b1
		u8 = b2
	end,
	_setFlushDelayForTesting = function(n2: number) -- line: 258
		-- upvalues: n1 (ref)
		n1 = n2
	end
}
