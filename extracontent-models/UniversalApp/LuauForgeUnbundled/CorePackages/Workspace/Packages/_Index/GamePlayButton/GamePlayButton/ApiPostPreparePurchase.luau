local HttpService = game:GetService("HttpService")

local apiFetchGameDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/GameDetailRodux").GameDetails.ApiFetchGameDetails
local fetchGamePlayabilityAndProductInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/GameDetailRodux").FetchGamePlayabilityAndProductInfo
local performFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Http").PerformFetch
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Promise")

local FiatPaidAccessPostPreparePurchaseRequest = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/FiatPaidAccessPostPreparePurchaseRequest")
local OpenFiatPurchasePage = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/OpenFiatPurchasePage")

return {
	GetFetchingStatus = function(p2, p3)
		return performFetch.GetStatus(p2, "luaapp.fiatpaidaccess.prepare-purchase." .. p3)
	end,
	Fetch = function(p2, p3, p4, p5)
		return performFetch.Single("luaapp.fiatpaidaccess.prepare-purchase." .. p4, function(object)
			return FiatPaidAccessPostPreparePurchaseRequest(p2, p3, p5):andThen(function(p6)
				local checkoutUrl = p6 and p6.responseBody and p6.responseBody.checkoutUrl

				if checkoutUrl then
					local jsonDecode = HttpService:JSONDecode(checkoutUrl)

					if jsonDecode and jsonDecode.checkoutUrl then
						object:dispatch(OpenFiatPurchasePage(jsonDecode.checkoutUrl, function()
							object:dispatch(apiFetchGameDetails.Fetch(p2, { p4 }))
							object:dispatch(fetchGamePlayabilityAndProductInfo.Fetch(p2, p4))
						end))

						return Promise.resolve(p6)
					end
				end

				return Promise.reject("Invalid Response")
			end)
		end)
	end
}
