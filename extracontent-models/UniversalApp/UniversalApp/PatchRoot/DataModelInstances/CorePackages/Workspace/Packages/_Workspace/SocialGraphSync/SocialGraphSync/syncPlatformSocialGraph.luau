local MessageBusService = game:GetService("MessageBusService")
local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("SocialGraphSync").Parent
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local UrlBase = require(Parent.UrlBuilder).UrlBase
local Promise = require(Parent.Promise)
local FetchFriendsCarousel = require(Parent.FriendsCarousel).FetchFriendsCarousel
local v8 = game:DefineFastInt("SocialGraphSyncRequestRetryCount", 1)
local v9 = UrlBuilder.new({
	path = "platform-social-graph-sync-gateway/v1/start-sync",
	base = UrlBase.APIS
})

local function getHeaders() -- line: 20
	-- upvalues: Promise (copy), v9 (copy), MessageBusService (copy)
	return Promise.new(function(resolve, _) -- line: 21
		-- upvalues: v9 (copy), MessageBusService (copy)
		local t1 = {
			url = v9(),
			method = "POST"
		}

		MessageBusService:MakeRequest("CredentialsProtocol", "getHeaders", t1, function(p2) -- line: 27
			-- upvalues: resolve (copy)
			resolve(p2)
		end, {})
	end)
end
local function syncPlatformSocialGraph(p3, p4, p5) -- line: 38
	-- upvalues: Promise (copy), v9 (copy), MessageBusService (copy), HttpService (copy), v8 (copy), FetchFriendsCarousel (copy)
	return Promise.new(function(resolve, _) -- line: 21
		-- upvalues: v9 (copy), MessageBusService (copy)
		local t2 = {
			url = v9(),
			method = "POST"
		}

		MessageBusService:MakeRequest("CredentialsProtocol", "getHeaders", t2, function(p7) -- line: 27
			-- upvalues: resolve (copy)
			resolve(p7)
		end, {})
	end):andThen(function(p8) -- line: 39
		-- upvalues: HttpService (copy), v8 (copy), v9 (copy), p4 (copy), p3 (copy), FetchFriendsCarousel (copy), Promise (copy), p5 (copy)
		if p8 == nil or not p8.success then
			warn("credential headers error")

			return
		end

		local t3 = {
			headers = p8.headers or {},
			postBody = HttpService:JSONEncode({}),
			maxRetryCount = v8
		}
		local v23 = v9()

		return p4(v23, "POST", t3):andThen(function(_) -- line: 52
			-- upvalues: p3 (copy), FetchFriendsCarousel (copy), Promise (copy)
			p3(FetchFriendsCarousel()):andThen(function(_) -- line: 54
				-- upvalues: Promise (copy)
				return Promise.resolve()
			end, function(_) -- line: 56
				-- upvalues: Promise (copy)
				warn("Refresh friends carousel failed after syncing platform friends")

				return Promise.resolve()
			end)
		end, function(_) -- line: 61
			-- upvalues: p5 (copy), Promise (copy)
			warn("platform social graph sync request failed")
			p5.Diag:reportCounter("TriggerPlatformSocialGraphSyncFailed", 1)

			return Promise.resolve()
		end)
	end)
end

return syncPlatformSocialGraph
