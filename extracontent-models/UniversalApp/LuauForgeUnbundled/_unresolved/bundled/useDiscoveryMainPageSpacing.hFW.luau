local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useUiModeInfo
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy

local module = require("@luauforge/bundled/hFX")

local function useDiscoveryMainPageSpacing()
	local v5 = useTokens()
	local v6 = useUiModeInfo()
	local v7 = useAppPolicy(function(p2)
		return p2.useGridPageLayout()
	end)

	return React.useMemo(function()
		return module(v5, v6.uiMode == uiMode.TenFoot, v7)
	end, { v5, v6, v7 == true })
end

return useDiscoveryMainPageSpacing
