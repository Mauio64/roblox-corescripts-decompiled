local module = require("@luauforge/bundled/fsz")
local pioneerAgeRestrictedBlocked = module.Events.pioneerAgeRestrictedBlocked
local pioneerAgeRestrictedInterstitialImpression = module.Events.pioneerAgeRestrictedInterstitialImpression

return {
	reportBlocked = function(p2)
		pioneerAgeRestrictedBlocked("pioneerAgeRestricted", p2)
	end,
	reportInterstitialImpression = function(p2)
		pioneerAgeRestrictedInterstitialImpression("pioneerAgeRestricted", p2)
	end
}
