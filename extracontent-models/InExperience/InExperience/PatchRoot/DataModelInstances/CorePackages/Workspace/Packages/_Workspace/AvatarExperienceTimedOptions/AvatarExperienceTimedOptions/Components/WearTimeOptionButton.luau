local parent = script:FindFirstAncestor("AvatarExperienceTimedOptions").Parent

require(parent.AvatarExperienceCommon)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Text = Foundation.Text
local Enums = Foundation.Enums

local FFlagAXDurables2Option = AvatarExperienceFlags.FFlagAXDurables2Option

return (React.forwardRef(function(props, _)
	local v = useTokens()

	local v2 = useLocalization({
		infinite = "Feature.Durables.ItemDetails.WearTimeOptions.Button.Infinite",
		xDay = {
			"Feature.Durables.ItemDetails.WearTimeOptions.Button.XDay",
			num = props.option.days
		},
		xDays = {
			"Feature.Durables.ItemDetails.WearTimeOptions.Button.XDays",
			num = props.option.days
		},
		buy = FFlagAXDurables2Option and "Feature.Catalog.Action.Buy" or nil,
		rent = FFlagAXDurables2Option and "Feature.Catalog.Action.Rent" or nil
	})
	local text

	if props.option.days == 0 then
		text = if FFlagAXDurables2Option then v2.buy else v2.infinite
	elseif props.option.days == 1 then
		text = if FFlagAXDurables2Option then v2.rent else v2.xDay
	else
		text = if FFlagAXDurables2Option then v2.rent else v2.xDays
	end

	local createElement = React.createElement
	local view = Foundation.View
	local alignxcenter

	if FFlagAXDurables2Option then
		alignxcenter = props.isFullWidth
	end

	local v3 = {
		tag = {
			["row align-y-center gap-small padding-medium radius-medium stroke-standard"] = true,
			["align-x-center"] = alignxcenter,
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
	local automaticSize

	if FFlagAXDurables2Option and props.isFullWidth then
		automaticSize = Enum.AutomaticSize.None
	else
		automaticSize = Enum.AutomaticSize.X
	end

	v3.AutomaticSize = automaticSize
	local size

	if FFlagAXDurables2Option and props.isFullWidth then
		size = UDim2.new(1, 0, 0, v.Size.Size_800)
	else
		size = UDim2.new(0, 0, 0, v.Size.Size_1000)
	end

	v3.Size = size

	v3.stateLayer = { affordance = Enums.StateLayerAffordance.None }

	v3.selection = { Selectable = true }

	local v4 = {
		DaysLabel = React.createElement(Text, {
			tag = "auto-xy text-title-small content-emphasis",
			Text = text,
			RichText = FFlagAXDurables2Option and true or nil,
			LayoutOrder = 1,
			selection = { Selectable = false }
		}),
		PriceTag = 0,
		OriginalPriceTag = 0
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local v5 = {
		RobuxIcon = React.createElement(Foundation.Icon, {
			name = Enums.IconName.Robux,
			variant = Enums.IconVariant.Filled,
			size = Enums.IconSize.XSmall,
			LayoutOrder = 1
		}),
		PriceLabel = 0
	}

	local createElement3 = React.createElement
	local text2

	if FFlagAXDurables2Option and props.option.selected and props.option.priceInRobuxDiscountedByOffers then
		text2 = tostring(props.option.priceInRobuxDiscountedByOffers)
	else
		text2 = tostring(props.option.price)
	end

	v5.PriceLabel = createElement3(Text, {
		tag = "auto-xy text-body-small",
		Text = text2,
		LayoutOrder = 2,
		selection = { Selectable = false }
	})
	v4.PriceTag = createElement2(view2, {
		tag = FFlagAXDurables2Option and "row align-y-center gap-xxsmall auto-xy" or "row align-y-center gap-xsmall auto-xy",
		LayoutOrder = 2
	}, v5)
	local originalPriceTag

	if
		FFlagAXDurables2Option
		and (props.option.discountInformation or props.option.priceInRobuxDiscountedByOffers and props.option.selected and props.option.priceInRobuxDiscountedByOffers < props.option.price)
	then
		local createElement4 = React.createElement
		local view3 = Foundation.View

		local createElement5 = React.createElement
		local view4 = Foundation.View

		local v6 = {
			RobuxIcon = React.createElement(Foundation.Icon, {
				name = Enums.IconName.Robux,
				variant = Enums.IconVariant.Filled,
				size = Enums.IconSize.XSmall,
				style = v.Color.Content.Muted,
				LayoutOrder = 1
			}),
			PriceLabel = 0
		}

		local createElement6 = React.createElement
		local text3

		if props.option.discountInformation then
			text3 = tostring(props.option.discountInformation.originalPrice)
		else
			text3 = tostring(props.option.price)
		end

		v6.PriceLabel = createElement6(Text, {
			tag = "auto-xy text-body-small content-muted",
			Text = text3,
			LayoutOrder = 2,
			selection = { Selectable = false }
		})
		originalPriceTag = createElement4(view3, { tag = "auto-xy", LayoutOrder = 3 }, {
			PriceContent = createElement5(view4, { tag = "row align-y-center gap-xxsmall auto-xy" }, v6),
			Strikethrough = React.createElement(Foundation.View, {
				tag = "position-center-center anchor-center-center bg-system-neutral",
				Size = UDim2.new(1, 0, 0, 1)
			})
		})
	end

	v4.OriginalPriceTag = originalPriceTag
	return createElement(view, v3, v4)
end))
