local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiImpressionEventType = SduiCoreSystem.SduiImpressionEventType
local getSduiImpressionHandlerRegistry = SduiCoreSystem.getSduiImpressionHandlerRegistry

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiDevStoreSeeAllImpressionsLogging = SharedFlags.FFlagSduiDevStoreSeeAllImpressionsLogging
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiQueryImpressionsLogging = SharedFlags2.FFlagSduiQueryImpressionsLogging
local SharedFlags3 = require(parent.SharedFlags)
local FFlagSafetyResourceBannerTelemetry = SharedFlags3.FFlagSafetyResourceBannerTelemetry

local function registerDiscoveryImpressions()
	local v = {
		[SduiImpressionEventType.filterImpressions] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Impressions.SduiFilterImpressionsHandler)
			end,
			skipItemImpressionsLog = true
		},
		[SduiImpressionEventType.gameImpressions] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Impressions.SduiGameImpressionsHandler)
			end,
			skipItemImpressionsLog = false
		},
		[SduiImpressionEventType.socialLinksImpressions] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Impressions.SduiSocialLinksImpressionsHandler)
			end,
			skipItemImpressionsLog = false
		},
		[SduiImpressionEventType.virtualEventImpressions] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Impressions.SduiVirtualEventImpressionsHandler)
			end,
			skipItemImpressionsLog = false
		},
		[SduiImpressionEventType.experienceStoreImpressions] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Impressions.SduiEdpStoreImpressionsHandler)
			end,
			skipItemImpressionsLog = false
		},
		[SduiImpressionEventType.marketplaceItemImpressions] = {
			lazyHandler = function()
				return require(ServerDrivenUi.Impressions.SduiMarketplaceItemImpressionsHandler)
			end,
			skipItemImpressionsLog = false
		},
		[SduiImpressionEventType.devStoreSeeAllImpressions] = FFlagSduiDevStoreSeeAllImpressionsLogging and {
			lazyHandler = function()
				return require(ServerDrivenUi.Impressions.SduiDevStoreSeeAllImpressionsHandler)
			end,
			skipItemImpressionsLog = false
		} or nil,
		[SduiImpressionEventType.queryImpressions] = FFlagSduiQueryImpressionsLogging and {
			lazyHandler = function()
				return require(ServerDrivenUi.Impressions.SduiQueryImpressionsHandler)
			end,
			skipItemImpressionsLog = true
		} or nil,
		[SduiImpressionEventType.safetyResourceBannerImpressions] = FFlagSafetyResourceBannerTelemetry and {
			lazyHandler = function()
				return require(ServerDrivenUi.Impressions.SduiSafetyResourceBannerImpressionsHandler)
			end,
			skipItemImpressionsLog = true
		} or nil
	}

	getSduiImpressionHandlerRegistry().registerImpressionHandlerConfigs(v)
end

return registerDiscoveryImpressions
