local module = require("@luauforge/bundled/gFJ")
local module2 = require("@luauforge/bundled/gFK")
local module3 = require("@luauforge/bundled/gFL")

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
	Dash = require("@luauforge/bundled/gFM"),
	Roact = require("@luauforge/bundled/gFN"),
	RoactRodux = require("@luauforge/bundled/gFO"),
	RoactNavigation = require("@luauforge/bundled/gFP"),
	Rodux = require("@luauforge/bundled/gFQ"),
	t = require("@luauforge/bundled/gFR"),
	UIBlox = require("@luauforge/bundled/gFS"),
	Foundation = require("@luauforge/bundled/gFT"),
	LocalizationProvider = require("@luauforge/bundled/gFU").LocalizationProvider,
	withLocalization = require("@luauforge/bundled/gFU").withLocalization,
	llama = module.llama,
	SocialLibraries = module.SocialLibraries.config({}),
	RoduxGames = module.RoduxGames.config({ keyPath = "InviteLinkExpiredModal.Games" }),
	ShareLinksRodux = module3.config({ keyPath = "InviteLinkExpiredModal.ShareLinks" }),
	RoduxNetworking = config2,
	NetworkingGames = module.NetworkingGames.config({ roduxNetworking = config2 })
}
