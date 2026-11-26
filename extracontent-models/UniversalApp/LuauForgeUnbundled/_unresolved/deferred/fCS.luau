local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/fyX")
local enumerate = require(CorePackages.Packages.enumerate)

local v5 = { UACatalog = "UACatalog" }

local v6 = enumerate("PremiumUpsellTriggerContext", v5)

module(v6, v5)

return v6
