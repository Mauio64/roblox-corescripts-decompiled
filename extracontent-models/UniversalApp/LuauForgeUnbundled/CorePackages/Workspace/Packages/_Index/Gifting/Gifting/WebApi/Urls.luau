local UrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/UrlBuilder")

local urlBuilder = UrlBuilder.UrlBuilder
local economy = UrlBuilder.UrlBase.new("economy")

return {
	canGift = function()
		return urlBuilder.new({ base = economy, path = "gifting/v1/gifts/can-gift" })()
	end,
	findRecipients = function()
		return urlBuilder.new({
			base = economy,
			path = "gifting/v1/gifts/find-recipients"
		})()
	end,
	prepare = function()
		return urlBuilder.new({ base = economy, path = "gifting/v1/gifts/prepare" })()
	end,
	purchase = function()
		return urlBuilder.new({ base = economy, path = "gifting/v1/gifts/purchase" })()
	end,
	accept = function()
		return urlBuilder.new({ base = economy, path = "gifting/v1/gifts/accept" })()
	end,
	reject = function()
		return urlBuilder.new({ base = economy, path = "gifting/v1/gifts/reject" })()
	end,
	pending = function(p2, cursor)
		local v5 = urlBuilder.new({
			base = economy,
			path = "gifting/v1/gifts/pending",
			query = {
				{ name = "limit", value = "{limit}", optional = true },
				{ name = "cursor", value = "{cursor}", optional = true }
			}
		})

		local v7 = if p2 ~= nil then tostring(p2) else nil
		return v5({ limit = v7, cursor = cursor })
	end,
	receiverPreview = function(p2)
		return urlBuilder.new({
			base = economy,
			path = "gifting/v1/gifts/{giftId}/receiver-preview"
		})({ giftId = p2 })
	end
}
