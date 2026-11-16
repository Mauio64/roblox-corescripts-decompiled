local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/Promise")

local GiftErrorModel = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Models/GiftErrorModel")
local GiftModelUtils = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Models/GiftModelUtils")
local ReceiverPreviewResponseModel = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Models/ReceiverPreviewResponseModel")
local fetchGifting = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/WebApi/fetchGifting")
local Urls = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/WebApi/Urls")
require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Types")

local function getReceiverPreview(p2, p3)
	local nonEmptyString, v5 = GiftModelUtils.nonEmptyString(p2)

	if nonEmptyString then
		return fetchGifting({
			network = p3,
			method = "GET",
			url = Urls.receiverPreview(p2),
			analyticsKey = "gifting.receiver-preview",
			decode = ReceiverPreviewResponseModel.format
		})
	end

	return Promise.reject(GiftErrorModel.invalidRequest(`giftId: {v5}`))
end

return getReceiverPreview
