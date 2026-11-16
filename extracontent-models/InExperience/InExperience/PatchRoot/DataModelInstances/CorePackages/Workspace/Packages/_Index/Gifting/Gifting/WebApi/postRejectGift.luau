local Gifting = script:FindFirstAncestor("Gifting")

local fetchGifting = require(Gifting.WebApi.fetchGifting)
local Urls = require(Gifting.WebApi.Urls)
require(Gifting.Types)

local function postRejectGift(body, network)
	return fetchGifting({
		network = network,
		method = "POST",
		url = Urls.reject(),
		body = body,
		analyticsKey = "gifting.reject",
		decode = function()
			return {}
		end
	})
end

return postRejectGift
