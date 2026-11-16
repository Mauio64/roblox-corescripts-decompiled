local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local IAPExperience = require(parent.IAPExperience)
local ProductPurchasePromptCounter = IAPExperience.Counters.ProductPurchasePromptCounter.ProductPurchasePromptCounter
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default
local PromptState = require(PurchasePrompt.Enums.PromptState)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local FFlagFixPurchasingErrorCounter = require(PurchasePrompt.Flags.FFlagFixPurchasingErrorCounter)
local FFlagAddSurfaceAndProductTypeToPromptCounter = require(PurchasePrompt.Flags.FFlagAddSurfaceAndProductTypeToPromptCounter)

local function logProductPurchasePromptCounter(p, p2, value: string?, value2: string?)
	if not FFlagFixPurchasingErrorCounter then
		default:logRobloxTelemetryCounter(ProductPurchasePromptCounter, 1, {
			promptState = tostring(p),
			purchaseError = p ~= PromptState.Error and "" or tostring(p2),
			surface = FFlagAddSurfaceAndProductTypeToPromptCounter and (value or "Unknown") or nil,
			productType = FFlagAddSurfaceAndProductTypeToPromptCounter and (value2 or "Unknown") or nil
		})

		return
	end

	local v = { promptState = tostring(p), purchaseError = 0, surface = 0, productType = 0 }
	local purchaseError

	if PurchaseError.isMember(p2) then
		purchaseError = tostring(p2)
	else
		purchaseError = tostring(PurchaseError.UnknownFailure)
	end

	v.purchaseError = purchaseError

	v.surface = FFlagAddSurfaceAndProductTypeToPromptCounter and (value or "Unknown") or nil
	v.productType = FFlagAddSurfaceAndProductTypeToPromptCounter and (value2 or "Unknown") or nil
	default:logRobloxTelemetryCounter(ProductPurchasePromptCounter, 1, v)
end

return logProductPurchasePromptCounter
