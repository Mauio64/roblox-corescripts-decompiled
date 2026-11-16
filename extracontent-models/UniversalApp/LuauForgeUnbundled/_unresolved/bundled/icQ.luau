local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/frD")
local enumerate = require(CorePackages.Packages.enumerate)

local v5 = {
	Unknown = "Unknown",
	Invalidated = "Invalidated",
	Abandoned = "Abandoned",
	LoadFailed = "LoadFailed",
	RateLimited = "RateLimited"
}

local v6 = enumerate("ErrorKind", v5)

module(v6, v5)

return v6
