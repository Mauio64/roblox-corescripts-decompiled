local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local setTabBarVisible = require("@luauforge/bundled/dwN").Actions.SetTabBarVisible
local module = require("@luauforge/bundled/dHu")
local useNavBarPlacement = module.useNavBarPlacement

local module2 = require("@luauforge/bundled/fsK")
local module3 = require("@luauforge/bundled/goD")

local module4 = require("@luauforge/deferred/gOp")

local module5 = require("@luauforge/deferred/gOh")
require("@luauforge/bundled/dHK")
local fullView = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Enums.FullView

local avatarScreenProperties = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.AvatarScreenProperties

local fFlagEnableBottomNavOnMarketplace = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableBottomNavOnMarketplace

local fFlagStackedBottomNavMarketplaceCTA = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagStackedBottomNavMarketplaceCTA
local defineFastFlag = game:DefineFastFlag("AXDisableTabBarOverrideForNonAXPages", false)

local fFlagAXFixTabBarOverrideForWrapperPages = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXFixTabBarOverrideForWrapperPages
local defineFastFlag2 = game:DefineFastFlag("AXHideBottomNavForOverlayPrompts", false)

local fFlagAXHideBottomNavForEditProfileImage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXHideBottomNavForEditProfileImage

local getActiveAvatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.getActiveAvatarScreen

local function getNavigatorActiveScreenName(p2)
	local state = p2 and p2.state
	local routes = state and state.routes
	local activeAvatarScreen = getActiveAvatarScreen(routes and state.index and routes[state.index])
	return activeAvatarScreen and activeAvatarScreen.routeName
end

local extended = Roact.Component:extend("AvatarExperienceMainStackContainer")

function extended:didMount()
	self:setTabBarVisibility(self.props)
end

function extended:willUpdate(p2)
	self:setTabBarVisibility(p2)
end

function extended:setTabBarVisibility(data)
	if not data.avatarRoute.isVisible then
		return
	end

	if fFlagAXFixTabBarOverrideForWrapperPages then
		local name = data.avatarRoute.current and data.avatarRoute.current.name

		if name then
			local navigation = data.navigation
			local state = navigation and navigation.state
			local routes = state and state.routes
			local activeAvatarScreen = getActiveAvatarScreen(routes and state.index and routes[state.index])

			if name ~= (activeAvatarScreen and activeAvatarScreen.routeName) then
				return
			end
		end
	elseif defineFastFlag then
		local name = data.avatarRoute.current and data.avatarRoute.current.name

		if name and not avatarScreenProperties[name] then
			return
		end
	end

	local v5 = module5(data.navigation)

	local defaultTabBarVisible = fFlagAXHideBottomNavForEditProfileImage and data.defaultTabBarVisible
	local v6

	if defineFastFlag2 and data.avatarRoute.isOverlayVisible and not data.defaultTabBarVisible then
		v6 = false
	elseif v5.tabBarVisible == nil or defaultTabBarVisible then
		v6 = data.defaultTabBarVisible
	else
		v6 = v5.tabBarVisible == true
	end

	if
		fFlagEnableBottomNavOnMarketplace
		and not fFlagStackedBottomNavMarketplaceCTA
		and v6
		and data.hasTryOnItems
		and (not data.fullViewTable or data.fullViewTable[data.avatarRoute.opaque.name] ~= fullView.SceneFullView)
	then
		v6 = false
	end

	if v6 ~= data.tabBarVisible then
		data.setTabBarVisible(v6)
	end
end

function extended.render(p2)
	local navigation = p2.props.navigation

	return Roact.createElement(module4, { navigation = navigation })
end

local function fn(p2)
	local v5 = useNavBarPlacement() == module.Placement.Left
	local joined = Cryo.Dictionary.join(p2, { defaultTabBarVisible = v5 })

	return Roact.createElement(extended, joined)
end

local function mapStateToProps(p2)
	local v5 = {
		tabBarVisible = p2.TabBarVisible,
		hasTryOnItems = 0,
		fullViewTable = 0
	}

	local v6 = if fFlagEnableBottomNavOnMarketplace and not fFlagStackedBottomNavMarketplaceCTA then next(p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems) ~= nil else nil
	v5.hasTryOnItems = v6

	local v7 = if fFlagEnableBottomNavOnMarketplace and not fFlagStackedBottomNavMarketplaceCTA then p2.AvatarExperience.Common.FullView else nil
	v5.fullViewTable = v7
	return v5
end

local function mapDispatchToProps(callback)
	return {
		setTabBarVisible = function(p2)
			callback(setTabBarVisible(p2))
		end
	}
end

local v5 = if defineFastFlag then module3(fn) else module2(fn)

local v6 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v5)
v6.router = module4.router

return v6
