local HttpService = game:GetService("HttpService")

local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local FFlagCategoryLoggingInShopPurchase = require(InExperienceShop.Flags.FFlagCategoryLoggingInShopPurchase)

require(InExperienceShop.Types)

local jsonEncode = HttpService:JSONEncode("__SHOP_PURCHASE_LOCATION__")

local v = {
	"categoryGroup",
	"categoryPosition",
	"gridPositionRow",
	"gridPositionColumn",
	"categoryName",
	"stableCategoryId"
}

local function encodeLocation(p)
	local v2 = { `"locationType":{HttpService:JSONEncode("personalizedShop")}` }

	if p ~= nil then
		for _, v3 in v do
			local v4 = p[v3]

			if v4 ~= nil then
				table.insert(v2, `{HttpService:JSONEncode(v3)}:{HttpService:JSONEncode(v4)}`)
			end
		end
	end

	return "{" .. table.concat(v2, ",") .. "}"
end

local function encodePayload(p)
	local jsonEncode2 = HttpService:JSONEncode({
		surface = {
			scopeType = "inExperience",
			universeId = game.GameId,
			placeId = game.PlaceId,
			location = "__SHOP_PURCHASE_LOCATION__"
		}
	})

	local v2, v3 = string.find(jsonEncode2, jsonEncode, 1, true)
	local v4 = v2 ~= nil and v3 ~= nil
	assert(v4, "location placeholder missing from shop purchase payload")
	return string.sub(jsonEncode2, 1, v2 - 1) .. encodeLocation(p) .. string.sub(jsonEncode2, v3 + 1)
end

local jsonEncode2 = HttpService:JSONEncode({
	surface = {
		scopeType = "inExperience",
		universeId = game.GameId,
		placeId = game.PlaceId,
		location = { locationType = "personalizedShop" }
	}
})

local function getShopPurchasePayload(p)
	if FFlagCategoryLoggingInShopPurchase then
		return encodePayload(p)
	end

	return jsonEncode2
end

return getShopPurchasePayload
