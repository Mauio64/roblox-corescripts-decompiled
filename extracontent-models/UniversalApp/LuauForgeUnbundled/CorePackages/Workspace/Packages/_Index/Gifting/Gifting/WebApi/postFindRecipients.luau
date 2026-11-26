local FindRecipientsResponseModel = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Models/FindRecipientsResponseModel")
local fetchGifting = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/WebApi/fetchGifting")
local Urls = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/WebApi/Urls")
require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Types")

local function postFindRecipients(p2, p3)
	return fetchGifting({
		network = p3,
		method = "POST",
		url = Urls.findRecipients(),
		body = p2,
		analyticsKey = "gifting.find-recipients",
		decode = FindRecipientsResponseModel.format
	})
end

return postFindRecipients
