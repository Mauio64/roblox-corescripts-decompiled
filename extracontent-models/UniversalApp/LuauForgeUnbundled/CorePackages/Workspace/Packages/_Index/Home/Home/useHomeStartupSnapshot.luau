local GuiService = game:GetService("GuiService")
local TelemetryService = game:GetService("TelemetryService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/React")
local getSduiApiStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SduiSharedUtilities").getSduiApiStore

local HomeConstants = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/HomeConstants")

local v5 = { 3, 10 }
local v6 = {
	eventName = "sduiHomeStartupSnapshot",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("SduiHomeStartupSnapshotHundredthsPercent", 10000),
	lastUpdated = { 26, 11, 12 },
	description = "SDUI Home feed, mount and selection state shortly after Home mounts"
}

local function getSelectionBucket(ancestor): string
	local selectedCoreObject = GuiService.SelectedCoreObject or GuiService.SelectedObject

	if selectedCoreObject == nil then
		return "none"
	end

	if ancestor and selectedCoreObject:IsDescendantOf(ancestor) then
		return "home"
	end

	return "outside"
end

local function getSelectableBucket(folder): string
	if folder == nil then
		return "noFrame"
	end

	local count = 0

	for i, guiObject in folder:GetDescendants() do
		if not (guiObject:IsA("GuiObject") and guiObject.Selectable and guiObject.Visible) then
			continue
		end

		count += 1

		if count >= 6 then
			return "6+"
		end
	end

	if count == 0 then
		return "0"
	end

	return "1-5"
end

local function logSnapshot(p2, ancestor, p3)
	local sduiApiStore = getSduiApiStore()
	local configKey = HomeConstants.ConfigKey
	local status = sduiApiStore.getData(configKey).status(false)

	local v10 = {
		stage = p2,
		status = status ~= "Ready" and status ~= "NotReady" and status ~= "Failed" and "unknown" or status,
		hasRoot = tostring(sduiApiStore.getRootConfig(configKey, false, HomeConstants.FeedEntryCacheKey) ~= nil),
		inFlight = tostring(sduiApiStore.isInFlight(configKey)),
		navFocused = not p3 and "unknown" or tostring(p3.isFocused()),
		selection = 0,
		selectables = 0
	}
	local selectedCoreObject = GuiService.SelectedCoreObject or GuiService.SelectedObject
	v10.selection = selectedCoreObject == nil and "none"
		or ancestor and selectedCoreObject:IsDescendantOf(ancestor) and "home"
		or "outside"
	v10.selectables = getSelectableBucket(ancestor)
	TelemetryService:LogEvent(v6, {
		customFields = v10,
		standardizedFields = { "addSessionInfo", "addOSInfo" }
	})
end

local function useHomeStartupSnapshot(current, current2)
	local ref = React.useRef(current)
	ref.current = current
	local ref2 = React.useRef(current2)
	ref2.current = current2

	React.useEffect(function()
		local v7 = {}

		for k, duration in v5 do
			v7[k] = task.delay(duration, function()
				v7[k] = nil
				pcall(logSnapshot, `{duration}s`, ref.current, ref2.current)
			end)
		end

		return function()
			for k, v8 in v7 do
				task.cancel(v8)
			end
		end
	end, {})
end

return useHomeStartupSnapshot
