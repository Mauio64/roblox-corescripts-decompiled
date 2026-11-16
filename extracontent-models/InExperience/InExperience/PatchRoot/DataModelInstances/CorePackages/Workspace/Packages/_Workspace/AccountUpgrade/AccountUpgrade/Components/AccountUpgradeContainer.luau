local AccountUpgrade = script:FindFirstAncestor("AccountUpgrade")
local parent = AccountUpgrade.Parent
local React = require(parent.React)

local AccountUpgradeView = require(script.Parent.AccountUpgradeView)
local useAccountUpgradeViewModel = require(script.Parent.useAccountUpgradeViewModel)
local FFlagEnableDesktopSsoSignupDialog = require(AccountUpgrade.Flags.FFlagEnableDesktopSsoSignupDialog)

local function AccountUpgradeContainer(p)
	local v = useAccountUpgradeViewModel(p)

	if FFlagEnableDesktopSsoSignupDialog and p.isHidden then
		return nil
	end

	return React.createElement(AccountUpgradeView, v)
end

return AccountUpgradeContainer
