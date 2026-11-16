local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/frD")
local enumerate = require(CorePackages.Packages.enumerate)

local v5 = {
	EXPERIENCE_AFFILIATE_DEEP_LINK_FALLBACK_TYPE_INVALID = 0,
	EXPERIENCE_AFFILIATE_DEEP_LINK_FALLBACK_TYPE_PROFILE = 1,
	EXPERIENCE_AFFILIATE_DEEP_LINK_FALLBACK_TYPE_HOME = 2
}

local v6 = enumerate("ExperienceAffiliateDeepLinkFallbackType", v5)

module(v6, v5)

return v6
