local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local parent = BulkPurchaseApp.Parent

local IAPExperience = require(parent.IAPExperience)
local parseErrorReasonToEconomicRestriction = IAPExperience.Utility.parseErrorReasonToEconomicRestriction
local EconomicRestrictionsCounter = IAPExperience.Counters.EconomicRestrictionsCounter
local UniversalEconomicRestrictionsCounter = EconomicRestrictionsCounter.UniversalEconomicRestrictionsCounter
local EconomicRestrictionsSurface = EconomicRestrictionsCounter.EconomicRestrictionsSurface
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default

local BulkPurchaseFailed = require(BulkPurchaseApp.Store.Actions.BulkPurchaseFailed)
local ErrorCodeEnum = require(BulkPurchaseApp.Enums.ErrorCodeEnum)

local function handleEconomicRestrictionError(p, callback)
	local v = parseErrorReasonToEconomicRestriction(p)
	default:logRobloxTelemetryCounter(UniversalEconomicRestrictionsCounter, 1, {
		surface = EconomicRestrictionsSurface.BulkPurchase,
		failureReason = not v.violationType and "null" or tostring(v.violationType)
	})

	callback(BulkPurchaseFailed(ErrorCodeEnum.EconomicRestriction, {
		failureReason = v.violationType,
		expirationTimeInMinutes = v.timeoutMinutes
	}))
end

return handleEconomicRestrictionError
