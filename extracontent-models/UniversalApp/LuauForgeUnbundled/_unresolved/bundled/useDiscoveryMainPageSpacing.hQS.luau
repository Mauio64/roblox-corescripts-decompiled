local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useUiModeInfo
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy

local fFlagEnableIsChartsInSubTab = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableIsChartsInSubTab

local module = require("@luauforge/bundled/hQT")

local function useDiscoveryMainPageSpacing(p2)
	local v5 = useTokens()
	local v6 = useUiModeInfo()
	local v7 = useAppPolicy(function(p3)
		return p3.useGridPageLayout()
	end)

	local function fn()
		return module(v5, v6.uiMode == uiMode.TenFoot, v7, p2)
	end

	return React.useMemo(fn, {
		v5,
		v6,
		v7 == true,
		if fFlagEnableIsChartsInSubTab then p2 else nil
	})
end

return useDiscoveryMainPageSpacing
