local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Dash = require(CorePackages.Packages.Dash)
local React = require(CorePackages.Packages.React)
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)
local RobloxAppHooks = require(CorePackages.Workspace.Packages.RobloxAppHooks)
local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local MorePageSettings = require(Modules.LuaApp.Components.More.Config.MorePageSettings)
local useBillingTabVisibility = require(CorePackages.Workspace.Packages.SettingsTabVisibility).useBillingTabVisibility
local FFlagEnableBillingTabHideLogic = require(Modules.LuaApp.Flags.FFlagEnableBillingTabHideLogic)

local function useSettingsPageItems(s1: string?) -- line: 14
	-- upvalues: useAppPolicy (copy), RobloxAppHooks (copy), UiMode (copy), FFlagEnableBillingTabHideLogic (copy), useBillingTabVisibility (copy), React (copy), MorePageSettings (copy), Dash (copy)
	local v13 = useAppPolicy(function(p1) -- line: 15
		-- upvalues: s1 (copy)
		return s1 or p1.getSettingsPageType()
	end)
	local v14 = useAppPolicy(function(p2) -- line: 19
		return p2.getAllowPlatformAccountSwitching()
	end)
	local v15 = RobloxAppHooks.useUiModeInfo().uiMode == UiMode.TenFoot
	local v16 = if not FFlagEnableBillingTabHideLogic then {
		showBillingTab = true
	} else useBillingTabVisibility()
	local v17 = React.useMemo(function() -- line: 30
		-- upvalues: MorePageSettings (copy), v14 (copy)
		return {
			[MorePageSettings.ItemType.Settings_SwitchProfileSection] = v14
		}
	end, { v14 })

	return React.useMemo(function() -- line: 37
		-- upvalues: FFlagEnableBillingTabHideLogic (copy), v16 (copy), MorePageSettings (copy), v13 (copy), Dash (copy), v15 (copy), v17 (copy)
		local v20 = if not FFlagEnableBillingTabHideLogic then nil else {
			hideBillingTab = not v16.showBillingTab
		}
		local v21 = MorePageSettings.GetItemsInPage(v13, nil, nil, v20)
		local v22 = Dash.map(v21, function(p3) -- line: 46
			return p3.contents
		end)

		return (Dash.map(v22, function(p4) -- line: 50
			-- upvalues: Dash (copy), v15 (copy), v17 (copy)
			return Dash.filter(p4, function(p5) -- line: 51
				-- upvalues: v15 (copy), v17 (copy)
				if v15 then
					return v17[p5.itemInfo.itemType] ~= false
				end

				return v17[p5.itemType] ~= false
			end)
		end))
	end, {
		v13,
		v15,
		v17,
		if not FFlagEnableBillingTabHideLogic then nil else not v16.showBillingTab
	})
end

return useSettingsPageItems
