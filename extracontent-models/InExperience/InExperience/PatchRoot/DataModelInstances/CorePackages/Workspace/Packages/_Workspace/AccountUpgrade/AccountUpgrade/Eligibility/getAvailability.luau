local AccountUpgrade = script:FindFirstAncestor("AccountUpgrade")

local AccountUpgradeFlow = require(AccountUpgrade.AccountUpgradeFlow)
local getPioneerAccountUpgradeAvailability = require(script.Parent.getPioneerAccountUpgradeAvailability)

local getPioneerAccountUpgradeAvailabilities = {
	[AccountUpgradeFlow.Pioneer] = getPioneerAccountUpgradeAvailability,
	[AccountUpgradeFlow.PioneerU13] = getPioneerAccountUpgradeAvailability
}

local function getAvailability(p)
	local v = getPioneerAccountUpgradeAvailabilities[p]
	assert(v ~= nil, `Unsupported account upgrade flow: {p}`)
	return v()
end

return getAvailability
