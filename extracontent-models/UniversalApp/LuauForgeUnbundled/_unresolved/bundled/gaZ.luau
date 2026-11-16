local module = require("@luauforge/bundled/gba")
local module2 = require("@luauforge/bundled/gbb")
local module3 = require("@luauforge/bundled/gbc")

local v5 = module2.Logger.new(nil, "InviteLinkExpiredModal"):new("InviteLinkExpiredModal Networking")
local defineFastInt = game:DefineFastInt("InviteLinkExpiredModalHttpRetryCount", 3)

local httpRequest = module.httpRequest
local config = httpRequest.config({
	requestFunction = function(p2, p3, p4)
		v5:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p3, p2))
		return httpRequest.requestFunctions.HttpRbxApi(p2, p3, p4)
	end,
	postRequestFunction = function(p2, p3)
		v5:debug(
			"Returned: {}",
			string.format(
				"[ requestMethod = %q, url = %q, statusCode = %s, body = %s ]",
				p3.requestMethod,
				p3.url,
				p2.StatusCode,
				p2.Body
			)
		)
	end,
	maxRetryCount = defineFastInt
})

local config2 = module.RoduxNetworking.config({
	keyPath = "InviteLinkExpiredModal.NetworkStatus",
	networkImpl = config
})

return {
	Dash = require("@luauforge/bundled/gbd"),
	Roact = require("@luauforge/bundled/gbe"),
	RoactRodux = require("@luauforge/bundled/gbf"),
	RoactNavigation = require("@luauforge/bundled/gbg"),
	Rodux = require("@luauforge/bundled/gbh"),
	t = require("@luauforge/bundled/gbi"),
	UIBlox = require("@luauforge/bundled/gbj"),
	Foundation = require("@luauforge/bundled/gbk"),
	LocalizationProvider = require("@luauforge/bundled/gbl").LocalizationProvider,
	withLocalization = require("@luauforge/bundled/gbl").withLocalization,
	llama = module.llama,
	SocialLibraries = module.SocialLibraries.config({}),
	RoduxGames = module.RoduxGames.config({ keyPath = "InviteLinkExpiredModal.Games" }),
	ShareLinksRodux = module3.config({ keyPath = "InviteLinkExpiredModal.ShareLinks" }),
	RoduxNetworking = config2,
	NetworkingGames = module.NetworkingGames.config({ roduxNetworking = config2 })
}
