require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience")
local PurchasePromptLite = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptLite")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/LuauPolyfill")

return { ProductTypeEnum = PurchasePromptLite.Enums.ProductKind }
