local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiImpressionEventType = SduiCoreSystem.SduiImpressionEventType
local getSduiImpressionHandlerRegistry = SduiCoreSystem.getSduiImpressionHandlerRegistry

local fFlagSduiDevStoreSeeAllImpressionsLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiDevStoreSeeAllImpressionsLogging
local fFlagSduiQueryImpressionsLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiQueryImpressionsLogging
local fFlagSafetyResourceBannerTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSafetyResourceBannerTelemetry

local function registerDiscoveryImpressions()
	local v5 = {
		[sduiImpressionEventType.filterImpressions] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Impressions/SduiFilterImpressionsHandler")
			end,
			skipItemImpressionsLog = true
		},
		[sduiImpressionEventType.gameImpressions] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Impressions/SduiGameImpressionsHandler")
			end,
			skipItemImpressionsLog = false
		},
		[sduiImpressionEventType.socialLinksImpressions] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Impressions/SduiSocialLinksImpressionsHandler")
			end,
			skipItemImpressionsLog = false
		},
		[sduiImpressionEventType.virtualEventImpressions] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Impressions/SduiVirtualEventImpressionsHandler")
			end,
			skipItemImpressionsLog = false
		},
		[sduiImpressionEventType.experienceStoreImpressions] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Impressions/SduiEdpStoreImpressionsHandler")
			end,
			skipItemImpressionsLog = false
		},
		[sduiImpressionEventType.marketplaceItemImpressions] = {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Impressions/SduiMarketplaceItemImpressionsHandler")
			end,
			skipItemImpressionsLog = false
		},
		[sduiImpressionEventType.devStoreSeeAllImpressions] = fFlagSduiDevStoreSeeAllImpressionsLogging and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Impressions/SduiDevStoreSeeAllImpressionsHandler")
			end,
			skipItemImpressionsLog = false
		} or nil,
		[sduiImpressionEventType.queryImpressions] = fFlagSduiQueryImpressionsLogging and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Impressions/SduiQueryImpressionsHandler")
			end,
			skipItemImpressionsLog = true
		} or nil,
		[sduiImpressionEventType.safetyResourceBannerImpressions] = fFlagSafetyResourceBannerTelemetry and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Impressions/SduiSafetyResourceBannerImpressionsHandler")
			end,
			skipItemImpressionsLog = true
		} or nil
	}

	getSduiImpressionHandlerRegistry().registerImpressionHandlerConfigs(v5)
end

return registerDiscoveryImpressions
