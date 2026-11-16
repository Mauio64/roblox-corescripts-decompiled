local GamePlayButton = script:FindFirstAncestor("GamePlayButton")
local HttpService = game:GetService("HttpService")
local parent = GamePlayButton.Parent

local GameDetailRodux = require(parent.GameDetailRodux)
local ApiFetchGameDetails = GameDetailRodux.GameDetails.ApiFetchGameDetails
local GameDetailRodux2 = require(parent.GameDetailRodux)
local FetchGamePlayabilityAndProductInfo = GameDetailRodux2.FetchGamePlayabilityAndProductInfo
local Http = require(parent.Http)
local PerformFetch = Http.PerformFetch
local Promise = require(parent.Promise)

local FiatPaidAccessPostPreparePurchaseRequest = require(GamePlayButton.FiatPaidAccessPostPreparePurchaseRequest)
local OpenFiatPurchasePage = require(GamePlayButton.OpenFiatPurchasePage)

local function fn(p) -- 2 equivalent calls inferred from this helper
	return "luaapp.fiatpaidaccess.prepare-purchase." .. p
end

local ApiPostPreparePurchase = {}

function ApiPostPreparePurchase.GetFetchingStatus(p, p2)
	return PerformFetch.GetStatus(p, fn(p2)) -- inferred equivalent call
end

function ApiPostPreparePurchase.Fetch(p, p2, p3, p4)
	return PerformFetch.Single(fn(p3), function(object) -- inferred equivalent call
		return FiatPaidAccessPostPreparePurchaseRequest(p, p2, p4):andThen(function(p5)
			local checkoutUrl = p5 and p5.responseBody and p5.responseBody.checkoutUrl

			if checkoutUrl then
				local jsonDecode = HttpService:JSONDecode(checkoutUrl)

				if jsonDecode and jsonDecode.checkoutUrl then
					object:dispatch(OpenFiatPurchasePage(jsonDecode.checkoutUrl, function()
						object:dispatch(ApiFetchGameDetails.Fetch(p, { p3 }))
						object:dispatch(FetchGamePlayabilityAndProductInfo.Fetch(p, p3))
					end))

					return Promise.resolve(p5)
				end
			end

			return Promise.reject("Invalid Response")
		end)
	end)
end

return ApiPostPreparePurchase
