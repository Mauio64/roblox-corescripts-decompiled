local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local UIBlox = require(CorePackages.Packages.UIBlox)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local Analytics2 = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local FFlagAXEnableFoundationSegmentedMenu = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXEnableFoundationSegmentedMenu
local v16 = if not FFlagAXEnableFoundationSegmentedMenu then nil else require(Modules.AvatarExperience.Common.Components.AXSegmentedControlMenu)
local SegmentedControl = UIBlox.App.Control.SegmentedControl

local function TwoTabSegmentedMenu(t1: {[any]: any}) -- line: 43
	-- upvalues: React (copy), useRoactService (copy), Analytics (copy), Analytics2 (copy), useNavigation (copy), useAvatarRoute (copy), AvatarScreen (copy), FormFactor (copy), useLocalization (copy), RoactGamepad (copy), SegmentedControl (copy)
	local v21, v22 = React.useState(234)
	local v23 = useRoactService(Analytics)
	local v24 = useRoactService(Analytics2)
	local v25 = useNavigation()
	local name = useAvatarRoute().opaque.name
	local v27 = name ~= AvatarScreen.Catalog and 2 or 1
	local v28 = if t1.formFactor == FormFactor.WIDE then nil else 234
	local v29 = useLocalization({
		shopText = "Feature.Avatar.Action.Marketplace",
		customizeText = "Feature.Catalog.Action.Customize"
	})
	local t2 = {
		{
			tabName = v29.shopText
		},
		{
			tabName = v29.customizeText
		}
	}
	local v31 = React.useCallback(function(p1) -- line: 64
		-- upvalues: v22 (copy)
		v22(not (p1.AbsoluteSize.X >= 234) and 224 or 234)
	end, {})
	local v32 = React.useCallback(function(p2) -- line: 68
		-- upvalues: name (copy), AvatarScreen (copy), v25 (copy), v23 (copy), v24 (copy)
		if p2 == 1 and name ~= AvatarScreen.Catalog then
			v25.navigate(AvatarScreen.Catalog)
			v23.avatarToCatalogButton()

			return
		end

		if p2 == 2 and name ~= AvatarScreen.AvatarEditor then
			v25.navigate(AvatarScreen.AvatarEditor)
			v24.catalogToAvatarButton()
		end
	end, {
		v25,
		v23,
		v24,
		name
	})

	return React.createElement(RoactGamepad.Focusable.Frame, {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		[React.Change.AbsoluteSize] = v31
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		SegmentedControl = React.createElement(SegmentedControl, {
			width = UDim.new(0, v21),
			maxWidth = v28,
			selectedTabIndex = v27,
			onTabActivated = v32,
			tabs = t2
		})
	})
end
local function AXTransitionSegmentedMenu(t3: {[any]: any}) -- line: 101
	-- upvalues: FFlagAXEnableFoundationSegmentedMenu (copy), React (copy), v16 (copy), TwoTabSegmentedMenu (copy)
	if FFlagAXEnableFoundationSegmentedMenu then
		return React.createElement(v16, t3)
	end

	return React.createElement(TwoTabSegmentedMenu, t3)
end

return AXTransitionSegmentedMenu
