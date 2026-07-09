local Parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local default = require(Parent.LoggingProtocol).default
local BulkPurchaseMissingPurchaseOptionsCounter = require(Parent.AvatarExperienceAnalytics).Events.BulkPurchaseMissingPurchaseOptionsCounter

local function reportMissingPurchaseOptions(t1: {[any]: any}) -- line: 8
	-- upvalues: default (copy), BulkPurchaseMissingPurchaseOptionsCounter (copy)
	for _, v8 in t1 do
		local purchaseOptions = v8.purchaseOptions

		if purchaseOptions == nil or #purchaseOptions == 0 then
			default:logRobloxTelemetryCounter(BulkPurchaseMissingPurchaseOptionsCounter, 1, {})

			return
		end
	end
end
local function reportBulkPurchaseRequestIssues(t2: {[any]: any}) -- line: 20
	-- upvalues: reportMissingPurchaseOptions (copy)
	if t2 == nil then
		return
	end

	reportMissingPurchaseOptions(t2)
end

return reportBulkPurchaseRequestIssues
