local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/ftF")
local module2 = require("@luauforge/bundled/ftD")
local module3 = require("@luauforge/bundled/ftG")
local Cryo = require(CorePackages.Packages.Cryo)

return function(p2, data)
	local v5 = p2
		or {
			showBuyRobuxButtonBadge = false,
			buyRobuxButtonClicked = false,
			hasFetchedRobuxBadge = false
		}

	assert(v5, "")

	if data.type == module.name then
		return Cryo.Dictionary.join(v5, {
			showBuyRobuxButtonBadge = data.showBuyRobuxButtonBadge
		})
	end

	if data.type == module2.name then
		return Cryo.Dictionary.join(v5, {
			buyRobuxButtonClicked = data.buyRobuxButtonClicked
		})
	end

	if data.type == module3.name then
		return Cryo.Dictionary.join(v5, {
			hasFetchedRobuxBadge = data.hasFetchedRobuxBadge
		})
	end

	return v5
end
