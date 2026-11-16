local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local Http = require(parent.Http)
local Url = Http.Url
local HttpClient = require(parent.HttpClient)

local asPromise = HttpClient.asPromise
local createRequest = HttpClient.createRequest
local createRequestInternalNetwork = HttpClient.createRequestInternalNetwork
local decodeJson = HttpClient.decodeJson
local encodeRaw = HttpClient.encodeRaw

local getShopPurchasePayload = require(InExperienceShop.Utils.getShopPurchasePayload)

return {
	redeemGamePassTrial = function(p: number)
		return asPromise((createRequest({
			networkImpl = createRequestInternalNetwork(),
			method = "POST",
			url = `{Url.APIS_URL}game-passes/v1/game-passes/{p}/trial:redeem`,
			body = getShopPurchasePayload(),
			headers = {},
			encode = encodeRaw("application/json"),
			decode = decodeJson(function(p2)
				return p2
			end),
			analyticsKey = "game-passes.redeem-trial"
		})))
	end
}
