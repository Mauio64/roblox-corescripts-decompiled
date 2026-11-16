local Gifting = script:FindFirstAncestor("Gifting")
local parent = Gifting.Parent

local Promise = require(parent.Promise)
local t = require(parent.t)

local GiftErrorModel = require(Gifting.Models.GiftErrorModel)
local PendingGiftsResponseModel = require(Gifting.Models.PendingGiftsResponseModel)
local fetchGifting = require(Gifting.WebApi.fetchGifting)
local Urls = require(Gifting.WebApi.Urls)
require(Gifting.Types)

local optional = t.optional(t.intersection(t.integer, t.numberPositive))

local function getPendingGifts(p: number?, p2: string?, network)
	local v, v2 = optional(p)

	if v then
		return fetchGifting({
			network = network,
			method = "GET",
			url = Urls.pending(p, p2),
			analyticsKey = "gifting.pending",
			decode = PendingGiftsResponseModel.format
		})
	end

	return Promise.reject(GiftErrorModel.invalidRequest(`limit: {v2}`))
end

return getPendingGifts
