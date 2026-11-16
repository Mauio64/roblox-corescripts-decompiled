local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/frD")
local enumerate = require(CorePackages.Packages.enumerate)

local v5 = { TextOnlyBanner = "DISPLAY_TYPE_TEXT_ONLY_BANNER" }

local v6 = enumerate("DisplayType", v5)

module(v6, v5)

return v6
