local Gifting = script:FindFirstAncestor("Gifting")

local PrepareGiftResponseModel = require(Gifting.Models.PrepareGiftResponseModel)
local fetchGifting = require(Gifting.WebApi.fetchGifting)
local Urls = require(Gifting.WebApi.Urls)
require(Gifting.Types)

local function postPrepareGift(body, network)
	return fetchGifting({
		network = network,
		method = "POST",
		url = Urls.prepare(),
		body = body,
		analyticsKey = "gifting.prepare",
		decode = PrepareGiftResponseModel.format
	})
end

return postPrepareGift
