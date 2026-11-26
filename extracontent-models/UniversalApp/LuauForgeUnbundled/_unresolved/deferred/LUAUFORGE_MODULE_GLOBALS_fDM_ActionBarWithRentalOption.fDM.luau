local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local view = Foundation.View
local text = Foundation.Text
local iconButton = Foundation.IconButton
local useTokens = Foundation.Hooks.useTokens
local getIconRichText = Foundation.Utility.getIconRichText
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
require("@luauforge/bundled/dPs")

require("@luauforge/deferred/fDe")
local useTimedOptionsFtux = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Hooks.useTimedOptionsFtux

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local module = require("@luauforge/bundled/dXA")

function LUAUFORGE_MODULE_GLOBALS_fDM_ActionBarWithRentalOption(props)
	local v5 = useTokens()
	local v6 = useLocalization({
		buy = "Feature.Catalog.Action.Buy",
		rent = "Feature.Catalog.Action.Rent",
		rentalFtuxText = "Feature.Catalog.Title.RentalFtuxText"
	})

	local v7 = useSignalState(module.GetDisplayStore().getDeviceSafePadding)

	local price = nil
	local price2 = nil

	if props.timedOptions then
		for k, timedOption in props.timedOptions do
			if timedOption.days == 3 then
				price = timedOption.price
			elseif timedOption.days == 0 then
				price2 = timedOption.price
			end
		end
	end

	local v8 = useTimedOptionsFtux()

	local state, setState = React.useState(v8.shouldShow2OptionToolTipOnBuyActionBar())

	local createElement = React.createElement
	local v10 = { tag = "size-full-0", Size = UDim2.fromScale(1, 1) }
	local v12

	if state then
		v12 = React.createElement(view, {
			tag = "row align-y-center gap-medium size-full-0 auto-y padding-x-xlarge padding-y-small bg-surface-300",
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, -v5.Size.Size_1800)
		}, {
			Description = React.createElement(text, {
				tag = "fill auto-y text-body-large text-align-x-left text-truncate-end content-emphasis",
				Text = v6.rentalFtuxText,
				LayoutOrder = 1
			}),
			DismissButton = React.createElement(iconButton, {
				icon = "icons/navigation/close",
				size = iconSize.Small,
				onActivated = function()
					v8.hide2OptionToolTipOnBuyActionBar()
					setState(false)
				end,
				LayoutOrder = 2
			})
		})
	end

	local createElement2 = React.createElement
	local v14 = {
		tag = "row padding-x-xlarge padding-top-large bg-surface-0 gap-medium",
		Size = UDim2.new(1, v7.right, 0, v5.Size.Size_1800 + v7.bottom),
		Position = UDim2.new(0, 0, 1, -v5.Size.Size_1800),
		padding = { right = UDim.new(0, v7.right), bottom = UDim.new(0, v7.bottom) }
	}

	local v15 = {
		BuyButton = React.createElement(
			view,
			{
				tag = "col fill radius-medium bg-action-emphasis align-x-center align-y-center",
				Size = UDim2.new(1, 0, 0, v5.Size.Size_1000),
				LayoutOrder = 1,
				onActivated = props.buttonProps.onActivated
			},
			{
				Label = React.createElement(text, {
					tag = "text-title-large content-action-emphasis auto-xy",
					Text = `{v6.buy} {getIconRichText(iconName.Robux)} {price2 or ""}`,
					RichText = true
				})
			}
		),
		RentalButton = React.createElement(
			view,
			{
				tag = "col fill radius-medium bg-action-standard align-x-center align-y-center",
				Size = UDim2.new(1, 0, 0, v5.Size.Size_1000),
				LayoutOrder = 2,
				onActivated = props.rentalButtonProps.onActivated
			},
			{
				Label = React.createElement(text, {
					tag = "text-title-large content-default auto-xy",
					Text = `{v6.rent} {getIconRichText(iconName.Robux)} {price or ""}`,
					RichText = true
				})
			}
		),
		MoreButton = 0
	}

	local v16 = if props.onMoreButtonActivated then React.createElement(Foundation.Button, {
		icon = "circle-three-dots-horizontal",
		onActivated = props.onMoreButtonActivated,
		variant = Foundation.Enums.ButtonVariant.Standard,
		size = Foundation.Enums.ButtonSize.Medium,
		LayoutOrder = 3
	}) else nil
	v15.MoreButton = v16
	return createElement(view, v10, {
		Tooltip2OptionBanner = v12,
		ActionBarFrame = createElement2(view, v14, v15)
	})
end

return LUAUFORGE_MODULE_GLOBALS_fDM_ActionBarWithRentalOption
