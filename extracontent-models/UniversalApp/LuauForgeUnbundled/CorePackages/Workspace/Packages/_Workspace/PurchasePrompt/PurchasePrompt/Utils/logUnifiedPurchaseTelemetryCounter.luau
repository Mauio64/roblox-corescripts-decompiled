local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/LoggingProtocol")

local productPurchaseSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptLite").Enums.ProductPurchaseSurface
local AppContext = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/AppContext")
local types = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")

local function logUnifiedPurchaseTelemetryCounter(p2, p3, p4)
	LoggingProtocol.default:logRobloxTelemetryCounter(p2, 1, {
		appContext = AppContext.get(),
		surface = p3 or productPurchaseSurface.Unknown,
		productType = p4 or types.ProductTypeEnum.Unknown
	})
end

return logUnifiedPurchaseTelemetryCounter
