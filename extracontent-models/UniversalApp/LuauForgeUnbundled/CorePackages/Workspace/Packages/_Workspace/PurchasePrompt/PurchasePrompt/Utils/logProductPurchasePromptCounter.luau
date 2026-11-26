local productPurchasePromptCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience").Counters.ProductPurchasePromptCounter.ProductPurchasePromptCounter
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/LoggingProtocol").default
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PromptState")
local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local FFlagFixPurchasingErrorCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagFixPurchasingErrorCounter")
local FFlagAddSurfaceAndProductTypeToPromptCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagAddSurfaceAndProductTypeToPromptCounter")

local function logProductPurchasePromptCounter(p2, p3, value, value2)
	if not FFlagFixPurchasingErrorCounter then
		default:logRobloxTelemetryCounter(productPurchasePromptCounter, 1, {
			promptState = tostring(p2),
			purchaseError = p2 ~= PromptState.Error and "" or tostring(p3),
			surface = FFlagAddSurfaceAndProductTypeToPromptCounter and (value or "Unknown") or nil,
			productType = FFlagAddSurfaceAndProductTypeToPromptCounter and (value2 or "Unknown") or nil
		})

		return
	end

	local v8 = {
		promptState = tostring(p2),
		purchaseError = 0,
		surface = 0,
		productType = 0
	}
	local v9 = if PurchaseError.isMember(p3) then tostring(p3) else tostring(PurchaseError.UnknownFailure)
	v8.purchaseError = v9

	v8.surface = FFlagAddSurfaceAndProductTypeToPromptCounter and (value or "Unknown") or nil
	v8.productType = FFlagAddSurfaceAndProductTypeToPromptCounter and (value2 or "Unknown") or nil
	default:logRobloxTelemetryCounter(productPurchasePromptCounter, 1, v8)
end

return logProductPurchasePromptCounter
