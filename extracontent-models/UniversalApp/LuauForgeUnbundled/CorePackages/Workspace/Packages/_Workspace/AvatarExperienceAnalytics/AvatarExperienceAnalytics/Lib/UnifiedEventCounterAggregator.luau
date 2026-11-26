local UnifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogEnums")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Generated/UnifiedEventTypes")
local marketplaceUnifiedAction = UnifiedEventLogEnums.MarketplaceUnifiedAction
local v5 = UnifiedEventLogEnums.MarketplaceUnifiedActionNumbers
local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/sendAXCounterV2")

local unifiedLoggingSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceNavigation").Enums.UnifiedLoggingSurface

local isRunningInStudio = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AppCommonLib").isRunningInStudio

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceFlags")
local fIntAXUnifiedEventCounterFlushSeconds = AvatarExperienceFlags.FIntAXUnifiedEventCounterFlushSeconds

local fIntAXUnifiedEventCounterImpressionFlushSeconds = AvatarExperienceFlags.FIntAXUnifiedEventCounterImpressionFlushSeconds
local fIntAXUnifiedEventCounterMaxKeys = AvatarExperienceFlags.FIntAXUnifiedEventCounterMaxKeys
local fIntAXUnifiedEventCounterIdleSeconds = AvatarExperienceFlags.FIntAXUnifiedEventCounterIdleSeconds
local fFlagAXUnifiedEventCounterDebugLogs = AvatarExperienceFlags.FFlagAXUnifiedEventCounterDebugLogs
local fFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads

local set = {
	[marketplaceUnifiedAction.PURCHASE_ATTEMPT] = true,
	[marketplaceUnifiedAction.PURCHASE_SUCCESS] = true
}

local set2 = {
	[marketplaceUnifiedAction.ITEM_IMPRESSION] = true,
	[marketplaceUnifiedAction.WIDGET_IMPRESSION] = true,
	[marketplaceUnifiedAction.UI_ELEMENT_IMPRESSION] = true,
	[marketplaceUnifiedAction.WIDGET_LOADED] = true
}

local v6 = {}

local function newWindow(p2, p3, p4)
	return {
		label = p2,
		maxSeconds = p3,
		buckets = {},
		keyCount = 0,
		pendingFlush = nil,
		recordCount = 0,
		armedAtCount = 0,
		waitedSeconds = 0,
		tracksPhase = p4
	}
end

local v7 = newWindow("short", fIntAXUnifiedEventCounterFlushSeconds, false)
local v8 = newWindow("long", fIntAXUnifiedEventCounterImpressionFlushSeconds, true)

local v9 = nil
local set3 = {}

local function invertEnum(items)
	local result = {}

	for k, item in items do
		result[tostring(item)] = tostring(k)
	end

	return result
end

if not fFlagAXUnifiedEventStrictPayloads then
	v5 = marketplaceUnifiedAction
end

local v10 = invertEnum(v5)

local v11 = invertEnum(unifiedLoggingSurface)

local function toDimensionString(p2)
	if p2 == nil or p2 == "" then
		return "Unknown"
	end

	return (tostring(p2))
end

local function toElementNameDimension(elementName)
	local elementNameDimension = (elementName == nil or elementName == "") and "Unknown"
		or tostring(elementName)

	while true do
		local v12 = string.gsub(elementNameDimension, "[_:%-]%d+$", "")

		if v12 == elementNameDimension or v12 == "" then
			return elementNameDimension
		end

		elementNameDimension = v12
	end
end

local function toEnumName(p2, p3)
	if fFlagAXUnifiedEventStrictPayloads then
		local v12 = p2 == nil and "" or tostring(p2)

		if v12 == "" then
			return "Unknown"
		end

		return p3[v12] or v12
	else
		if p2 == nil or p2 == "" then
			return "Unknown"
		end

		local v12 = tostring(p2)
		return p3[v12] or v12
	end
end

local function debugEnabled()
	return fFlagAXUnifiedEventCounterDebugLogs and isRunningInStudio()
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

local function peekPhase(p2): string
	if set3[p2] then
		return "Continued"
	end

	return "Initial"
end

local function takePhase(p2)
	local v12 = set3[p2] and "Continued" or "Initial"

	set3[p2] = true
	return v12
end

local function emit(data, p2, phase)
	local v12 = {
		action = data.action,
		surface = data.surface,
		navigationPage = data.navigationPage
	}

	if data.elementName ~= nil then
		v12.elementName = data.elementName
	end

	if data.filterPass ~= nil then
		v12.filterPass = data.filterPass
	end

	if phase ~= nil then
		v12.phase = phase
	end

	if fFlagAXUnifiedEventCounterDebugLogs and isRunningInStudio() then
		print(string.format(
			"%s SEND increment=%d phase=%s %s",
			"[AXUnifiedEventCounters]",
			p2,
			phase or "-",
			describe(data)
		))
	end

	sendAXCounterV2("AXUnifiedEventSent", v12, p2)
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

	if fFlagAXUnifiedEventCounterDebugLogs and isRunningInStudio() and keyCount > 0 then
		print(string.format("%s FLUSH %s %d key(s)", "[AXUnifiedEventCounters]", state.label, keyCount))
	end

	for k, bucket in buckets do
		local dimensions = bucket.dimensions
		local count = bucket.count
		local v13

		if state.tracksPhase then
			v13 = set3[k] and "Continued" or "Initial"

			set3[k] = true
		end

		emit(dimensions, count, v13)
	end
end

function v6.flush()
	flushWindow(v7)
	flushWindow(v8)
end

local function scheduleFlush(state)
	if state.pendingFlush ~= nil then
		return
	end

	local v12 = math.max(fIntAXUnifiedEventCounterIdleSeconds, 1)

	if fFlagAXUnifiedEventCounterDebugLogs and isRunningInStudio() and state.waitedSeconds == 0 then
		print(string.format(
			"%s SCHEDULE %s idle=%ds max=%ds",
			"[AXUnifiedEventCounters]",
			state.label,
			v12,
			state.maxSeconds
		))
	end

	state.armedAtCount = state.recordCount
	state.pendingFlush = task.delay(v12, function()
		state.pendingFlush = nil
		state.waitedSeconds += v12

		local v14 = state.recordCount == state.armedAtCount

		if not (v14 or state.waitedSeconds >= state.maxSeconds) then
			scheduleFlush(state)
			return
		end

		if fFlagAXUnifiedEventCounterDebugLogs and isRunningInStudio() then
			print(string.format(
				"%s CLOSE %s after %ds (%s)",
				"[AXUnifiedEventCounters]",
				state.label,
				state.waitedSeconds,
				v14 and "idle" or "max"
			))
		end

		flushWindow(state)
	end)
end

function v6.record(data, p2)
	local action = data.action

	if action == nil then
		return
	end

	local navigationOpaquePage = data.navigationOpaquePage or data.navigationPage

	if navigationOpaquePage ~= nil and navigationOpaquePage ~= v9 then
		v9 = navigationOpaquePage
		set3 = {}
	end

	local v13 = v10
	local v14

	if fFlagAXUnifiedEventStrictPayloads then
		local v15 = action == nil and "" or tostring(action)
		v14 = v15 == "" and "Unknown" or v13[v15] or v15
	elseif action == nil or action == "" then
		v14 = "Unknown"
	else
		local v15 = tostring(action)
		v14 = v13[v15] or v15
	end

	local surface = data.surface
	local v15 = v11
	local v16

	if fFlagAXUnifiedEventStrictPayloads then
		local v17 = surface == nil and "" or tostring(surface)
		v16 = v17 == "" and "Unknown" or v15[v17] or v17
	elseif surface == nil or surface == "" then
		v16 = "Unknown"
	else
		local v17 = tostring(surface)
		v16 = v15[v17] or v17
	end

	local navigationPage = data.navigationPage
	local v12 = {
		action = v14,
		surface = v16,
		navigationPage = (navigationPage == nil or navigationPage == "") and "Unknown" or tostring(navigationPage),
		elementName = 0,
		filterPass = 0
	}

	local v17 = if action == marketplaceUnifiedAction.UI_ELEMENT_CLICK then toElementNameDimension(data.elementName) else nil
	v12.elementName = v17

	local v18 = if p2 ~= nil then tostring(p2) else nil
	v12.filterPass = v18

	if set[action] then
		emit(v12, 1)
		return
	end

	local v19 = if set2[action] then v8 else v7
	v19.recordCount += 1

	local v20 = bucketKey(v12)
	local bucket = v19.buckets[v20]

	if bucket == nil then
		v19.buckets[v20] = { dimensions = v12, count = 1 }
		v19.keyCount += 1

		if fFlagAXUnifiedEventCounterDebugLogs and isRunningInStudio() then
			print(string.format(
				"%s OPEN %s bucket (%d open) phase=%s %s",
				"[AXUnifiedEventCounters]",
				v19.label,
				v19.keyCount,
				v19.tracksPhase and (set3[v20] and "Continued" or "Initial") or "-",
				describe(v12)
			))
		end
	else
		bucket.count += 1
	end

	if fIntAXUnifiedEventCounterMaxKeys <= v19.keyCount then
		flushWindow(v19)
	else
		scheduleFlush(v19)
	end
end

return v6
