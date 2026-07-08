local json = game:GetService("HttpService"):JSONEncode({
	surface = {
		scopeType = "inExperience",
		universeId = game.GameId,
		placeId = game.PlaceId,
		location = {
			locationType = "personalizedShop"
		}
	}
})

local function getShopPurchasePayload() -- line: 21
	-- upvalues: json (copy)
	return json
end

return getShopPurchasePayload
