local GamePlayButton = script:FindFirstAncestor("GamePlayButton")
local HttpService = game:GetService("HttpService")

local parent = GamePlayButton.Parent
local Http = require(parent.Http)
local Url = Http.Url

local function FiatPaidAccessPostPreparePurchaseRequest(callback, root_place_id, expected_base_price_id)
	return callback(string.format("%s/fiat-paid-access-service/v1/purchase", Url.APIS_URL), "POST", {
		postBody = HttpService:JSONEncode({
			["expected_base_price_id"] = expected_base_price_id,
			root_place_id = root_place_id
		})
	})
end

return FiatPaidAccessPostPreparePurchaseRequest
