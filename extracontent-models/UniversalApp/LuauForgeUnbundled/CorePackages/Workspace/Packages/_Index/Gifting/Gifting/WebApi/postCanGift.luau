local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/Promise")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/t")

local CanGiftResponseModel = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Models/CanGiftResponseModel")
local GiftErrorModel = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Models/GiftErrorModel")
local fetchGifting = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/WebApi/fetchGifting")
local Urls = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/WebApi/Urls")
require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Types")

local strictInterface = t.strictInterface({
	items = t.array(t.strictInterface({
		itemType = t.string,
		itemId = t.string
	}))
})

local function postCanGift(p2, p3)
	local v5, v6 = strictInterface(p2)

	if v5 then
		return fetchGifting({
			network = p3,
			method = "POST",
			url = Urls.canGift(),
			body = p2,
			analyticsKey = "gifting.can-gift",
			decode = CanGiftResponseModel.format
		})
	end

	return Promise.reject(GiftErrorModel.invalidRequest(v6))
end

return postCanGift
