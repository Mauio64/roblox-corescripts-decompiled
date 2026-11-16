local parent = script:FindFirstAncestor("PurchasePrompt").Parent
local LoggingProtocol = require(parent.LoggingProtocol)

local v = {
	eventName = "PurchasePromptNonCollectiblePurchase",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 2026, 10, 1 },
	description = "Counts confirmed asset and bundle purchases sent to MarketplaceService:PerformPurchase without a collectible item id, so the engine buys them through the legacy economy endpoint.",
	links = "https://roblox.atlassian.net/browse/CLI-220689"
}

local set = {}

for _, v2 in Enum.AvatarAssetType:GetEnumItems() do
	set[v2.Value] = true
end

local function reportPurchasePromptNonCollectiblePurchase(p, p2)
	if p == Enum.InfoType.Asset then
		if not set[p2.assetTypeId] then
			return
		end

		LoggingProtocol.default:logRobloxTelemetryCounter(v, 1, {
			infoType = "Asset",
			assetTypeId = tostring(p2.assetTypeId),
			productType = p2.productType or ""
		})
	elseif p == Enum.InfoType.Bundle then
		LoggingProtocol.default:logRobloxTelemetryCounter(v, 1, { infoType = "Bundle" })
	end
end

return reportPurchasePromptNonCollectiblePurchase
