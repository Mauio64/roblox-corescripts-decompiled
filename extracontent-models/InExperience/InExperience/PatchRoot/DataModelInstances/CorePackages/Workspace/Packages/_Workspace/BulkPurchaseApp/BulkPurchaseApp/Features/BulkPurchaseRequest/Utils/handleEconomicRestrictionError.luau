local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local IAPExperience = require(BulkPurchaseAppParent.IAPExperience)
local parseErrorReasonToEconomicRestriction = IAPExperience.Utility.parseErrorReasonToEconomicRestriction
local EconomicRestrictionsCounter = IAPExperience.Counters.EconomicRestrictionsCounter
local UniversalEconomicRestrictionsCounter = EconomicRestrictionsCounter.UniversalEconomicRestrictionsCounter
local EconomicRestrictionsSurface = EconomicRestrictionsCounter.EconomicRestrictionsSurface
local default = require(BulkPurchaseAppParent.LoggingProtocol).default
local BulkPurchaseFailed = require(BulkPurchaseApp.Store.Actions.BulkPurchaseFailed)
local ErrorCodeEnum = require(BulkPurchaseApp.Enums.ErrorCodeEnum)

local function handleEconomicRestrictionError(p1, p2: ((...any) -> ...any)) -- line: 14
	-- upvalues: parseErrorReasonToEconomicRestriction (copy), default (copy), UniversalEconomicRestrictionsCounter (copy), EconomicRestrictionsSurface (copy), BulkPurchaseFailed (copy), ErrorCodeEnum (copy)
	local v14 = parseErrorReasonToEconomicRestriction(p1)

	default:logRobloxTelemetryCounter(UniversalEconomicRestrictionsCounter, 1, {
		surface = EconomicRestrictionsSurface.BulkPurchase,
		failureReason = not v14.violationType and "null" or tostring(v14.violationType)
	})
	p2(BulkPurchaseFailed(ErrorCodeEnum.EconomicRestriction, {
		failureReason = v14.violationType,
		expirationTimeInMinutes = v14.timeoutMinutes
	}))
end

return handleEconomicRestrictionError
