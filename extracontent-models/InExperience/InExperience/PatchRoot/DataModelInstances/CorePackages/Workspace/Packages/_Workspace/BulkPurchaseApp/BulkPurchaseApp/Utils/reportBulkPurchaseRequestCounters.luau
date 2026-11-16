local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local parent = BulkPurchaseApp.Parent
local LoggingProtocol = require(parent.LoggingProtocol)
local BulkPurchaseCountersEnum = require(BulkPurchaseApp.Enums.BulkPurchaseCountersEnum)

local FFlagAXAddPlusUpsellToBulkPurchase = require(BulkPurchaseApp.Flags.FFlagAXAddPlusUpsellToBulkPurchase)
local FFlagAXMoreBulkPurchaseCounters = require(BulkPurchaseApp.Flags.FFlagAXMoreBulkPurchaseCounters)

local v = {
	[BulkPurchaseCountersEnum.BulkPurchaseRequestedCounter] = {
		eventName = BulkPurchaseCountersEnum.BulkPurchaseRequestedCounter,
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 9, 23 },
		throttlingPercentage = 100,
		description = "Counter fired when bulk purchase is requested",
		links = ""
	},
	[BulkPurchaseCountersEnum.BulkPurchaseSucceededCounter] = {
		eventName = BulkPurchaseCountersEnum.BulkPurchaseSucceededCounter,
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 9, 23 },
		throttlingPercentage = 100,
		description = "Counter fired when bulk purchase has succeeded",
		links = ""
	},
	[BulkPurchaseCountersEnum.BulkPurchaseFailedCounter] = {
		eventName = BulkPurchaseCountersEnum.BulkPurchaseFailedCounter,
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 9, 23 },
		throttlingPercentage = 100,
		description = "Counter fired when bulk purchase has failed",
		links = ""
	},
	[BulkPurchaseCountersEnum.BulkPurchaseRefreshFailedCounter] = {
		eventName = BulkPurchaseCountersEnum.BulkPurchaseRefreshFailedCounter,
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 9, 23 },
		throttlingPercentage = 100,
		description = "Counter fired when bulk purchase refresh has failed",
		links = ""
	},
	[BulkPurchaseCountersEnum.BulkPurchasePlusUpsellInitatedCounter] = {
		eventName = BulkPurchaseCountersEnum.BulkPurchasePlusUpsellInitatedCounter,
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 9, 23 },
		throttlingPercentage = 100,
		description = "Counter fired when bulk purchase server plus upsell is initiated",
		links = ""
	},
	[BulkPurchaseCountersEnum.BulkPurchasePlusUpsellSucceededCounter] = {
		eventName = BulkPurchaseCountersEnum.BulkPurchasePlusUpsellSucceededCounter,
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 9, 23 },
		throttlingPercentage = 100,
		description = "Counter fired when bulk purchase server plus upsell is successful",
		links = ""
	},
	[BulkPurchaseCountersEnum.BulkPurchasePlusUpsellFailedCounter] = {
		eventName = BulkPurchaseCountersEnum.BulkPurchasePlusUpsellFailedCounter,
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 9, 23 },
		throttlingPercentage = 100,
		description = "Counter fired when bulk purchase server plus upsell has failed",
		links = ""
	},
	[BulkPurchaseCountersEnum.BulkPurchasePartialSuccessCounter] = {
		eventName = BulkPurchaseCountersEnum.BulkPurchasePartialSuccessCounter,
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 10, 26 },
		throttlingPercentage = 100,
		description = "Counter fired when bulk purchase has partially succeeded",
		links = ""
	}
}

local function reportBulkPurchaseRequestCounters(p, items)
	local v2 = {
		FFlagAXAddPlusUpsellToBulkPurchase = tostring(FFlagAXAddPlusUpsellToBulkPurchase)
	}

	if FFlagAXMoreBulkPurchaseCounters and items then
		for k, item in items do
			v2[k] = item
		end
	end

	LoggingProtocol.default:logRobloxTelemetryCounter(v[p], 1, v2)
end

return reportBulkPurchaseRequestCounters
