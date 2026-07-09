local CorePackages = game:GetService("CorePackages")
local FFlagEnableUnifiedProductPurchaseFlow = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableUnifiedProductPurchaseFlow
local v3 = game:DefineFastFlag("EnableUnifiedPurchasePromptForEDPGamepass", false)

return FFlagEnableUnifiedProductPurchaseFlow and v3
