local GamePlayButton = script:FindFirstAncestor("GamePlayButton")
local HttpService = game:GetService("HttpService")
local GamePlayButtonParent = GamePlayButton.Parent
local ApiFetchGameDetails = require(GamePlayButtonParent.GameDetailRodux).GameDetails.ApiFetchGameDetails
local FetchGamePlayabilityAndProductInfo = require(GamePlayButtonParent.GameDetailRodux).FetchGamePlayabilityAndProductInfo
local PerformFetch = require(GamePlayButtonParent.Http).PerformFetch
local Promise = require(GamePlayButtonParent.Promise)
local FiatPaidAccessPostPreparePurchaseRequest = require(GamePlayButton.FiatPaidAccessPostPreparePurchaseRequest)
local OpenFiatPurchasePage = require(GamePlayButton.OpenFiatPurchasePage)

return {
	GetFetchingStatus = function(p1, p2) -- line: 20
		-- upvalues: PerformFetch (copy)
		return PerformFetch.GetStatus(p1, "luaapp.fiatpaidaccess.prepare-purchase." .. p2)
	end,
	Fetch = function(p3, p4, p5, p6) -- line: 24
		-- upvalues: PerformFetch (copy), FiatPaidAccessPostPreparePurchaseRequest (copy), HttpService (copy), OpenFiatPurchasePage (copy), ApiFetchGameDetails (copy), FetchGamePlayabilityAndProductInfo (copy), Promise (copy)
		return PerformFetch.Single("luaapp.fiatpaidaccess.prepare-purchase." .. p5, function(p7) -- line: 25
			-- upvalues: FiatPaidAccessPostPreparePurchaseRequest (copy), p3 (copy), p4 (copy), p6 (copy), HttpService (copy), OpenFiatPurchasePage (copy), ApiFetchGameDetails (copy), p5 (copy), FetchGamePlayabilityAndProductInfo (copy), Promise (copy)
			return FiatPaidAccessPostPreparePurchaseRequest(p3, p4, p6):andThen(function(p8) -- line: 27
				-- upvalues: HttpService (copy), p7 (copy), OpenFiatPurchasePage (copy), ApiFetchGameDetails (copy), p3 (copy), p5 (copy), FetchGamePlayabilityAndProductInfo (copy), Promise (copy)
				local v19 = p8 and (p8.responseBody and p8.responseBody.checkoutUrl)

				if v19 then
					local data = HttpService:JSONDecode(v19)

					if data and data.checkoutUrl then
						p7:dispatch(OpenFiatPurchasePage(data.checkoutUrl, function() -- line: 34
							-- upvalues: p7 (copy), ApiFetchGameDetails (copy), p3 (copy), p5 (copy), FetchGamePlayabilityAndProductInfo (copy)
							p7:dispatch(ApiFetchGameDetails.Fetch(p3, { p5 }))
							p7:dispatch(FetchGamePlayabilityAndProductInfo.Fetch(p3, p5))
						end))

						return Promise.resolve(p8)
					end
				end

				return Promise.reject("Invalid Response")
			end)
		end)
	end
}
