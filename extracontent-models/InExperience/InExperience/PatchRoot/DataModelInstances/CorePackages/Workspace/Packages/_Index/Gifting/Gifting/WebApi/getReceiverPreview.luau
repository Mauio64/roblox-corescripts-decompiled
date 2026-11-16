local Gifting = script:FindFirstAncestor("Gifting")
local parent = Gifting.Parent

local Promise = require(parent.Promise)

local GiftErrorModel = require(Gifting.Models.GiftErrorModel)
local GiftModelUtils = require(Gifting.Models.GiftModelUtils)
local ReceiverPreviewResponseModel = require(Gifting.Models.ReceiverPreviewResponseModel)
local fetchGifting = require(Gifting.WebApi.fetchGifting)
local Urls = require(Gifting.WebApi.Urls)
require(Gifting.Types)

local function getReceiverPreview(p: string, network)
	local nonEmptyString, v = GiftModelUtils.nonEmptyString(p)

	if nonEmptyString then
		return fetchGifting({
			network = network,
			method = "GET",
			url = Urls.receiverPreview(p),
			analyticsKey = "gifting.receiver-preview",
			decode = ReceiverPreviewResponseModel.format
		})
	end

	return Promise.reject(GiftErrorModel.invalidRequest(`giftId: {v}`))
end

return getReceiverPreview
