local CorePackages = game:GetService("CorePackages")

local Dash = require(CorePackages.Packages.Dash)
local React = require(CorePackages.Packages.React)
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks")
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode
local module3 = require("@luauforge/deferred/fya")
local useBillingTabVisibility = require("@luauforge/deferred/hHE").useBillingTabVisibility
local module4 = require("@luauforge/deferred/hHL")

local fFlagUnifyConsoleSettingsPage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUnifyConsoleSettingsPage
local module5 = require("@luauforge/bundled/dCp")

local function useSettingsPageItems(p2)
	local v5

	if fFlagUnifyConsoleSettingsPage then
		v5 = useAppPolicy(function(p3): boolean
			return not p3.getWebViewSupport()
		end)
	else
		v5 = nil
	end

	local v6 = useAppPolicy(function(p3)
		if fFlagUnifyConsoleSettingsPage and v5 then
			return module5.Settings
		end

		return p2 or p3.getSettingsPageType()
	end)

	local v7 = useAppPolicy(function(p3)
		return p3.getAllowPlatformAccountSwitching()
	end)

	local v8 = RobloxAppHooks.useUiModeInfo().uiMode == uiMode.TenFoot

	local v9 = not module4 and { showBillingTab = true } or useBillingTabVisibility()

	local v10 = React.useMemo(function()
		return { [module3.ItemType.Settings_SwitchProfileSection] = v7 }
	end, { v7 })

	local useMemo = React.useMemo
	local function fn()
		local v11 = module4 and {
			hideBillingTab = not v9.showBillingTab
		} or nil

		local getItemsInPage = module3.GetItemsInPage
		local v16 = if fFlagUnifyConsoleSettingsPage then v5 else nil
		local itemsInPage = getItemsInPage(v6, nil, nil, v11, nil, v16)

		local mapped = Dash.map(itemsInPage, function(p3)
			return p3.contents
		end)

		return (Dash.map(mapped, function(p3)
			return Dash.filter(p3, function(p4): boolean
				if fFlagUnifyConsoleSettingsPage or not v8 then
					return v10[p4.itemType] ~= false
				end

				return v10[p4.itemInfo.itemType] ~= false
			end)
		end))
	end

	local v12 = if module4 then not v9.showBillingTab else nil
	return useMemo(fn, {
		v6,
		v8,
		v10,
		v12,
		if fFlagUnifyConsoleSettingsPage then v5 else nil
	})
end

return useSettingsPageItems
