local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local LoggingProtocol = require(PurchasePromptParent.LoggingProtocol)
local ProductPurchaseSurface = require(PurchasePromptParent.PurchasePromptLite).Enums.ProductPurchaseSurface
local AppContext = require(PurchasePrompt.Utils.AppContext)
local types = require(PurchasePrompt.types)

local function logUnifiedPurchaseTelemetryCounter(p1, p2, p3) -- line: 12
	-- upvalues: LoggingProtocol (copy), AppContext (copy), ProductPurchaseSurface (copy), types (copy)
	LoggingProtocol.default:logRobloxTelemetryCounter(p1, 1, {
		appContext = AppContext.get(),
		surface = p2 or ProductPurchaseSurface.Unknown,
		productType = p3 or types.ProductTypeEnum.Unknown
	})
end

return logUnifiedPurchaseTelemetryCounter
