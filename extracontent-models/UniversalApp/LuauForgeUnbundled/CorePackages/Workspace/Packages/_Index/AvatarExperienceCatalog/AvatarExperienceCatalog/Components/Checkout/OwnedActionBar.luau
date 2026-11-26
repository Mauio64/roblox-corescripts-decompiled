local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Localization")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags")

local useLocalization = Localization.Hooks.useLocalization

local fFlagAXShowMoreButtonOnOwnedItems = AvatarExperienceFlags.FFlagAXShowMoreButtonOnOwnedItems

local forwardRef = React.forwardRef(function(p2, p3)
	local v5 = Foundation.Hooks.useTokens()
	local udim = UDim2.fromScale(1, 0)
	local udim2 = UDim2.fromScale(0, 1)

	local v6 = useLocalization({
		manageInCustomize = "Feature.Catalog.Action.Checkout.ManageInCustomize"
	})

	local createElement = React.createElement
	local view = Foundation.View
	local v7 = {
		tag = {
			["row items-center gap-medium anchor-bottom-left size-full-0 auto-y padding-x-xlarge padding-y-large bg-surface-0"] = fFlagAXShowMoreButtonOnOwnedItems,
			["row items-center auto-y size-full-0 padding-y-large padding-x-xlarge bg-surface-0 anchor-bottom-left"] = not fFlagAXShowMoreButtonOnOwnedItems
		},
		ref = p3,
		backgroundStyle = {
			Color3 = v5.Color.Surface.Surface_0.Color3,
			Transparency = v5.Color.Surface.Surface_0.Transparency
		},
		Size = udim,
		Position = udim2,
		ZIndex = 3
	}

	local v8 = {
		ActionButton = React.createElement(Foundation.Button, {
			text = v6.manageInCustomize,
			onActivated = p2.onActivated,
			variant = Foundation.Enums.ButtonVariant.Standard,
			size = Foundation.Enums.ButtonSize.Medium,
			fillBehavior = Foundation.Enums.FillBehavior.Fill,
			LayoutOrder = fFlagAXShowMoreButtonOnOwnedItems and 1 or nil
		}),
		MoreButton = 0
	}

	local v9 = if fFlagAXShowMoreButtonOnOwnedItems and p2.onMoreButtonActivated then React.createElement(Foundation.Button, {
		icon = "circle-three-dots-horizontal",
		onActivated = p2.onMoreButtonActivated,
		variant = Foundation.Enums.ButtonVariant.Standard,
		size = Foundation.Enums.ButtonSize.Medium,
		LayoutOrder = 2
	}) else nil
	v8.MoreButton = v9
	return createElement(view, v7, v8)
end)

return React.memo(forwardRef)
