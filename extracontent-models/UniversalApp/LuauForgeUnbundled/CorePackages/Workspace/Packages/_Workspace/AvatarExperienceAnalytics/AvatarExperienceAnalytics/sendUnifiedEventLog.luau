local SessionService = game:GetService("SessionService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/Cryo")
local isRunningInStudio = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AppCommonLib").isRunningInStudio
local DebugPanel = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/DebugPanel")
local deviceTier = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/Devices").DeviceTier

local AnalyticsService = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/AnalyticsService")
local UnifiedEventLogConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogConstants")
local UnifiedEventPageStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Store/UnifiedEventPageStore")
local UnifiedEventCounterAggregator = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Lib/UnifiedEventCounterAggregator")
local AXUnifiedEventFilter = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/AXUnifiedEventFilter")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Generated/UnifiedEventTypes")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceFlags")
local fFlagAXSendUnifiedEventLogWithInstance = AvatarExperienceFlags.FFlagAXSendUnifiedEventLogWithInstance
local fFlagAXDebugPanelImpressed = AvatarExperienceFlags.FFlagAXDebugPanelImpressed
local fFlagAXUnifiedEventPageContext = AvatarExperienceFlags.FFlagAXUnifiedEventPageContext
local fFlagAXUnifiedEventCounters = AvatarExperienceFlags.FFlagAXUnifiedEventCounters
local fFlagAXUnifiedEventDeviceTier = AvatarExperienceFlags.FFlagAXUnifiedEventDeviceTier
local fFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads

local unifiedLoggingSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceNavigation").Enums.UnifiedLoggingSurface

local defineFastFlag = game:DefineFastFlag("AXSendUnifiedEventsInStudio", false)

local v5 = if fFlagAXUnifiedEventDeviceTier then deviceTier.GetDeviceMemoryTier() else nil

return function(p2, instance, p3)
	if fFlagAXUnifiedEventPageContext then
		local v6 = SessionService:GetSessionTag("level2a")
		local pageFields = UnifiedEventPageStore.getPageFields()
		local join = Cryo.Dictionary.join
		local v7 = {
			navigationPage = pageFields.navigationPage,
			navigationOpaquePage = pageFields.navigationOpaquePage,
			sessionTag = 0
		}

		if v6 == nil or v6 == "" then
			v6 = UnifiedEventPageStore.UNKNOWN
		end

		v7.sessionTag = v6
		p2 = join(v7, p2)
	end

	if fFlagAXUnifiedEventDeviceTier then
		p2 = Cryo.Dictionary.join({
			deviceTier = v5 or "Unknown"
		}, p2)
	end

	if fFlagAXUnifiedEventStrictPayloads and p2.surface == nil then
		p2 = Cryo.Dictionary.join(p2, {
			surface = unifiedLoggingSurface.UNDEFINED_SURFACE
		})
	end

	if fFlagAXDebugPanelImpressed then
		local notify = DebugPanel.AnalyticsFeed.notify

		if not fFlagAXSendUnifiedEventLogWithInstance then
			instance = nil
		end

		notify({
			feedId = "ax.marketplaceLogging",
			fields = p2,
			instance = instance,
			eventName = UnifiedEventLogConstants.EVENT_NAME,
			ctx = UnifiedEventLogConstants.EVENT_NAME
		})
	end

	if isRunningInStudio() and not defineFastFlag then
		return
	end

	if fFlagAXUnifiedEventCounters then
		local v6 = if p3 == nil or p3.filterPassed == nil then AXUnifiedEventFilter.filter(p2, {
			skipReporting = true
		}) else p3.filterPassed
		UnifiedEventCounterAggregator.record(p2, v6)
	end

	AnalyticsService.EventStream:sendTelemetryEvent(UnifiedEventLogConstants.EVENT_NAME, UnifiedEventLogConstants.EVENT_NAME, p2)
end
