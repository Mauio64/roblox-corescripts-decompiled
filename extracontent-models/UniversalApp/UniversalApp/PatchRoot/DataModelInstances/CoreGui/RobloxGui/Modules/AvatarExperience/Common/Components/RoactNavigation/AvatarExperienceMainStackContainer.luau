local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local SetTabBarVisible = require(CorePackages.Workspace.Packages.AppTabBarRodux).Actions.SetTabBarVisible
local AppNavBar = require(CorePackages.Workspace.Packages.AppNavBar)
local useNavBarPlacement = AppNavBar.useNavBarPlacement
local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)
local AvatarExperienceMainStackNavigator = require(Modules.AvatarExperience.Common.Components.RoactNavigation.AvatarExperienceMainStackNavigator)
local getActiveChildNavigationOptionsSafely = require(Modules.AvatarExperience.Common.Components.RoactNavigation.getActiveChildNavigationOptionsSafely)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local FullView = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.FullView
local FFlagEnableBottomNavOnMarketplace = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableBottomNavOnMarketplace
local FFlagStackedBottomNavMarketplaceCTA = require(CorePackages.Workspace.Packages.SharedFlags).FFlagStackedBottomNavMarketplaceCTA
local v16 = Roact.Component:extend("AvatarExperienceMainStackContainer")

function v16.didMount(p1) -- line: 39
	p1:setTabBarVisibility(p1.props)
end
function v16.willUpdate(p2, p3) -- line: 43
	p2:setTabBarVisibility(p3)
end
function v16.setTabBarVisibility(_, p5) -- line: 47
	-- upvalues: getActiveChildNavigationOptionsSafely (copy), FFlagEnableBottomNavOnMarketplace (copy), FFlagStackedBottomNavMarketplaceCTA (copy), FullView (copy)
	if not p5.avatarRoute.isVisible then
		return
	end

	local navigation = p5.navigation
	local v28 = getActiveChildNavigationOptionsSafely(navigation)
	local v29 = if v28.tabBarVisible == nil then p5.defaultTabBarVisible else v28.tabBarVisible == true

	if FFlagEnableBottomNavOnMarketplace and not FFlagStackedBottomNavMarketplaceCTA and v29 and p5.hasTryOnItems and (not p5.fullViewTable or p5.fullViewTable[p5.avatarRoute.opaque.name] ~= FullView.SceneFullView) then
		v29 = false
	end

	if v29 ~= p5.tabBarVisible then
		p5.setTabBarVisible(v29)
	end
end
function v16.render(p6) -- line: 76
	-- upvalues: Roact (copy), AvatarExperienceMainStackNavigator (copy)
	local navigation = p6.props.navigation

	return Roact.createElement(AvatarExperienceMainStackNavigator, {
		navigation = navigation
	})
end

local v17 = v16

local function mapStateToProps(p7) -- line: 95
	-- upvalues: FFlagEnableBottomNavOnMarketplace (copy), FFlagStackedBottomNavMarketplaceCTA (copy)
	return {
		tabBarVisible = p7.TabBarVisible,
		hasTryOnItems = if not FFlagEnableBottomNavOnMarketplace or FFlagStackedBottomNavMarketplaceCTA then nil else next(p7.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems) ~= nil,
		fullViewTable = if not FFlagEnableBottomNavOnMarketplace or FFlagStackedBottomNavMarketplaceCTA then nil else p7.AvatarExperience.Common.FullView
	}
end
local function mapDispatchToProps(p8) -- line: 107
	-- upvalues: SetTabBarVisible (copy)
	return {
		setTabBarVisible = function(p9) -- line: 109
			-- upvalues: p8 (copy), SetTabBarVisible (copy)
			p8(SetTabBarVisible(p9))
		end
	}
end

local v20 = withAvatarRoute(function(p10) -- line: 85
	-- upvalues: useNavBarPlacement (copy), AppNavBar (copy), Cryo (copy), Roact (copy), v17 (copy)
	local v33 = useNavBarPlacement() == AppNavBar.Placement.Left
	local v34 = Cryo.Dictionary.join(p10, {
		defaultTabBarVisible = v33
	})

	return Roact.createElement(v17, v34)
end)
local v21 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v20)

v21.router = AvatarExperienceMainStackNavigator.router

return v21
