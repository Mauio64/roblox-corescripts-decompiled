local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/dCp")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isTenFootInterface
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")
local module3 = require("@luauforge/bundled/dHu")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab
local fFlagEnableBuildTabOverride = SharedFlags.FFlagEnableBuildTabOverride
local fFlagBuildTabUsesCanViewBuild = SharedFlags.FFlagBuildTabUsesCanViewBuild
local fFlagReplaceNavbarIconsWithFoundation = SharedFlags.FFlagReplaceNavbarIconsWithFoundation
local module5 = require("@luauforge/bundled/dHv")
local module6 = require("@luauforge/bundled/dHx")

local Foundation = require(CorePackages.Packages.Foundation)
local icon = Foundation.Icon
local iconName = Foundation.Enums.IconName
local iconVariant = Foundation.Enums.IconVariant
local iconSize = Foundation.Enums.IconSize
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local fFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local fFlagEnableArgus = SharedFlags.FFlagEnableArgus
local fFlagArgoEnableMoments = SharedFlags.FFlagArgoEnableMoments
local fFlagFlyoutRemoveMomentsForArgoEnabled = SharedFlags.FFlagFlyoutRemoveMomentsForArgoEnabled
local fFlagAppNavBarPerItemThemeOverride = SharedFlags.FFlagAppNavBarPerItemThemeOverride
local fFlagEnableSubTabForSpatial = SharedFlags.FFlagEnableSubTabForSpatial
local fFlagEnableChartsInFlyout = SharedFlags.FFlagEnableChartsInFlyout

local module7 = require("@luauforge/bundled/dHy")
local module8 = require("@luauforge/bundled/dHC")
local fFlagSubTabUseHomeContainerOnConsole = SharedFlags.FFlagSubTabUseHomeContainerOnConsole
local module9 = require("@luauforge/bundled/dHE")
local flyoutSidePanelIXP = require("@luauforge/bundled/dHD").FlyoutSidePanelIXP
local fFlagEnableAndroidTvAppPolicies = SharedFlags.FFlagEnableAndroidTvAppPolicies
local getFFlagEnableVRChartsTab = SharedFlags.GetFFlagEnableVRChartsTab
local fFlagRenameAvatarToMe = SharedFlags.FFlagRenameAvatarToMe
local fFlagAppChatOnConsoles = SharedFlags.FFlagAppChatOnConsoles
local module10 = require("@luauforge/bundled/dHF")

local v5 = if module10 then require("@luauforge/bundled/dHG") else nil

local module11 = require("@luauforge/bundled/dHJ")

local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy")

local v6 = false

local function fn(p2)
	local function fn2(p3)
		local tokens = useStyle().Tokens
		local v7 = if p3.isChecked then tokens.Color.Content.Emphasis else tokens.Color.Content.Default
		return React.createElement(module11, {
			Size = tokens.Size.Size_700,
			ZIndex = 0,
			BackgroundColor3 = v7.Color3,
			BackgroundTransparency = v7.Transparency
		})
	end

	local v7 = {
		page = module.Home,
		iconImage = 0,
		iconCheckedImage = 0,
		labelText = "CommonUI.Features.Label.Home",
		actionType = 0,
		badgeCount = nil
	}

	local v8 = if fFlagReplaceNavbarIconsWithFoundation then { name = iconName.House } else images["icons/menu/home_off"]
	v7.iconImage = v8

	local v9 = if fFlagReplaceNavbarIconsWithFoundation then {
		name = iconName.House,
		variant = iconVariant.Filled
	} else images["icons/menu/home_on"]
	v7.iconCheckedImage = v9

	v7.actionType = Enum.AppShellActionType.TapHomePageTab

	local v10 = {
		page = module.Games,
		iconImage = 0,
		iconCheckedImage = 0,
		labelText = "CommonUI.Features.Label.Charts",
		actionType = 0,
		badgeCount = nil
	}

	local v11 = if fFlagReplaceNavbarIconsWithFoundation then {
		name = iconName.ChartThreeVerticalBars
	} else images["icons/menu/charts_off"]
	v10.iconImage = v11

	local v12 = if fFlagReplaceNavbarIconsWithFoundation then {
		name = iconName.ChartThreeVerticalBars,
		variant = iconVariant.Filled
	} else images["icons/menu/charts_on"]
	v10.iconCheckedImage = v12

	v10.actionType = Enum.AppShellActionType.TapGamePageTab

	local v13 = {
		page = module.Moments,
		iconImage = 0,
		iconCheckedImage = 0,
		labelText = "CommonUI.Features.Label.Moments",
		actionType = nil,
		badgeCount = nil,
		preferredTheme = 0
	}

	local v14 = if fFlagReplaceNavbarIconsWithFoundation then {
		name = iconName.Moments
	} else images["icons/brands/moments"]
	v13.iconImage = v14

	local v15 = if fFlagReplaceNavbarIconsWithFoundation then {
		name = iconName.Moments,
		variant = iconVariant.Filled
	} else images["icons/brands/moments-fill"]
	v13.iconCheckedImage = v15

	v13.preferredTheme = fFlagAppNavBarPerItemThemeOverride and "Dark" or nil
	local v16

	if fFlagAppIaHomeSubTab then
		v16 = {
			page = NavigationRodux.Constants.HomeContainerName,
			subTabPages = module3.Constants.HOME_CONTAINER_SUB_TAB_PAGES,
			iconImage = 0,
			iconCheckedImage = 0,
			labelText = "CommonUI.Features.Label.Home",
			actionType = 0,
			badgeCount = nil
		}

		local v17 = if fFlagReplaceNavbarIconsWithFoundation then {
			name = iconName.House
		} else images["icons/menu/home_off"]
		v16.iconImage = v17

		local v18 = if fFlagReplaceNavbarIconsWithFoundation then {
			name = iconName.House,
			variant = iconVariant.Filled
		} else images["icons/menu/home_on"]
		v16.iconCheckedImage = v18

		v16.actionType = Enum.AppShellActionType.TapHomePageTab
	end

	local function fn3(p3, p4)
		return React.createElement(fn2, { isChecked = p3 })
	end

	local v17 = {
		page = module.AvatarExperienceRoot,
		renderIcon = module10 and function(p3, p4)
			return React.createElement(v5, {
				renderIcon = fn3,
				isChecked = p3,
				controlState = p4
			})
		end or fn3,
		labelText = fFlagRenameAvatarToMe and "CommonUI.Features.Label.Me" or "CommonUI.Features.Label.Avatar",
		actionType = Enum.AppShellActionType.TapAvatarTab,
		badgeCount = nil
	}

	local v18 = module7()
	local v19 = {
		page = module.Chat,
		iconImage = fFlagReplaceNavbarIconsWithFoundation and { name = v18.icon } or nil,
		iconCheckedImage = fFlagReplaceNavbarIconsWithFoundation and {
			name = v18.icon,
			variant = iconVariant.Filled
		} or nil,
		labelText = v18.label,
		actionType = Enum.AppShellActionType.TapChatTab,
		badgeCount = nil,
		renderIcon = not fFlagReplaceNavbarIconsWithFoundation and function(p3)
			local createElement = React.createElement

			local createElement2 = React.createElement
			local v24 = { name = v18.icon, size = iconSize.Large, variant = 0 }
			local v25 = if p3 then iconVariant.Filled else iconVariant.Regular
			v24.variant = v25
			return createElement(view, { tag = "auto-xy padding-xxsmall" }, {
				Icon = createElement2(icon, v24)
			})
		end or nil
	}

	local v20 = {
		page = module.More,
		iconImage = 0,
		iconCheckedImage = 0,
		labelText = "CommonUI.Features.Label.More",
		actionType = nil,
		badgeCount = nil
	}

	local v21 = if fFlagReplaceNavbarIconsWithFoundation then {
		name = iconName.CircleThreeDotsHorizontal
	} else images["icons/menu/more_off"]
	v20.iconImage = v21

	local v22 = if fFlagReplaceNavbarIconsWithFoundation then {
		name = iconName.CircleThreeDotsHorizontal,
		variant = iconVariant.Filled
	} else images["icons/menu/more_on"]
	v20.iconCheckedImage = v22
	local v23

	if fFlagBuildTabUsesCanViewBuild then
		v23 = module6(UniversalAppPolicy.getAppFeaturePolicies())
	else
		v23 = fFlagEnableBuildTabOverride

		if fFlagAppNavMyStatsTab and not fFlagEnableBuildTabOverride then
			v23 = UniversalAppPolicy.getAppFeaturePolicies().getCanViewBuild()
		end
	end

	local v24

	if v23 then
		local function fn4(p3)
			local v25 = useTokens()
			React.useEffect(function()
				if not v6 then
					v6 = true
					module5("TAB_IMPRESSION", {})
				end
			end, {})

			local createElement = React.createElement

			local createElement2 = React.createElement
			local v30 = {
				name = iconName.Nebula,
				size = iconSize.Large,
				variant = 0,
				style = 0
			}
			local v31 = if p3.isChecked then iconVariant.Filled else iconVariant.Regular
			v30.variant = v31
			local v32 = if p3.isChecked then v25.Color.Content.Emphasis else v25.Color.Content.Default
			v30.style = v32
			return createElement(view, { tag = "auto-xy padding-xxsmall" }, {
				Icon = createElement2(icon, v30)
			})
		end

		v24 = {
			page = module.Build,
			renderIcon = function(p3, p4)
				return React.createElement(fn4, { isChecked = p3 })
			end,
			labelText = "CommonUI.Features.NavBar.Build",
			actionType = nil,
			badgeCount = nil
		}
	end

	local v25 = {
		page = module.ViewFriends,
		labelText = "Feature.SocialTab.Label.Connect",
		iconImage = 0,
		iconCheckedImage = 0,
		actionType = 0,
		badgeCount = nil
	}

	local v26 = if fFlagReplaceNavbarIconsWithFoundation then {
		name = iconName.TwoPeople
	} else images["icons/menu/friends"]
	v25.iconImage = v26

	local v27 = if fFlagReplaceNavbarIconsWithFoundation then {
		name = iconName.TwoPeople,
		variant = iconVariant.Filled
	} else images["icons/menu/friendsOn"]
	v25.iconCheckedImage = v27

	v25.actionType = Enum.AppShellActionType.TapChatTab

	local vrAppBuild = isVRAppBuild()
	local tenFootInterface = isTenFootInterface()

	local v28 = false

	if p2 == nil then
		if fFlagEnableArgus and require("@luauforge/bundled/dTP")(false).getHasMomentsAccess(false) then
			v28 = fFlagArgoEnableMoments
		end
	else
		v28 = p2
	end

	local v29

	if vrAppBuild then
		v17.isSecondary = true
		v29 = fFlagEnableSubTabForSpatial
			and fFlagAppIaHomeSubTab
			and flyoutSidePanelIXP.isHomeSubTabEnabled()
			and { v16, v19, v20, v17 }
			or getFFlagEnableVRChartsTab() and { v7, v10, v19, v20, v17 }
			or { v7, v19, v20, v17 }
	elseif tenFootInterface then
		if fFlagSubTabUseHomeContainerOnConsole and fFlagAppIaHomeSubTab then
			if not flyoutSidePanelIXP.isHomeSubTabEnabled() then
				v16 = v7
			end
		else
			v16 = v7
		end

		v29 = { nil, nil, nil, nil }

		if fFlagAppChatOnConsoles then
			v25 = v19
		end

		v29[1], v29[2], v29[3], v29[4] = v16, v17, v25, v20
	elseif fFlagAppIaHomeSubTab and flyoutSidePanelIXP.isHomeSubTabEnabled() then
		v29 = module9 and { v16, v19, v17, v20 } or { v16, v17, v19, v20 }

		if v23 and not tenFootInterface then
			table.insert(v29, module9 and 2 or 3, v24)
		end
	else
		v29 = module9 and { v7, v10, v19, v17, v20 } or { v7, v10, v17, v19, v20 }

		if v23 and not tenFootInterface then
			table.insert(v29, module9 and 3 or 4, v24)
		end
	end

	if not v28 then
		return v29
	end

	local v30 = if fFlagFlyoutRemoveMomentsForArgoEnabled then require("@luauforge/bundled/dTZ") else nil
	local v31

	if fFlagFlyoutRemoveMomentsForArgoEnabled then
		v31 = v30()
	else
		v31 = not (vrAppBuild or tenFootInterface)
	end

	if v31 then
		table.insert(v29, 2, v13)
	end

	return v29
end

function LUAUFORGE_MODULE_GLOBALS_dHt_getBottomBarItems(p2)
	return fn(p2)
end

return function(p2)
	local result = {}
	local filtered = LUAUFORGE_MODULE_GLOBALS_dHt_getBottomBarItems(p2)

	if not isTenFootInterface() or fFlagAppChatOnConsoles then
		local getCanSeeChatTab = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTab

		if getCanSeeChatTab and not getCanSeeChatTab() then
			filtered = Cryo.List.filter(filtered, function(p3): boolean
				return p3.page ~= module.Chat
			end)
		end
	end

	if module8 then
		filtered = Cryo.List.filter(filtered, function(p3): boolean
			return p3.page ~= module.More
		end)
	end

	if fFlagEnableChartsInFlyout and flyoutSidePanelIXP.isChartsInFlyoutEnabled() then
		filtered = Cryo.List.filter(filtered, function(p3): boolean
			return p3.page ~= module.Games
		end)
	end

	if fFlagEnableAndroidTvAppPolicies then
		local getHidesGamesTab = UniversalAppPolicy.getAppFeaturePolicies().getHidesGamesTab

		if getHidesGamesTab and getHidesGamesTab() then
			filtered = Cryo.List.filter(filtered, function(p3): boolean
				return p3.page ~= module.Games
			end)
		end
	end

	for i, v7 in ipairs(filtered) do
		if fFlagAppIaHomeSubTab and v7.subTabPages then
			for j, subTabPage in ipairs(v7.subTabPages) do
				result[subTabPage] = i
			end
		else
			result[v7.page] = i
		end
	end

	return filtered, result
end
