local GamePlayButton = script:FindFirstAncestor("GamePlayButton")
local HttpService = game:GetService("HttpService")
local GamePlayButtonParent = GamePlayButton.Parent
local Url = require(GamePlayButtonParent.Http).Url

local function FiatPaidAccessPostPreparePurchaseRequest(p1, p2, p3) -- line: 21
	-- upvalues: Url (copy), HttpService (copy)
	return p1(string.format("%s/fiat-paid-access-service/v1/purchase", Url.APIS_URL), "POST", {
		postBody = HttpService:JSONEncode({
			expected_base_price_id = p3,
			root_place_id = p2
		})
	})
end

return FiatPaidAccessPostPreparePurchaseRequest
