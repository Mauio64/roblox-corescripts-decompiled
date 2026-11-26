local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local view = Foundation.View
local segmentedControl = Foundation.SegmentedControl
local inputSize = Foundation.Enums.InputSize
local BuilderIcons = require(CorePackages.Packages.BuilderIcons)
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor

local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local module2 = require("@luauforge/bundled/fDf")
local module3 = require("@luauforge/bundled/gJz")

local fFlagAXEnableProfileTab = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXEnableProfileTab

local fFlagAXUseProfileIconEntryPoint = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUseProfileIconEntryPoint

local v5 = {
	["Catalog"] = avatarScreen.Catalog,
	Customize = avatarScreen.AvatarEditor,
	Profile = avatarScreen.Profile
}

local shoppingBasket = BuilderIcons.Icon.ShoppingBasket
local backpack = BuilderIcons.Icon.Backpack
local circlePerson = BuilderIcons.Icon.CirclePerson

local function AXSegmentedControlMenu(p2)
	local v6 = useRoactService(module2)
	local v7 = useRoactService(module3)
	local v8 = useNavigation()
	local name = useAvatarRoute().opaque.name
	local v9 = p2.formFactor == formFactor.WIDE

	local v10 = useLocalization({
		shopText = "Feature.Avatar.Action.Marketplace",
		customizeText = "Feature.Catalog.Action.Customize",
		profileText = "CommonUI.Features.Label.Profile"
	})

	local v11 = React.useMemo(function()
		local v12

		if v9 or fFlagAXUseProfileIconEntryPoint then
			v12 = {
				{ id = "Catalog", text = v10.shopText },
				{ id = "Customize", text = v10.customizeText }
			}
		else
			v12 = {
				{ id = "Catalog", icon = shoppingBasket },
				{ id = "Customize", icon = backpack }
			}
		end

		if fFlagAXEnableProfileTab and not fFlagAXUseProfileIconEntryPoint then
			local v13 = if v9 then { id = "Profile", text = v10.profileText } else {
				id = "Profile",
				icon = circlePerson
			}
			table.insert(v12, v13)
		end

		return v12
	end, { v9, v10.shopText, v10.customizeText, v10.profileText })

	local v12 = name == avatarScreen.Catalog and "Catalog"
		or name == avatarScreen.Profile and "Profile"
		or "Customize"

	local v13 = React.useCallback(function(p3)
		local v14 = v5[tostring(p3)]

		if not v14 or v14 == name then
			return
		end

		v8.navigate(v14)

		if v14 == avatarScreen.Catalog then
			v6.avatarToCatalogButton()
		elseif v14 == avatarScreen.AvatarEditor then
			v7.catalogToAvatarButton()
		end
	end, { v8, v6, v7, name })

	return React.createElement(view, {
		tag = "size-full",
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}
	}, {
		SegmentedControl = React.createElement(segmentedControl, {
			size = inputSize.Medium,
			segments = v11,
			value = v12,
			onActivated = v13,
			isCircular = true
		})
	})
end

return AXSegmentedControlMenu
