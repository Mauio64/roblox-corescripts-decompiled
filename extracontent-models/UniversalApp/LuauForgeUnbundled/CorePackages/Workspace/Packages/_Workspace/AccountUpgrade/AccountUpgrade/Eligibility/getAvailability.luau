local AccountUpgradeFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/AccountUpgradeFlow")
local getPioneerAccountUpgradeAvailability = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Eligibility/getPioneerAccountUpgradeAvailability")

local modules = { [AccountUpgradeFlow.Pioneer] = getPioneerAccountUpgradeAvailability, [AccountUpgradeFlow.PioneerU13] = getPioneerAccountUpgradeAvailability }

local function getAvailability(p2)
	local v5 = modules[p2]
	assert(v5 ~= nil, `Unsupported account upgrade flow: {p2}`)
	return v5()
end

return getAvailability
