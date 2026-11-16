local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)

local useLocalization = Localization.Hooks.useLocalization

local FFlagAXShowMoreButtonOnOwnedItems = AvatarExperienceFlags.FFlagAXShowMoreButtonOnOwnedItems

local forwardRef = React.forwardRef(function(p, ref)
	local v = Foundation.Hooks.useTokens()
	local udim = UDim2.fromScale(1, 0)
	local udim2 = UDim2.fromScale(0, 1)

	local v2 = useLocalization({
		manageInCustomize = "Feature.Catalog.Action.Checkout.ManageInCustomize"
	})

	local createElement = React.createElement
	local view = Foundation.View
	local v3 = {
		tag = {
			["row items-center gap-medium anchor-bottom-left size-full-0 auto-y padding-x-xlarge padding-y-large bg-surface-0"] = FFlagAXShowMoreButtonOnOwnedItems,
			["row items-center auto-y size-full-0 padding-y-large padding-x-xlarge bg-surface-0 anchor-bottom-left"] = not FFlagAXShowMoreButtonOnOwnedItems
		},
		ref = ref,
		backgroundStyle = {
			Color3 = v.Color.Surface.Surface_0.Color3,
			Transparency = v.Color.Surface.Surface_0.Transparency
		},
		Size = udim,
		Position = udim2,
		ZIndex = 3
	}

	local v4 = {
		ActionButton = React.createElement(Foundation.Button, {
			text = v2.manageInCustomize,
			onActivated = p.onActivated,
			variant = Foundation.Enums.ButtonVariant.Standard,
			size = Foundation.Enums.ButtonSize.Medium,
			fillBehavior = Foundation.Enums.FillBehavior.Fill,
			LayoutOrder = FFlagAXShowMoreButtonOnOwnedItems and 1 or nil
		}),
		MoreButton = 0
	}
	local moreButton

	if FFlagAXShowMoreButtonOnOwnedItems and p.onMoreButtonActivated then
		moreButton = React.createElement(Foundation.Button, {
			icon = "circle-three-dots-horizontal",
			onActivated = p.onMoreButtonActivated,
			variant = Foundation.Enums.ButtonVariant.Standard,
			size = Foundation.Enums.ButtonSize.Medium,
			LayoutOrder = 2
		})
	end

	v4.MoreButton = moreButton
	return createElement(view, v3, v4)
end)

return React.memo(forwardRef)
