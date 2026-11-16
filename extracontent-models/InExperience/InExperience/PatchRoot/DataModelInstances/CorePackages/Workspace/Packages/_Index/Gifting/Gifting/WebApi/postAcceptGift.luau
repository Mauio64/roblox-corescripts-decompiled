local Gifting = script:FindFirstAncestor("Gifting")

local fetchGifting = require(Gifting.WebApi.fetchGifting)
local Urls = require(Gifting.WebApi.Urls)
require(Gifting.Types)

local function postAcceptGift(body, network)
	return fetchGifting({
		network = network,
		method = "POST",
		url = Urls.accept(),
		body = body,
		analyticsKey = "gifting.accept",
		decode = function()
			return {}
		end
	})
end

return postAcceptGift
