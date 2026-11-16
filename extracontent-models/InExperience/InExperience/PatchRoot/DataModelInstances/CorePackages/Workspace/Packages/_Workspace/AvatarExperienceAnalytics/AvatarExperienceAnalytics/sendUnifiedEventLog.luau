local SessionService = game:GetService("SessionService")
local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

local Cryo = require(parent.Cryo)
local AppCommonLib = require(parent.AppCommonLib)
local isRunningInStudio = AppCommonLib.isRunningInStudio
local DebugPanel = require(parent.DebugPanel)
local Devices = require(parent.Devices)
local DeviceTier = Devices.DeviceTier

local AnalyticsService = require(script.Parent.AnalyticsService)
local UnifiedEventLogConstants = require(script.Parent.UnifiedEventLogConstants)
local UnifiedEventPageStore = require(script.Parent.Store.UnifiedEventPageStore)
local UnifiedEventCounterAggregator = require(script.Parent.Lib.UnifiedEventCounterAggregator)
local AXUnifiedEventFilter = require(script.Parent.AXUnifiedEventFilter)
require(script.Parent.Generated.UnifiedEventTypes)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXSendUnifiedEventLogWithInstance = AvatarExperienceFlags.FFlagAXSendUnifiedEventLogWithInstance
local FFlagAXDebugPanelImpressed = AvatarExperienceFlags.FFlagAXDebugPanelImpressed
local FFlagAXUnifiedEventPageContext = AvatarExperienceFlags.FFlagAXUnifiedEventPageContext
local FFlagAXUnifiedEventCounters = AvatarExperienceFlags.FFlagAXUnifiedEventCounters
local FFlagAXUnifiedEventDeviceTier = AvatarExperienceFlags.FFlagAXUnifiedEventDeviceTier
local FFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads

local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface

local defineFastFlag = game:DefineFastFlag("AXSendUnifiedEventsInStudio", false)
local v

if FFlagAXUnifiedEventDeviceTier then
	v = DeviceTier.GetDeviceMemoryTier()
else
	v = nil
end

return function(fields, instance, p)
	if FFlagAXUnifiedEventPageContext then
		local sessionTag = SessionService:GetSessionTag("level2a")
		local pageFields = UnifiedEventPageStore.getPageFields()
		local join = Cryo.Dictionary.join
		local v2 = {
			navigationPage = pageFields.navigationPage,
			navigationOpaquePage = pageFields.navigationOpaquePage,
			sessionTag = 0
		}

		if sessionTag == nil or sessionTag == "" then
			sessionTag = UnifiedEventPageStore.UNKNOWN
		end

		v2.sessionTag = sessionTag
		fields = join(v2, fields)
	end

	if FFlagAXUnifiedEventDeviceTier then
		fields = Cryo.Dictionary.join({
			deviceTier = v or "Unknown"
		}, fields)
	end

	if FFlagAXUnifiedEventStrictPayloads and fields.surface == nil then
		fields = Cryo.Dictionary.join(fields, { surface = UnifiedLoggingSurface.UNDEFINED_SURFACE })
	end

	if FFlagAXDebugPanelImpressed then
		local notify = DebugPanel.AnalyticsFeed.notify

		if not FFlagAXSendUnifiedEventLogWithInstance then
			instance = nil
		end

		notify({
			feedId = "ax.marketplaceLogging",
			fields = fields,
			instance = instance,
			eventName = UnifiedEventLogConstants.EVENT_NAME,
			ctx = UnifiedEventLogConstants.EVENT_NAME
		})
	end

	if isRunningInStudio() and not defineFastFlag then
		return
	end

	if FFlagAXUnifiedEventCounters then
		local v2

		if p == nil or p.filterPassed == nil then
			v2 = AXUnifiedEventFilter.filter(fields, { skipReporting = true })
		else
			v2 = p.filterPassed
		end

		UnifiedEventCounterAggregator.record(fields, v2)
	end

	AnalyticsService.EventStream:sendTelemetryEvent(
		UnifiedEventLogConstants.EVENT_NAME,
		UnifiedEventLogConstants.EVENT_NAME,
		fields
	)
end
