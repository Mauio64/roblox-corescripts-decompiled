local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/LoggingProtocol")

local v5 = {
	eventName = "PurchasePromptNonCollectiblePurchase",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 2026, 10, 1 },
	description = "Counts confirmed asset and bundle purchases sent to MarketplaceService:PerformPurchase without a collectible item id, so the engine buys them through the legacy economy endpoint.",
	links = "https://roblox.atlassian.net/browse/CLI-220689"
}

local set = {}

for k, v6 in Enum.AvatarAssetType:GetEnumItems() do
	set[v6.Value] = true
end

local function reportPurchasePromptNonCollectiblePurchase(p2, p3)
	if p2 == Enum.InfoType.Asset then
		if not set[p3.assetTypeId] then
			return
		end

		LoggingProtocol.default:logRobloxTelemetryCounter(v5, 1, {
			infoType = "Asset",
			assetTypeId = tostring(p3.assetTypeId),
			productType = p3.productType or ""
		})
	elseif p2 == Enum.InfoType.Bundle then
		LoggingProtocol.default:logRobloxTelemetryCounter(v5, 1, { infoType = "Bundle" })
	end
end

return reportPurchasePromptNonCollectiblePurchase
