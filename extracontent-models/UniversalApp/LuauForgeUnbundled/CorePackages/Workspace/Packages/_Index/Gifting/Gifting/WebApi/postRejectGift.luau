local fetchGifting = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/WebApi/fetchGifting")
local Urls = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/WebApi/Urls")
require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Types")

local function postRejectGift(p2, p3)
	return fetchGifting({
		network = p3,
		method = "POST",
		url = Urls.reject(),
		body = p2,
		analyticsKey = "gifting.reject",
		decode = function()
			return {}
		end
	})
end

return postRejectGift
