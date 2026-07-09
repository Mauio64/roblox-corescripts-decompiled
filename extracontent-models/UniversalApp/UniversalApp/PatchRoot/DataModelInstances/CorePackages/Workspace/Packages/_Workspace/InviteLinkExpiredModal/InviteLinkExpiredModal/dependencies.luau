local Parent = script:FindFirstAncestor("InviteLinkExpiredModal").Parent
local LuaSocialLibrariesDeps = require(Parent.LuaSocialLibrariesDeps)
local Lumberyak = require(Parent.Lumberyak)
local ShareLinksRodux = require(Parent.ShareLinksRodux)
local v5 = Lumberyak.Logger.new(nil, "InviteLinkExpiredModal"):new("InviteLinkExpiredModal Networking")
local v6 = game:DefineFastInt("InviteLinkExpiredModalHttpRetryCount", 3)
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local v8 = httpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 14
		-- upvalues: v5 (copy), httpRequest (copy)
		v5:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p1))

		return httpRequest.requestFunctions.HttpRbxApi(p1, p2, p3)
	end,
	postRequestFunction = function(p4, p5) -- line: 19
		-- upvalues: v5 (copy)
		v5:debug("Returned: {}", string.format("[ requestMethod = %q, url = %q, statusCode = %s, body = %s ]", p5.requestMethod, p5.url, p4.StatusCode, p4.Body))
	end,
	maxRetryCount = v6
})
local v9 = LuaSocialLibrariesDeps.RoduxNetworking.config({
	keyPath = "InviteLinkExpiredModal.NetworkStatus",
	networkImpl = v8
})

return {
	Dash = require(Parent.Dash),
	Roact = require(Parent.Roact),
	RoactRodux = require(Parent.RoactRodux),
	RoactNavigation = require(Parent.RoactNavigation),
	Rodux = require(Parent.Rodux),
	t = require(Parent.t),
	UIBlox = require(Parent.UIBlox),
	Foundation = require(Parent.Foundation),
	LocalizationProvider = require(Parent.Localization).LocalizationProvider,
	withLocalization = require(Parent.Localization).withLocalization,
	llama = LuaSocialLibrariesDeps.llama,
	SocialLibraries = LuaSocialLibrariesDeps.SocialLibraries.config({}),
	RoduxGames = LuaSocialLibrariesDeps.RoduxGames.config({
		keyPath = "InviteLinkExpiredModal.Games"
	}),
	ShareLinksRodux = ShareLinksRodux.config({
		keyPath = "InviteLinkExpiredModal.ShareLinks"
	}),
	RoduxNetworking = v9,
	NetworkingGames = LuaSocialLibrariesDeps.NetworkingGames.config({
		roduxNetworking = v9
	})
}
