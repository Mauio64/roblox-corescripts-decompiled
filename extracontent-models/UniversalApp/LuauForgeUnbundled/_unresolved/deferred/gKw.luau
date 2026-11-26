local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")
local module2 = require("@luauforge/bundled/dPU")

local v5 = {
	eventName = "CatalogNonCollectiblePurchase",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 2026, 10, 1 },
	description = "Counts Catalog asset and bundle purchases sent to the legacy economy purchase endpoint instead of the collectible endpoints.",
	links = "https://roblox.atlassian.net/browse/CLI-220689"
}

local v6 = {
	eventName = "CatalogLegacyEndpointPurchaseSuccess",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 2026, 10, 1 },
	description = "Counts successful Catalog asset and bundle purchases made through the legacy economy purchase endpoint.",
	links = "https://roblox.atlassian.net/browse/CLI-220689"
}

local function getNonCollectiblePurchaseLabels(p2, p3, p4, p5)
	local itemRestrictions = p2 and p2.itemRestrictions or {}

	local v7 = itemRestrictions[module2.ItemRestrictions.LimitedUnique] and "limitedUnique"
		or itemRestrictions[module2.ItemRestrictions.Limited] and "limited"
		or "none"

	local nonCollectiblePurchaseLabels = {
		itemType = tostring(p3),
		assetType = not (p2 and p2.assetType) and "" or tostring(p2.assetType),
		limited = v7,
		isResale = 0,
		reason = 0
	}

	local v8 = not (p5 == nil) and p5 ~= ""
	nonCollectiblePurchaseLabels.isResale = tostring(v8)

	nonCollectiblePurchaseLabels.reason = p4 and p4 ~= "" and "collectibleInfoNotLoaded"
		or "noCollectibleItemId"
	return nonCollectiblePurchaseLabels
end

return {
	reportCatalogNonCollectiblePurchase = function(p2, p3, p4, p5)
		local nonCollectiblePurchaseLabels = getNonCollectiblePurchaseLabels(p2, p3, p4, p5)
		LoggingProtocol.default:logRobloxTelemetryCounter(v5, 1, nonCollectiblePurchaseLabels)
		return nonCollectiblePurchaseLabels
	end,
	reportCatalogLegacyEndpointPurchaseSuccess = function(p2)
		LoggingProtocol.default:logRobloxTelemetryCounter(v6, 1, p2)
	end
}
