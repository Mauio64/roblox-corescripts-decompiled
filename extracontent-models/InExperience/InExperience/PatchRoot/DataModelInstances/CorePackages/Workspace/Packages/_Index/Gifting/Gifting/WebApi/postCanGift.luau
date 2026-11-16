local Gifting = script:FindFirstAncestor("Gifting")
local parent = Gifting.Parent

local Promise = require(parent.Promise)
local t = require(parent.t)

local CanGiftResponseModel = require(Gifting.Models.CanGiftResponseModel)
local GiftErrorModel = require(Gifting.Models.GiftErrorModel)
local fetchGifting = require(Gifting.WebApi.fetchGifting)
local Urls = require(Gifting.WebApi.Urls)
require(Gifting.Types)

local strictInterface = t.strictInterface({
	items = t.array(t.strictInterface({ itemType = t.string, itemId = t.string }))
})

local function postCanGift(body, network)
	local v, v2 = strictInterface(body)

	if v then
		return fetchGifting({
			network = network,
			method = "POST",
			url = Urls.canGift(),
			body = body,
			analyticsKey = "gifting.can-gift",
			decode = CanGiftResponseModel.format
		})
	end

	return Promise.reject(GiftErrorModel.invalidRequest(v2))
end

return postCanGift
