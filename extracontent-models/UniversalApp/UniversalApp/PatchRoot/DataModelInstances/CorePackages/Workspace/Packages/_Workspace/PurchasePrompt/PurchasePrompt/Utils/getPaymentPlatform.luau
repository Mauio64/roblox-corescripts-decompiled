local ParentParent = script.Parent.Parent
local getPaymentFromPlatform = require(ParentParent.Utils.getPaymentFromPlatform)

require(ParentParent.Utils.getPaymentFromPlatformLegacy)

local getHasAmazonUserAgent = require(ParentParent.Utils.getHasAmazonUserAgent)
local getHasQuestUserAgent = require(ParentParent.Utils.getHasQuestUserAgent)
local GetFFlagEnableLuobuInGameUpsell = require(ParentParent.Flags.GetFFlagEnableLuobuInGameUpsell)

return function(p1) -- line: 9
	-- upvalues: getHasAmazonUserAgent (copy), GetFFlagEnableLuobuInGameUpsell (copy), getHasQuestUserAgent (copy), getPaymentFromPlatform (copy)
	local v7 = getHasAmazonUserAgent()
	local v8 = GetFFlagEnableLuobuInGameUpsell()
	local v9 = getHasQuestUserAgent()

	return getPaymentFromPlatform(p1, v8, v7, v9)
end
