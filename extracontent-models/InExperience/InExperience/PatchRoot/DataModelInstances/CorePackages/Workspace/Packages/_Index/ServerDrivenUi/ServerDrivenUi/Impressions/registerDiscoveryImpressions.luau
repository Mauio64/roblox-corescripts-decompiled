local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
local SduiImpressionEventType = SduiCoreSystem.SduiImpressionEventType
local getSduiImpressionHandlerRegistry = SduiCoreSystem.getSduiImpressionHandlerRegistry
local FFlagSduiChartsSupport = require(ServerDrivenUiParent.SharedFlags).FFlagSduiChartsSupport
local FFlagSduiExperienceDetailsSupport = require(ServerDrivenUiParent.SharedFlags).FFlagSduiExperienceDetailsSupport
local FFlagSduiEdpStoreImpressionsLogging = require(ServerDrivenUiParent.SharedFlags).FFlagSduiEdpStoreImpressionsLogging
local FFlagSduiDevStoreSeeAllImpressionsLogging = require(ServerDrivenUiParent.SharedFlags).FFlagSduiDevStoreSeeAllImpressionsLogging

local function registerDiscoveryImpressions() -- line: 17
	-- upvalues: SduiImpressionEventType (copy), FFlagSduiChartsSupport (copy), ServerDrivenUi (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiEdpStoreImpressionsLogging (copy), FFlagSduiDevStoreSeeAllImpressionsLogging (copy), getSduiImpressionHandlerRegistry (copy)
	local t1 = {
		[SduiImpressionEventType.filterImpressions] = if not FFlagSduiChartsSupport then nil else {
			skipItemImpressionsLog = true,
			lazyHandler = function() -- line: 21
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Impressions.SduiFilterImpressionsHandler)
			end
		},
		[SduiImpressionEventType.gameImpressions] = {
			skipItemImpressionsLog = false,
			lazyHandler = function() -- line: 28
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Impressions.SduiGameImpressionsHandler)
			end
		},
		[SduiImpressionEventType.socialLinksImpressions] = if not FFlagSduiExperienceDetailsSupport then nil else {
			skipItemImpressionsLog = false,
			lazyHandler = function() -- line: 35
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Impressions.SduiSocialLinksImpressionsHandler)
			end
		},
		[SduiImpressionEventType.virtualEventImpressions] = if not FFlagSduiExperienceDetailsSupport then nil else {
			skipItemImpressionsLog = false,
			lazyHandler = function() -- line: 43
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Impressions.SduiVirtualEventImpressionsHandler)
			end
		},
		[SduiImpressionEventType.experienceStoreImpressions] = if not FFlagSduiEdpStoreImpressionsLogging then nil else {
			skipItemImpressionsLog = false,
			lazyHandler = function() -- line: 51
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Impressions.SduiEdpStoreImpressionsHandler)
			end
		},
		[SduiImpressionEventType.marketplaceItemImpressions] = if not FFlagSduiEdpStoreImpressionsLogging then nil else {
			skipItemImpressionsLog = false,
			lazyHandler = function() -- line: 59
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Impressions.SduiMarketplaceItemImpressionsHandler)
			end
		},
		[SduiImpressionEventType.devStoreSeeAllImpressions] = if not FFlagSduiDevStoreSeeAllImpressionsLogging then nil else {
			skipItemImpressionsLog = false,
			lazyHandler = function() -- line: 67
				-- upvalues: ServerDrivenUi (copy)
				return require(ServerDrivenUi.Impressions.SduiDevStoreSeeAllImpressionsHandler)
			end
		}
	}

	getSduiImpressionHandlerRegistry().registerImpressionHandlerConfigs(t1)
end

return registerDiscoveryImpressions
