local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Models = require("@game/CorePackages/Packages/_Index/RoduxUsers/RoduxUsers/Models")
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local appBtidLayers = require("@luauforge/bundled/dMA").AppBtidLayers
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local module2 = require("@luauforge/bundled/fsy")
local module3 = require("@luauforge/bundled/fMG")
local module4 = require("@luauforge/bundled/fDx")

local function shouldFlyoutShowAccountSwitch()
	local v5 = useAppPolicy(function(p2)
		return p2
	end)

	local v6 = RoactAppExperiment.useBrowserTrackerExperiment(
		{ appBtidLayers.AccountSwitcherLayer },
		function(p2)
			return p2[appBtidLayers.AccountSwitcherLayer] or {}
		end
	)

	local v7 = Models.fromLocalStorage()
	local accountSwitcherEnabled = v5.getAccountSwitcherEnabled()

	local v8 = v7.isUnder13 ~= true

	local excludeAccountSwitcher = v5.getExcludeAccountSwitcher()
	local v9 = module4 and not excludeAccountSwitcher and v8 and accountSwitcherEnabled
	local v10

	if excludeAccountSwitcher then
		v10 = module2.State.SwitchAccountsExclusionsHidden
	elseif v8 then
		v10 = if v9 then module2.State.SwitchAccountsShown else module2.State.SwitchAccountsAmpHidden
	else
		v10 = module2.State.SwitchAccountsU13Hidden
	end

	local v11 = useRoactService(module3)

	React.useEffect(function()
		v11.reportAuthButtonShown(
			module2.Context.FlyoutSidePanel,
			module2.Button.SwitchAccounts,
			v10,
			module2.Origin.FlyoutSidePanel
		)
	end, { v10 })

	return v9, v6.enableAccountSwitcherSignedOutAccounts == true
end

return shouldFlyoutShowAccountSwitch
