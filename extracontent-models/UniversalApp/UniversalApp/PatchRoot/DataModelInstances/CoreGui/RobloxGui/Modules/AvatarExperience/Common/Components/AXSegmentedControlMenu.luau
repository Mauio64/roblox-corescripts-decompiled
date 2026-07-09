local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local View = Foundation.View
local SegmentedControl = Foundation.SegmentedControl
local InputSize = Foundation.Enums.InputSize
local BuilderIcons = require(CorePackages.Packages.BuilderIcons)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local Analytics2 = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local FFlagAXEnableProfileTab = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXEnableProfileTab
local t1 = {
	Catalog = AvatarScreen.Catalog,
	Customize = AvatarScreen.AvatarEditor,
	Profile = AvatarScreen.Profile
}
local ShoppingBasket = BuilderIcons.Icon.ShoppingBasket
local Backpack = BuilderIcons.Icon.Backpack
local CirclePerson = BuilderIcons.Icon.CirclePerson

local function AXSegmentedControlMenu(t2: {[any]: any}) -- line: 60
	-- upvalues: useRoactService (copy), Analytics (copy), Analytics2 (copy), useNavigation (copy), useAvatarRoute (copy), FormFactor (copy), useLocalization (copy), React (copy), ShoppingBasket (copy), Backpack (copy), FFlagAXEnableProfileTab (copy), CirclePerson (copy), AvatarScreen (copy), t1 (copy), View (copy), SegmentedControl (copy), InputSize (copy)
	local v25 = useRoactService(Analytics)
	local v26 = useRoactService(Analytics2)
	local v27 = useNavigation()
	local name = useAvatarRoute().opaque.name
	local v29 = t2.formFactor == FormFactor.WIDE
	local v30 = useLocalization({
		shopText = "Feature.Avatar.Action.Marketplace",
		customizeText = "Feature.Catalog.Action.Customize",
		profileText = "CommonUI.Features.Label.Profile"
	})
	local v31 = React.useMemo(function() -- line: 75
		-- upvalues: v29 (copy), v30 (copy), ShoppingBasket (copy), Backpack (copy), FFlagAXEnableProfileTab (copy), CirclePerson (copy)
		local v34 = if not v29 then {
			{
				id = "Catalog",
				icon = ShoppingBasket
			},
			{
				id = "Customize",
				icon = Backpack
			}
		} else {
			{
				id = "Catalog",
				text = v30.shopText
			},
			{
				id = "Customize",
				text = v30.customizeText
			}
		}

		if FFlagAXEnableProfileTab then
			table.insert(v34, if not v29 then {
				id = "Profile",
				icon = CirclePerson
			} else {
				id = "Profile",
				text = v30.profileText
			})
		end

		return v34
	end, {
		v29,
		v30.shopText,
		v30.customizeText,
		v30.profileText
	})
	local v32 = if name ~= AvatarScreen.Catalog then name ~= AvatarScreen.Profile and "Customize" or "Profile" else "Catalog"
	local v33 = React.useCallback(function(p1) -- line: 101
		-- upvalues: t1 (copy), name (copy), v27 (copy), AvatarScreen (copy), v25 (copy), v26 (copy)
		local v36 = t1[tostring(p1)]

		if not v36 or v36 == name then
			return
		end

		v27.navigate(v36)

		if v36 == AvatarScreen.Catalog then
			v25.avatarToCatalogButton()

			return
		end

		if v36 == AvatarScreen.AvatarEditor then
			v26.catalogToAvatarButton()
		end
	end, {
		v27,
		v25,
		v26,
		name
	})

	return React.createElement(View, {
		tag = "size-full",
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}
	}, {
		SegmentedControl = React.createElement(SegmentedControl, {
			isCircular = true,
			size = InputSize.Medium,
			segments = v31,
			value = v32,
			onActivated = v33
		})
	})
end

return AXSegmentedControlMenu
