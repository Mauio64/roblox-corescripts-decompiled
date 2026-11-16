local Gifting = script:FindFirstAncestor("Gifting")

local FindRecipientsResponseModel = require(Gifting.Models.FindRecipientsResponseModel)
local fetchGifting = require(Gifting.WebApi.fetchGifting)
local Urls = require(Gifting.WebApi.Urls)
require(Gifting.Types)

local function postFindRecipients(body, network)
	return fetchGifting({
		network = network,
		method = "POST",
		url = Urls.findRecipients(),
		body = body,
		analyticsKey = "gifting.find-recipients",
		decode = FindRecipientsResponseModel.format
	})
end

return postFindRecipients
