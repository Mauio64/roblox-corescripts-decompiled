local parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default
local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)

local BulkPurchaseMissingPurchaseOptionsCounter = AvatarExperienceAnalytics.Events.BulkPurchaseMissingPurchaseOptionsCounter

local function reportMissingPurchaseOptions(items)
	for _, item in items do
		local purchaseOptions = item.purchaseOptions

		if purchaseOptions == nil or #purchaseOptions == 0 then
			default:logRobloxTelemetryCounter(BulkPurchaseMissingPurchaseOptionsCounter, 1, {})
			break
		end
	end
end

local function reportBulkPurchaseRequestIssues(p)
	if p == nil then
		return
	end

	reportMissingPurchaseOptions(p)
end

return reportBulkPurchaseRequestIssues
