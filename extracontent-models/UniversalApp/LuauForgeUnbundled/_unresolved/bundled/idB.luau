local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/frD")
local enumerate = require(CorePackages.Packages.enumerate)

local v5 = {
	Unknown = "DENIED_REASON_UNKNOWN",
	RateLimited = "DENIED_REASON_RATE_LIMITED"
}

local v6 = enumerate("DeniedReason", v5)

module(v6, v5)

return v6
