local PrepareGiftResponseModel = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Models/PrepareGiftResponseModel")
local fetchGifting = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/WebApi/fetchGifting")
local Urls = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/WebApi/Urls")
require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Types")

local function postPrepareGift(p2, p3)
	return fetchGifting({
		network = p3,
		method = "POST",
		url = Urls.prepare(),
		body = p2,
		analyticsKey = "gifting.prepare",
		decode = PrepareGiftResponseModel.format
	})
end

return postPrepareGift
