local HttpService = game:GetService("HttpService")

local url = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Http").Url

local function FiatPaidAccessPostPreparePurchaseRequest(callback, p2, p3)
	return callback(string.format("%s/fiat-paid-access-service/v1/purchase", url.APIS_URL), "POST", {
		postBody = HttpService:JSONEncode({
			["expected_base_price_id"] = p3,
			root_place_id = p2
		})
	})
end

return FiatPaidAccessPostPreparePurchaseRequest
