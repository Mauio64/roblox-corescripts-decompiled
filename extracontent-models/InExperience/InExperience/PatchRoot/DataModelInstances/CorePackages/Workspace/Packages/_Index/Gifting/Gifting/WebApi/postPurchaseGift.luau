local Gifting = script:FindFirstAncestor("Gifting")

local fetchGifting = require(Gifting.WebApi.fetchGifting)
local Urls = require(Gifting.WebApi.Urls)
require(Gifting.Types)

local function postPurchaseGift(body, network)
	return fetchGifting({
		network = network,
		method = "POST",
		url = Urls.purchase(),
		body = body,
		analyticsKey = "gifting.purchase",
		decode = function()
			return {}
		end
	})
end

return postPurchaseGift
