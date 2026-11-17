local GuiService = game:GetService("GuiService")
local TelemetryService = game:GetService("TelemetryService")

local Home = script:FindFirstAncestor("Home")
local parent = Home.Parent

local React = require(parent.React)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore

local HomeConstants = require(Home.HomeConstants)

local v = { 3, 10 }
local v2 = {
	eventName = "sduiHomeStartupSnapshot",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("SduiHomeStartupSnapshotHundredthsPercent", 10000),
	lastUpdated = { 26, 11, 12 },
	description = "SDUI Home feed, mount and selection state shortly after Home mounts"
}

local function getSelectionBucket(ancestor): string -- 1 equivalent call inferred from this helper
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

	for _, guiObject in folder:GetDescendants() do
		if not (guiObject:IsA("GuiObject") and guiObject.Selectable and guiObject.Visible) then
			continue
		end

		count += 1

		if count >= 6 then
			return "6+"
		end
	end

	return if count == 0 then "0" else "1-5"
end

local function logSnapshot(stage: string, ancestor, p)
	local sduiApiStore = getSduiApiStore()
	local configKey = HomeConstants.ConfigKey
	local status = sduiApiStore.getData(configKey).status(false)
	TelemetryService:LogEvent(v2, {
		customFields = {
			stage = stage,
			status = status ~= "Ready" and status ~= "NotReady" and status ~= "Failed" and "unknown" or status,
			hasRoot = tostring(sduiApiStore.getRootConfig(configKey, false, HomeConstants.FeedEntryCacheKey) ~= nil),
			inFlight = tostring(sduiApiStore.isInFlight(configKey)),
			navFocused = not p and "unknown" or tostring(p.isFocused()),
			selection = getSelectionBucket(ancestor), -- inferred equivalent call
			selectables = getSelectableBucket(ancestor)
		},
		standardizedFields = { "addSessionInfo", "addOSInfo" }
	})
end

local function useHomeStartupSnapshot(current, current2)
	local ref = React.useRef(current)
	ref.current = current
	local ref2 = React.useRef(current2)
	ref2.current = current2

	React.useEffect(function()
		local v3 = {}

		for k, duration in v do
			v3[k] = task.delay(duration, function()
				v3[k] = nil
				pcall(logSnapshot, `{duration}s`, ref.current, ref2.current)
			end)
		end

		return function()
			for _, v4 in v3 do
				task.cancel(v4)
			end
		end
	end, {})
end

return useHomeStartupSnapshot
