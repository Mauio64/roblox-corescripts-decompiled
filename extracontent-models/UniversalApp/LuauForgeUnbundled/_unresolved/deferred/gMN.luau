local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/fyX")
local enumerate = require(CorePackages.Packages.enumerate)

local v5 = {
	Shown = "PremiumUpsellShown",
	Confirmed = "PremiumUpsellConfirmed",
	Cancelled = "PremiumUpsellCancelled",
	Failed = "PremiumUpsellFailed",
	InvalidProducts = "PremiumUpsellFailedInvalidProducts"
}

local v6 = enumerate("PremiumUpsellCounter", v5)

module(v6, v5)

return v6
