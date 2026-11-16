local parent = script.Parent.Parent

local getPaymentFromPlatform = require(parent.Utils.getPaymentFromPlatform)
require(parent.Utils.getPaymentFromPlatformLegacy)
local getHasAmazonUserAgent = require(parent.Utils.getHasAmazonUserAgent)
local getHasQuestUserAgent = require(parent.Utils.getHasQuestUserAgent)
local GetFFlagEnableLuobuInGameUpsell = require(parent.Flags.GetFFlagEnableLuobuInGameUpsell)

return function(p)
	local hasAmazonUserAgent = getHasAmazonUserAgent()
	return getPaymentFromPlatform(p, GetFFlagEnableLuobuInGameUpsell(), hasAmazonUserAgent, (getHasQuestUserAgent()))
end
