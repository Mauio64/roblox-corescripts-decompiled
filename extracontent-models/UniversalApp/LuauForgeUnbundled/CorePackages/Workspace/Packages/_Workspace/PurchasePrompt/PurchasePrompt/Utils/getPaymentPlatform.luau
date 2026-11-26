local getPaymentFromPlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getPaymentFromPlatform")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getPaymentFromPlatformLegacy")
local getHasAmazonUserAgent = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getHasAmazonUserAgent")
local getHasQuestUserAgent = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getHasQuestUserAgent")
local GetFFlagEnableLuobuInGameUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/GetFFlagEnableLuobuInGameUpsell")

return function(p2)
	local v5 = getHasAmazonUserAgent()
	return getPaymentFromPlatform(p2, GetFFlagEnableLuobuInGameUpsell(), v5, (getHasQuestUserAgent()))
end
