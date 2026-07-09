local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local AppPage = require(Modules.LuaApp.AppPage)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local NavigationRodux = require(CorePackages.Workspace.Packages.NavigationRodux)
local AppNavBar = require(CorePackages.Workspace.Packages.AppNavBar)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab
local ArgoPartyExperimentation = require(CorePackages.Workspace.Packages.SocialExperiments).ArgoPartyExperimentation
local sendBuildExperienceEvent = require(CorePackages.Workspace.Packages.BuildExperience.sendBuildExperienceEvent)
local Icon = nil
local IconName = nil
local IconVariant = nil
local IconSize = nil
local View = nil
local useTokens = nil

if FFlagAppNavMyStatsTab or ArgoPartyExperimentation.getIsRenameEnabled() then
	local Foundation = require(CorePackages.Packages.Foundation)

	Icon = Foundation.Icon
	IconName = Foundation.Enums.IconName
	IconVariant = Foundation.Enums.IconVariant
	IconSize = Foundation.Enums.IconSize
	View = Foundation.View
	useTokens = Foundation.Hooks.useTokens
end

local FFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local FFlagEnableArgus = SharedFlags.FFlagEnableArgus
local FFlagEnableArgusTab = SharedFlags.FFlagEnableArgusTab
local AvatarHeadshotSystemBarIcon = require(Modules.AvatarExperience.Common.Components.AvatarHeadshotSystemBarIcon)
local getAppChatNavbarItemConfig = require(CorePackages.Workspace.Packages.AppChat.getAppChatNavbarItemConfig)
local FFlagEnableFlyoutSidePanel = require(Modules.LuaApp.Flags.FFlagEnableFlyoutSidePanel)
local FFlagMeTabRightOfPartyBottomNav = require(Modules.LuaApp.Flags.FFlagMeTabRightOfPartyBottomNav)
local FlyoutSidePanelIXP = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).FlyoutSidePanelIXP
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local FFlagEnableAndroidTvAppPolicies = SharedFlags.FFlagEnableAndroidTvAppPolicies
local GetFFlagEnableVRChartsTab = SharedFlags.GetFFlagEnableVRChartsTab
local FFlagRenameAvatarToMe = SharedFlags.FFlagRenameAvatarToMe
local AvatarHeadshotLocalIcon = require(Modules.AvatarExperience.Common.Components.AvatarHeadshotLocalIcon)
local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)
local t1 = {
	{
		titleLocalizationKey = "CommonUI.Features.Label.Home",
		actionType = nil,
		page = AppPage.Home,
		iconImage = Images["icons/menu/home_on"]
	},
	{
		page = AppPage.AvatarExperienceRoot,
		titleLocalizationKey = not FFlagRenameAvatarToMe and "CommonUI.Features.Label.Avatar" or "CommonUI.Features.Label.Me",
		iconComponent = AvatarHeadshotSystemBarIcon,
		actionType = Enum.AppShellActionType.TapAvatarTab
	},
	{
		titleLocalizationKey = "Feature.SocialTab.Label.Connect",
		page = AppPage.ViewFriends,
		iconImage = Images["icons/menu/friendsOn"],
		actionType = Enum.AppShellActionType.TapChatTab
	}
}
local u40 = false

local function v41() -- line: 81
	-- upvalues: useStyle (copy), React (copy), AvatarHeadshotLocalIcon (copy), AppPage (copy), Images (copy), FFlagAppIaHomeSubTab (copy), NavigationRodux (copy), AppNavBar (copy), FFlagRenameAvatarToMe (copy), getAppChatNavbarItemConfig (copy), ArgoPartyExperimentation (copy), Icon (ref), IconVariant (ref), FFlagAppNavMyStatsTab (copy), useTokens (ref), u40 (ref), sendBuildExperienceEvent (copy), View (ref), IconName (ref), IconSize (ref), FFlagEnableLeftNavOnConsole (copy), IsVRAppBuild (copy), GuiService (copy), FFlagEnableArgus (copy), UniversalAppPolicy (copy), CorePackages (copy), FFlagEnableArgusTab (copy), GetFFlagEnableVRChartsTab (copy), FlyoutSidePanelIXP (copy), FFlagMeTabRightOfPartyBottomNav (copy)
	local function v42(p1) -- line: 82
		-- upvalues: useStyle (copy), React (copy), AvatarHeadshotLocalIcon (copy)
		local Tokens = useStyle().Tokens
		local v68 = if not p1.isChecked then Tokens.Color.Content.Default else Tokens.Color.Content.Emphasis

		return React.createElement(AvatarHeadshotLocalIcon, {
			ZIndex = 0,
			Size = Tokens.Size.Size_700,
			BackgroundColor3 = v68.Color3,
			BackgroundTransparency = v68.Transparency
		})
	end

	local t2 = {
		labelText = "CommonUI.Features.Label.Home",
		badgeCount = nil,
		page = AppPage.Home,
		iconImage = Images["icons/menu/home_off"],
		iconCheckedImage = Images["icons/menu/home_on"],
		actionType = Enum.AppShellActionType.TapHomePageTab
	}
	local t3 = {
		labelText = "CommonUI.Features.Label.Charts",
		badgeCount = nil,
		page = AppPage.Games,
		iconImage = Images["icons/menu/charts_off"],
		iconCheckedImage = Images["icons/menu/charts_on"],
		actionType = Enum.AppShellActionType.TapGamePageTab
	}
	local t4 = {
		labelText = "CommonUI.Features.Label.Moments",
		actionType = nil,
		badgeCount = nil,
		page = AppPage.Moments,
		iconImage = Images["icons/brands/moments"],
		iconCheckedImage = Images["icons/brands/moments-fill"]
	}
	local v46 = if not FFlagAppIaHomeSubTab then nil else {
		labelText = "CommonUI.Features.Label.Home",
		badgeCount = nil,
		page = NavigationRodux.Constants.HomeContainerName,
		subTabPages = AppNavBar.Constants.HOME_CONTAINER_SUB_TAB_PAGES,
		iconImage = Images["icons/menu/home_off"],
		iconCheckedImage = Images["icons/menu/home_on"],
		actionType = Enum.AppShellActionType.TapHomePageTab
	}
	local t5 = {
		badgeCount = nil,
		page = AppPage.AvatarExperienceRoot,
		renderIcon = function(b1: boolean, _) -- line: 133
			-- upvalues: React (copy), v42 (copy)
			return React.createElement(v42, {
				isChecked = b1
			})
		end,
		labelText = not FFlagRenameAvatarToMe and "CommonUI.Features.Label.Avatar" or "CommonUI.Features.Label.Me",
		actionType = Enum.AppShellActionType.TapAvatarTab
	}
	local v48 = getAppChatNavbarItemConfig()
	local t6 = {
		badgeCount = nil,
		page = AppPage.Chat,
		iconImage = if not ArgoPartyExperimentation.getIsRenameEnabled() then Images[v48.icon.off] else nil,
		iconCheckedImage = if not ArgoPartyExperimentation.getIsRenameEnabled() then Images[v48.icon.on] else nil,
		labelText = v48.label,
		actionType = Enum.AppShellActionType.TapChatTab,
		renderIcon = if not ArgoPartyExperimentation.getIsRenameEnabled() then nil else function(b2: boolean) -- line: 151
			-- upvalues: React (copy), Icon (ref), v48 (copy), IconVariant (ref)
			return React.createElement(Icon, {
				name = v48.icon,
				variant = if not b2 then IconVariant.Regular else IconVariant.Filled
			})
		end
	}
	local t7 = {
		labelText = "CommonUI.Features.Label.More",
		actionType = nil,
		badgeCount = nil,
		page = AppPage.More,
		iconImage = Images["icons/menu/more_off"],
		iconCheckedImage = Images["icons/menu/more_on"]
	}
	local t8 = nil

	if FFlagAppNavMyStatsTab then
		local function v52(p3) -- line: 169
			-- upvalues: useTokens (ref), React (copy), u40 (ref), sendBuildExperienceEvent (copy), View (ref), Icon (ref), IconName (ref), IconSize (ref), IconVariant (ref)
			local v73 = useTokens()

			React.useEffect(function() -- line: 171
				-- upvalues: u40 (ref), sendBuildExperienceEvent (copy)
				if not u40 then
					u40 = true
					sendBuildExperienceEvent("TAB_IMPRESSION", {})
				end
			end, {})

			return React.createElement(View, {
				tag = "auto-xy padding-xxsmall"
			}, {
				Icon = React.createElement(Icon, {
					name = IconName.Nebula,
					size = IconSize.Large,
					variant = if not p3.isChecked then IconVariant.Regular else IconVariant.Filled,
					style = if not p3.isChecked then v73.Color.Content.Default else v73.Color.Content.Emphasis
				})
			})
		end

		t8 = {
			labelText = "CommonUI.Features.NavBar.Build",
			actionType = nil,
			badgeCount = nil,
			page = AppPage.MyStats,
			renderIcon = function(b3: boolean, _) -- line: 191
				-- upvalues: React (copy), v52 (copy)
				return React.createElement(v52, {
					isChecked = b3
				})
			end
		}
	end

	local t9 = nil

	if FFlagEnableLeftNavOnConsole then
		t9 = {
			labelText = "Feature.SocialTab.Label.Connect",
			badgeCount = nil,
			page = AppPage.ViewFriends,
			iconImage = Images["icons/menu/friends"],
			iconCheckedImage = Images["icons/menu/friendsOn"],
			actionType = Enum.AppShellActionType.TapChatTab
		}
	end

	local v54 = IsVRAppBuild()
	local v55 = GuiService:IsTenFootInterface()
	local v56 = false

	if FFlagEnableArgus and UniversalAppPolicy.getAppFeaturePolicies().getDisplayMomentsMoreTabTile() then
		v56 = require(CorePackages.Workspace.Packages.MomentsCommon.ArgusExperiment).getCurrentExperimentConfig().entryType == "tab" or FFlagEnableArgusTab
	end

	local v57

	if v54 then
		t5.isSecondary = true
		v57 = if not GetFFlagEnableVRChartsTab() then {
			t2,
			t6,
			t7,
			t5
		} else {
			t2,
			t3,
			t6,
			t7,
			t5
		}
	else
		v57 = if not FFlagEnableLeftNavOnConsole or not v55 then if not FFlagAppIaHomeSubTab or not FlyoutSidePanelIXP.isHomeSubTabEnabled() then if not FFlagMeTabRightOfPartyBottomNav then {
			t2,
			t3,
			t5,
			t6,
			t7
		} else {
			t2,
			t3,
			t6,
			t5,
			t7
		} else if not FFlagMeTabRightOfPartyBottomNav then {
			v46,
			t5,
			t6,
			t7
		} else {
			v46,
			t6,
			t5,
			t7
		} else {
			t2,
			t5,
			t9,
			t7
		}
	end

	if v56 and not v54 and (not FFlagEnableLeftNavOnConsole or not v55) then
		table.insert(v57, 2, t4)
	end

	if FFlagAppNavMyStatsTab and not v54 and not v55 then
		table.insert(v57, t8)
	end

	return v57
end

function getBottomBarItems() -- line: 261
	-- upvalues: FFlagEnableLeftNavOnConsole (copy), GuiService (copy), t1 (copy), v41 (copy)
	if not FFlagEnableLeftNavOnConsole and GuiService:IsTenFootInterface() then
		return t1
	end

	return (v41())
end

return function() -- line: 271
	-- upvalues: GuiService (copy), UniversalAppPolicy (copy), Cryo (copy), AppPage (copy), FFlagEnableFlyoutSidePanel (copy), FFlagEnableAndroidTvAppPolicies (copy), FFlagAppIaHomeSubTab (copy)
	local t10 = {}
	local v59 = getBottomBarItems()

	if not GuiService:IsTenFootInterface() then
		local getCanSeeChatTab = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTab

		if getCanSeeChatTab and not getCanSeeChatTab() then
			v59 = Cryo.List.filter(v59, function(p5) -- line: 279
				-- upvalues: AppPage (copy)
				return p5.page ~= AppPage.Chat
			end)
		end
	end

	if FFlagEnableFlyoutSidePanel then
		v59 = Cryo.List.filter(v59, function(p6) -- line: 286
			-- upvalues: AppPage (copy)
			return p6.page ~= AppPage.More
		end)
	end

	if FFlagEnableAndroidTvAppPolicies then
		local getHidesGamesTab = UniversalAppPolicy.getAppFeaturePolicies().getHidesGamesTab

		if getHidesGamesTab and getHidesGamesTab() then
			v59 = Cryo.List.filter(v59, function(p7) -- line: 294
				-- upvalues: AppPage (copy)
				return p7.page ~= AppPage.Games
			end)
		end
	end

	for i, v in ipairs(v59) do
		if FFlagAppIaHomeSubTab and v.subTabPages then
			for _, v2 in ipairs(v.subTabPages) do
				t10[v2] = i
			end
		else
			t10[v.page] = i
		end
	end

	return v59, t10
end
