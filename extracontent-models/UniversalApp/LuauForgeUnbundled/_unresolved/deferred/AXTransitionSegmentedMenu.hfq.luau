local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local UIBlox = require(CorePackages.Packages.UIBlox)
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor

local module2 = require("@luauforge/bundled/eie")
local module3 = require("@luauforge/bundled/fDf")
local module4 = require("@luauforge/bundled/gJz")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXEnableFoundationSegmentedMenu = AvatarExperienceFlags.FFlagAXEnableFoundationSegmentedMenu
local fFlagAXUseProfileIconEntryPoint = AvatarExperienceFlags.FFlagAXUseProfileIconEntryPoint

local v5 = if fFlagAXEnableFoundationSegmentedMenu then require("@luauforge/deferred/hfr") else nil

local segmentedControl = UIBlox.App.Control.SegmentedControl

local function TwoTabSegmentedMenu(p2)
	local state, setState = React.useState(234)
	local v6 = module2(module3)
	local v7 = module2(module4)
	local v8 = useNavigation()
	local name = useAvatarRoute().opaque.name
	local v9 = name == avatarScreen.Catalog and 1 or 2
	local v10 = p2.formFactor ~= formFactor.WIDE and 234 or nil

	local v11 = useLocalization({
		shopText = "Feature.Avatar.Action.Marketplace",
		customizeText = "Feature.Catalog.Action.Customize"
	})

	local v12 = {
		{ tabName = v11.shopText },
		{ tabName = v11.customizeText }
	}

	local v13 = React.useCallback(function(p3)
		setState(p3.AbsoluteSize.X >= 234 and 234 or 224)
	end, {})

	local v14 = React.useCallback(function(p3)
		if p3 == 1 and name ~= avatarScreen.Catalog then
			v8.navigate(avatarScreen.Catalog)
			v6.avatarToCatalogButton()
		elseif p3 == 2 and name ~= avatarScreen.AvatarEditor then
			v8.navigate(avatarScreen.AvatarEditor)
			v7.catalogToAvatarButton()
		end
	end, { v8, v6, v7, name })

	return React.createElement(
		RoactGamepad.Focusable.Frame,
		{
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			[React.Change.AbsoluteSize] = v13
		},
		{
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			SegmentedControl = React.createElement(segmentedControl, {
				width = UDim.new(0, state),
				maxWidth = v10,
				selectedTabIndex = v9,
				onTabActivated = v14,
				tabs = v12
			})
		}
	)
end

local function AXTransitionSegmentedMenu(p2)
	local v6 = if fFlagAXUseProfileIconEntryPoint then useAvatarRoute().opaque.name else nil

	if fFlagAXUseProfileIconEntryPoint and v6 == avatarScreen.Profile then
		return nil
	end

	if fFlagAXEnableFoundationSegmentedMenu then
		return React.createElement(v5, p2)
	end

	return React.createElement(TwoTabSegmentedMenu, p2)
end

return AXTransitionSegmentedMenu
