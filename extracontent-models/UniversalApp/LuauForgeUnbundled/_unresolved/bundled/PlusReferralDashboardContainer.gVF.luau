local module = require("@luauforge/bundled/gVG")

local module2 = require("@luauforge/bundled/gVH")
local module3 = require("@luauforge/bundled/gVX")

local function PlusReferralDashboardContainer()
	local v5 = module3()

	if v5 == nil then
		return nil
	end

	return module.createElement(module2, v5)
end

return PlusReferralDashboardContainer
