local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local LoggingProtocol = require(parent.LoggingProtocol)

local PurchasePromptLite = require(parent.PurchasePromptLite)

local ProductPurchaseSurface = PurchasePromptLite.Enums.ProductPurchaseSurface
local AppContext = require(PurchasePrompt.Utils.AppContext)
local types = require(PurchasePrompt.types)

local function logUnifiedPurchaseTelemetryCounter(p, p2, p3)
	LoggingProtocol.default:logRobloxTelemetryCounter(p, 1, {
		appContext = AppContext.get(),
		surface = p2 or ProductPurchaseSurface.Unknown,
		productType = p3 or types.ProductTypeEnum.Unknown
	})
end

return logUnifiedPurchaseTelemetryCounter
