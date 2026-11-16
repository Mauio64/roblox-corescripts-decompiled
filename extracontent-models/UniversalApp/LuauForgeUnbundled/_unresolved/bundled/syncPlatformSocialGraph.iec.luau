local MessageBusService = game:GetService("MessageBusService")
local HttpService = game:GetService("HttpService")

local urlBuilder = require("@luauforge/bundled/ied").UrlBuilder
local urlBase = require("@luauforge/bundled/ied").UrlBase
local module = require("@luauforge/bundled/iee")
local fetchFriendsCarousel = require("@luauforge/bundled/ief").FetchFriendsCarousel

local fFlagSocialCarouselMigrateRecommendations = require("@luauforge/bundled/ieg").FFlagSocialCarouselMigrateRecommendations

local module2 = require("@luauforge/bundled/ieh")
local friendsRecommendationsStore = module2.FriendsRecommendationsStore
local dataSource = module2.Enums.DataSource

local defineFastInt = game:DefineFastInt("SocialGraphSyncRequestRetryCount", 1)

local v5 = urlBuilder.new({
	base = urlBase.APIS,
	path = "platform-social-graph-sync-gateway/v1/start-sync"
})

local function getHeaders()
	return module.new(function(callback, p2)
		MessageBusService:MakeRequest(
			"CredentialsProtocol",
			"getHeaders",
			{ ["url"] = v5(), method = "POST" },
			function(p3)
				callback(p3)
			end,
			{}
		)
	end)
end

local function syncPlatformSocialGraph(callback, callback2, p2)
	return module.new(function(callback3, p3)
		MessageBusService:MakeRequest(
			"CredentialsProtocol",
			"getHeaders",
			{ ["url"] = v5(), method = "POST" },
			function(p4)
				callback3(p4)
			end,
			{}
		)
	end):andThen(function(p3)
		if p3 == nil or not p3.success then
			warn("credential headers error")
			return
		end

		local v6 = {
			headers = p3.headers or {},
			postBody = HttpService:JSONEncode({}),
			maxRetryCount = defineFastInt
		}

		return callback2(v5(), "POST", v6):andThen(function(p4)
			if fFlagSocialCarouselMigrateRecommendations then
				friendsRecommendationsStore.get().refreshFriendsRecommendations(dataSource.HomepageFriendsCarousel)
			else
				callback(fetchFriendsCarousel()):andThen(function(p5)
					return module.resolve()
				end, function(p5)
					warn("Refresh friends carousel failed after syncing platform friends")

					return module.resolve()
				end)
			end
		end, function(p4)
			warn("platform social graph sync request failed")
			p2.Diag:reportCounter("TriggerPlatformSocialGraphSyncFailed", 1)
			return module.resolve()
		end)
	end)
end

return syncPlatformSocialGraph
