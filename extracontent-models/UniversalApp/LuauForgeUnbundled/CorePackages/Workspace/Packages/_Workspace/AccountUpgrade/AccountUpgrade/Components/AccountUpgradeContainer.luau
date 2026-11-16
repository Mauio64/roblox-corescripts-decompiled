local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/React")

local AccountUpgradeView = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Components/AccountUpgradeView")
local useAccountUpgradeViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Components/useAccountUpgradeViewModel")
local module4 = require("@luauforge/bundled/fSc")

local function AccountUpgradeContainer(p2)
	local v5 = useAccountUpgradeViewModel(p2)

	if module4 and p2.isHidden then
		return nil
	end

	return React.createElement(AccountUpgradeView, v5)
end

return AccountUpgradeContainer
