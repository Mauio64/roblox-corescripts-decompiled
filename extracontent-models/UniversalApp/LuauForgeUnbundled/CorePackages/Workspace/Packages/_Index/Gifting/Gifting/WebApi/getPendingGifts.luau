local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/Promise")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/t")

local GiftErrorModel = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Models/GiftErrorModel")
local PendingGiftsResponseModel = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Models/PendingGiftsResponseModel")
local fetchGifting = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/WebApi/fetchGifting")
local Urls = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/WebApi/Urls")
require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Types")

local optional = t.optional(t.intersection(t.integer, t.numberPositive))

local function getPendingGifts(p2, p3, p4)
	local v5, v6 = optional(p2)

	if v5 then
		return fetchGifting({
			network = p4,
			method = "GET",
			url = Urls.pending(p2, p3),
			analyticsKey = "gifting.pending",
			decode = PendingGiftsResponseModel.format
		})
	end

	return Promise.reject(GiftErrorModel.invalidRequest(`limit: {v6}`))
end

return getPendingGifts
