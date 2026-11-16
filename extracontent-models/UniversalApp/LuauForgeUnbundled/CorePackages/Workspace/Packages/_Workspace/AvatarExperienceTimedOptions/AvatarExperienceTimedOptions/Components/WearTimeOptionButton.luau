require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/AvatarExperienceCommon")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/AvatarExperienceFlags")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/Localization").Hooks.useLocalization
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/Foundation")
local useTokens = Foundation.Hooks.useTokens
local text = Foundation.Text
local enums = Foundation.Enums

local fFlagAXDurables2Option = AvatarExperienceFlags.FFlagAXDurables2Option

return (React.forwardRef(function(props, p2)
	local v5 = useTokens()

	local v6 = useLocalization({
		infinite = "Feature.Durables.ItemDetails.WearTimeOptions.Button.Infinite",
		xDay = {
			"Feature.Durables.ItemDetails.WearTimeOptions.Button.XDay",
			num = props.option.days
		},
		xDays = {
			"Feature.Durables.ItemDetails.WearTimeOptions.Button.XDays",
			num = props.option.days
		},
		buy = fFlagAXDurables2Option and "Feature.Catalog.Action.Buy" or nil,
		rent = fFlagAXDurables2Option and "Feature.Catalog.Action.Rent" or nil
	})
	local v7

	if props.option.days == 0 then
		v7 = if fFlagAXDurables2Option then v6.buy else v6.infinite
	elseif props.option.days == 1 then
		v7 = if fFlagAXDurables2Option then v6.rent else v6.xDay
	else
		v7 = if fFlagAXDurables2Option then v6.rent else v6.xDays
	end

	local createElement = React.createElement
	local view = Foundation.View

	local v10 = if fFlagAXDurables2Option then props.isFullWidth else nil
	local v8 = {
		tag = {
			["row align-y-center gap-small padding-medium radius-medium stroke-standard"] = true,
			["align-x-center"] = v10,
			["stroke-thick"] = props.option.selected,
			["stroke-system-contrast"] = props.option.selected,
			["stroke-emphasis"] = not props.option.selected
		},
		onActivated = props.onActivated,
		AutomaticSize = 0,
		Size = 0,
		stateLayer = 0,
		selection = 0
	}
	local v11 = if fFlagAXDurables2Option and props.isFullWidth then Enum.AutomaticSize.None else Enum.AutomaticSize.X
	v8.AutomaticSize = v11

	local v12 = if fFlagAXDurables2Option and props.isFullWidth then UDim2.new(1, 0, 0, v5.Size.Size_800) else UDim2.new(0, 0, 0, v5.Size.Size_1000)
	v8.Size = v12

	v8.stateLayer = { affordance = enums.StateLayerAffordance.None }

	v8.selection = { Selectable = true }

	local v13 = {
		DaysLabel = React.createElement(text, {
			tag = "auto-xy text-title-small content-emphasis",
			Text = v7,
			RichText = fFlagAXDurables2Option and true or nil,
			LayoutOrder = 1,
			selection = { Selectable = false }
		}),
		PriceTag = 0,
		OriginalPriceTag = 0
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local v15 = {
		RobuxIcon = React.createElement(Foundation.Icon, {
			name = enums.IconName.Robux,
			variant = enums.IconVariant.Filled,
			size = enums.IconSize.XSmall,
			LayoutOrder = 1
		}),
		PriceLabel = 0
	}

	local createElement3 = React.createElement

	local v18 = if fFlagAXDurables2Option and props.option.selected and props.option.priceInRobuxDiscountedByOffers then tostring(props.option.priceInRobuxDiscountedByOffers) else tostring(props.option.price)
	v15.PriceLabel = createElement3(text, {
		tag = "auto-xy text-body-small",
		Text = v18,
		LayoutOrder = 2,
		selection = { Selectable = false }
	})
	v13.PriceTag = createElement2(view2, {
		tag = fFlagAXDurables2Option and "row align-y-center gap-xxsmall auto-xy" or "row align-y-center gap-xsmall auto-xy",
		LayoutOrder = 2
	}, v15)
	local v19

	if
		fFlagAXDurables2Option
		and (props.option.discountInformation or props.option.priceInRobuxDiscountedByOffers and props.option.selected and props.option.priceInRobuxDiscountedByOffers < props.option.price)
	then
		local createElement4 = React.createElement
		local view3 = Foundation.View

		local createElement5 = React.createElement
		local view4 = Foundation.View

		local v22 = {
			RobuxIcon = React.createElement(Foundation.Icon, {
				name = enums.IconName.Robux,
				variant = enums.IconVariant.Filled,
				size = enums.IconSize.XSmall,
				style = v5.Color.Content.Muted,
				LayoutOrder = 1
			}),
			PriceLabel = 0
		}

		local createElement6 = React.createElement

		local v25 = if props.option.discountInformation then tostring(props.option.discountInformation.originalPrice) else tostring(props.option.price)
		v22.PriceLabel = createElement6(text, {
			tag = "auto-xy text-body-small content-muted",
			Text = v25,
			LayoutOrder = 2,
			selection = { Selectable = false }
		})
		v19 = createElement4(view3, { tag = "auto-xy", LayoutOrder = 3 }, {
			PriceContent = createElement5(view4, {
				tag = "row align-y-center gap-xxsmall auto-xy"
			}, v22),
			Strikethrough = React.createElement(Foundation.View, {
				tag = "position-center-center anchor-center-center bg-system-neutral",
				Size = UDim2.new(1, 0, 0, 1)
			})
		})
	end

	v13.OriginalPriceTag = v19
	return createElement(view, v8, v13)
end))
