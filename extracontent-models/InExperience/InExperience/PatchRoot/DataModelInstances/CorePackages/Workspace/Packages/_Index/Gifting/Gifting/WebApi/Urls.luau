local parent = script:FindFirstAncestor("Gifting").Parent

local UrlBuilder = require(parent.UrlBuilder)

local urlBuilder = UrlBuilder.UrlBuilder
local economy = UrlBuilder.UrlBase.new("economy")
local Urls = {}

function Urls.canGift()
	return urlBuilder.new({ base = economy, path = "gifting/v1/gifts/can-gift" })()
end

function Urls.findRecipients()
	return urlBuilder.new({ base = economy, path = "gifting/v1/gifts/find-recipients" })()
end

function Urls.prepare()
	return urlBuilder.new({ base = economy, path = "gifting/v1/gifts/prepare" })()
end

function Urls.purchase()
	return urlBuilder.new({ base = economy, path = "gifting/v1/gifts/purchase" })()
end

function Urls.accept()
	return urlBuilder.new({ base = economy, path = "gifting/v1/gifts/accept" })()
end

function Urls.reject()
	return urlBuilder.new({ base = economy, path = "gifting/v1/gifts/reject" })()
end

function Urls.pending(p: number?, cursor: string?)
	local v = urlBuilder.new({
		base = economy,
		path = "gifting/v1/gifts/pending",
		query = {
			{ name = "limit", value = "{limit}", optional = true },
			{ name = "cursor", value = "{cursor}", optional = true }
		}
	})
	local limit

	if p ~= nil then
		limit = tostring(p)
	end

	return v({ limit = limit, cursor = cursor })
end

function Urls.receiverPreview(giftId: string)
	return urlBuilder.new({ base = economy, path = "gifting/v1/gifts/{giftId}/receiver-preview" })({
		giftId = giftId
	})
end

return Urls
