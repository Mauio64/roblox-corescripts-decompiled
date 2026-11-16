local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

local UnifiedEventLogEnums = require(script.Parent.Parent.UnifiedEventLogEnums)
require(script.Parent.Parent.Generated.UnifiedEventTypes)
local MarketplaceUnifiedAction = UnifiedEventLogEnums.MarketplaceUnifiedAction
local v = UnifiedEventLogEnums.MarketplaceUnifiedActionNumbers
local sendAXCounterV2 = require(script.Parent.Parent.sendAXCounterV2)

local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface

local AppCommonLib = require(parent.AppCommonLib)
local isRunningInStudio = AppCommonLib.isRunningInStudio

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FIntAXUnifiedEventCounterFlushSeconds = AvatarExperienceFlags.FIntAXUnifiedEventCounterFlushSeconds

local FIntAXUnifiedEventCounterImpressionFlushSeconds = AvatarExperienceFlags.FIntAXUnifiedEventCounterImpressionFlushSeconds
local FIntAXUnifiedEventCounterMaxKeys = AvatarExperienceFlags.FIntAXUnifiedEventCounterMaxKeys
local FIntAXUnifiedEventCounterIdleSeconds = AvatarExperienceFlags.FIntAXUnifiedEventCounterIdleSeconds
local FFlagAXUnifiedEventCounterDebugLogs = AvatarExperienceFlags.FFlagAXUnifiedEventCounterDebugLogs
local FFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads

local set = {
	[MarketplaceUnifiedAction.PURCHASE_ATTEMPT] = true,
	[MarketplaceUnifiedAction.PURCHASE_SUCCESS] = true
}

local set2 = {
	[MarketplaceUnifiedAction.ITEM_IMPRESSION] = true,
	[MarketplaceUnifiedAction.WIDGET_IMPRESSION] = true,
	[MarketplaceUnifiedAction.UI_ELEMENT_IMPRESSION] = true,
	[MarketplaceUnifiedAction.WIDGET_LOADED] = true
}

local UnifiedEventCounterAggregator = {}

local function newWindow(label: string, maxSeconds: number, tracksPhase: boolean)
	return {
		label = label,
		maxSeconds = maxSeconds,
		buckets = {},
		keyCount = 0,
		pendingFlush = nil,
		recordCount = 0,
		armedAtCount = 0,
		waitedSeconds = 0,
		tracksPhase = tracksPhase
	}
end

local v2 = newWindow("short", FIntAXUnifiedEventCounterFlushSeconds, false)
local v3 = newWindow("long", FIntAXUnifiedEventCounterImpressionFlushSeconds, true)

local v4 = nil
local set3 = {}

local function invertEnum(items)
	local result = {}

	for k, item in items do
		result[tostring(item)] = tostring(k)
	end

	return result
end

if not FFlagAXUnifiedEventStrictPayloads then
	v = MarketplaceUnifiedAction
end

local v5 = invertEnum(v)

local v6 = invertEnum(UnifiedLoggingSurface)

local function toDimensionString(p: string?) -- 2 equivalent calls inferred from this helper
	if p == nil or p == "" then
		return "Unknown"
	end

	return (tostring(p))
end

local function toElementNameDimension(elementName: string?)
	local elementNameDimension = toDimensionString(elementName) -- inferred equivalent call

	while true do
		local v7 = string.gsub(elementNameDimension, "[_:%-]%d+$", "")

		if v7 == elementNameDimension or v7 == "" then
			return elementNameDimension
		end

		elementNameDimension = v7
	end
end

local function toEnumName(p, p2) -- 2 equivalent calls inferred from this helper
	if FFlagAXUnifiedEventStrictPayloads then
		local v7 = p == nil and "" or tostring(p)

		if v7 == "" then
			return "Unknown"
		end

		return p2[v7] or v7
	else
		if p == nil or p == "" then
			return "Unknown"
		end

		local v7 = tostring(p)
		return p2[v7] or v7
	end
end

local function debugEnabled() -- 5 equivalent calls inferred from this helper
	return FFlagAXUnifiedEventCounterDebugLogs and isRunningInStudio()
end

local function describe(data)
	return string.format(
		"action=%s surface=%s page=%s element=%s filterPass=%s",
		data.action,
		data.surface,
		data.navigationPage,
		data.elementName or "-",
		data.filterPass or "-"
	)
end

local function bucketKey(data)
	return table.concat({
		data.action,
		data.surface,
		data.navigationPage,
		data.elementName or "",
		data.filterPass or ""
	}, "|")
end

local function peekPhase(p: string): string -- 3 equivalent calls inferred from this helper
	return if set3[p] then "Continued" else "Initial"
end

local function takePhase(p: string)
	local v7 = peekPhase(p) -- inferred equivalent call
	set3[p] = true
	return v7
end

local function emit(data, p: number, phase: string?)
	local v7 = {
		action = data.action,
		surface = data.surface,
		navigationPage = data.navigationPage
	}

	if data.elementName ~= nil then
		v7.elementName = data.elementName
	end

	if data.filterPass ~= nil then
		v7.filterPass = data.filterPass
	end

	if phase ~= nil then
		v7.phase = phase
	end

	if debugEnabled() then -- inferred equivalent call
		print(string.format(
			"%s SEND increment=%d phase=%s %s",
			"[AXUnifiedEventCounters]",
			p,
			phase or "-",
			describe(data)
		))
	end

	sendAXCounterV2("AXUnifiedEventSent", v7, p)
end

local function flushWindow(state)
	if state.pendingFlush ~= nil then
		task.cancel(state.pendingFlush)
		state.pendingFlush = nil
	end

	local buckets = state.buckets
	local keyCount = state.keyCount
	state.buckets = {}
	state.keyCount = 0
	state.waitedSeconds = 0

	if debugEnabled() and keyCount > 0 then -- inferred equivalent call
		print(string.format("%s FLUSH %s %d key(s)", "[AXUnifiedEventCounters]", state.label, keyCount))
	end

	for k, bucket in buckets do
		local dimensions = bucket.dimensions
		local count = bucket.count
		local v7

		if state.tracksPhase then
			v7 = peekPhase(k) -- inferred equivalent call
			set3[k] = true
		end

		emit(dimensions, count, v7)
	end
end

function UnifiedEventCounterAggregator.flush()
	flushWindow(v2)
	flushWindow(v3)
end

local function scheduleFlush(state)
	if state.pendingFlush ~= nil then
		return
	end

	local v7 = math.max(FIntAXUnifiedEventCounterIdleSeconds, 1)

	if debugEnabled() and state.waitedSeconds == 0 then -- inferred equivalent call
		print(string.format(
			"%s SCHEDULE %s idle=%ds max=%ds",
			"[AXUnifiedEventCounters]",
			state.label,
			v7,
			state.maxSeconds
		))
	end

	state.armedAtCount = state.recordCount
	state.pendingFlush = task.delay(v7, function()
		state.pendingFlush = nil
		state.waitedSeconds += v7

		local v8 = state.recordCount == state.armedAtCount

		if not (v8 or state.waitedSeconds >= state.maxSeconds) then
			scheduleFlush(state)
			return
		end

		if debugEnabled() then -- inferred equivalent call
			print(string.format(
				"%s CLOSE %s after %ds (%s)",
				"[AXUnifiedEventCounters]",
				state.label,
				state.waitedSeconds,
				v8 and "idle" or "max"
			))
		end

		flushWindow(state)
	end)
end

function UnifiedEventCounterAggregator.record(data, flag: boolean?)
	local action = data.action

	if action == nil then
		return
	end

	local navigationOpaquePage = data.navigationOpaquePage or data.navigationPage

	if navigationOpaquePage ~= nil and navigationOpaquePage ~= v4 then
		v4 = navigationOpaquePage
		set3 = {}
	end

	local dimensions = {
		action = toEnumName(action, v5), -- inferred equivalent call
		surface = toEnumName(data.surface, v6), -- inferred equivalent call
		navigationPage = toDimensionString(data.navigationPage), -- inferred equivalent call
		elementName = 0,
		filterPass = 0
	}
	local elementName

	if action == MarketplaceUnifiedAction.UI_ELEMENT_CLICK then
		elementName = toElementNameDimension(data.elementName)
	end

	dimensions.elementName = elementName
	local filterPass

	if flag ~= nil then
		filterPass = tostring(flag)
	end

	dimensions.filterPass = filterPass

	if set[action] then
		emit(dimensions, 1)
		return
	end

	local v7 = if set2[action] then v3 else v2
	v7.recordCount += 1

	local v8 = bucketKey(dimensions)
	local bucket = v7.buckets[v8]

	if bucket == nil then
		v7.buckets[v8] = { dimensions = dimensions, count = 1 }
		v7.keyCount += 1

		if debugEnabled() then -- inferred equivalent call
			print(string.format(
				"%s OPEN %s bucket (%d open) phase=%s %s",
				"[AXUnifiedEventCounters]",
				v7.label,
				v7.keyCount,
				v7.tracksPhase and peekPhase(v8) or "-", -- inferred equivalent call
				describe(dimensions)
			))
		end
	else
		bucket.count += 1
	end

	if FIntAXUnifiedEventCounterMaxKeys <= v7.keyCount then
		flushWindow(v7)
	else
		scheduleFlush(v7)
	end
end

return UnifiedEventCounterAggregator
