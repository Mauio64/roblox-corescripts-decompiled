local Parent = script:FindFirstAncestor("AvatarExperienceTimedOptions").Parent

require(Parent.AvatarExperienceCommon)

local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local React = require(Parent.React)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local FoundationText = Foundation.Text
local Enums = Foundation.Enums
local FFlagAXDurables2Option = AvatarExperienceFlags.FFlagAXDurables2Option

return (React.forwardRef(function(t1: {[any]: any}, _) -- line: 28
	-- upvalues: useTokens (copy), useLocalization (copy), FFlagAXDurables2Option (copy), React (copy), Foundation (copy), Enums (copy), FoundationText (copy)
	local v12 = useTokens()
	local v13 = useLocalization({
		infinite = "Feature.Durables.ItemDetails.WearTimeOptions.Button.Infinite",
		xDay = {
			"Feature.Durables.ItemDetails.WearTimeOptions.Button.XDay",
			num = t1.option.days
		},
		xDays = {
			"Feature.Durables.ItemDetails.WearTimeOptions.Button.XDays",
			num = t1.option.days
		},
		buy = if not FFlagAXDurables2Option then nil else "Feature.Catalog.Action.Buy",
		rent = if not FFlagAXDurables2Option then nil else "Feature.Catalog.Action.Rent"
	})
	local v14 = if t1.option.days ~= 0 then if t1.option.days ~= 1 then if not FFlagAXDurables2Option then v13.xDays else v13.rent else if not FFlagAXDurables2Option then v13.xDay else v13.rent else if not FFlagAXDurables2Option then v13.infinite else v13.buy

	return React.createElement(Foundation.View, {
		tag = {
			["row align-y-center gap-small padding-medium radius-medium stroke-standard"] = true,
			["align-x-center"] = if not FFlagAXDurables2Option then nil else t1.isFullWidth,
			["stroke-thick"] = t1.option.selected,
			["stroke-system-contrast"] = t1.option.selected,
			["stroke-emphasis"] = not t1.option.selected
		},
		onActivated = t1.onActivated,
		AutomaticSize = if not FFlagAXDurables2Option or not t1.isFullWidth then Enum.AutomaticSize.X else Enum.AutomaticSize.None,
		Size = if not FFlagAXDurables2Option or not t1.isFullWidth then UDim2.new(0, 0, 0, v12.Size.Size_1000) else UDim2.new(1, 0, 0, v12.Size.Size_800),
		stateLayer = {
			affordance = Enums.StateLayerAffordance.None
		},
		selection = {
			Selectable = true
		}
	}, {
		DaysLabel = React.createElement(FoundationText, {
			tag = "auto-xy text-title-small content-emphasis",
			LayoutOrder = 1,
			Text = v14,
			RichText = not not FFlagAXDurables2Option or nil,
			selection = {
				Selectable = false
			}
		}),
		PriceTag = React.createElement(Foundation.View, {
			LayoutOrder = 2,
			tag = not FFlagAXDurables2Option and "row align-y-center gap-xsmall auto-xy" or "row align-y-center gap-xxsmall auto-xy"
		}, {
			RobuxIcon = React.createElement(Foundation.Icon, {
				LayoutOrder = 1,
				name = Enums.IconName.Robux,
				variant = Enums.IconVariant.Filled,
				size = Enums.IconSize.XSmall
			}),
			PriceLabel = React.createElement(FoundationText, {
				tag = "auto-xy text-body-small",
				LayoutOrder = 2,
				Text = if not FFlagAXDurables2Option or (not t1.option.selected or not t1.option.priceInRobuxDiscountedByOffers) then tostring(t1.option.price) else tostring(t1.option.priceInRobuxDiscountedByOffers),
				selection = {
					Selectable = false
				}
			})
		}),
		OriginalPriceTag = if not FFlagAXDurables2Option or not t1.option.discountInformation then nil else React.createElement(Foundation.View, {
			tag = "auto-xy",
			LayoutOrder = 3
		}, {
			PriceContent = React.createElement(Foundation.View, {
				tag = "row align-y-center gap-xxsmall auto-xy"
			}, {
				RobuxIcon = React.createElement(Foundation.Icon, {
					LayoutOrder = 1,
					name = Enums.IconName.Robux,
					variant = Enums.IconVariant.Filled,
					size = Enums.IconSize.XSmall,
					style = v12.Color.Content.Muted
				}),
				PriceLabel = React.createElement(FoundationText, {
					tag = "auto-xy text-body-small content-muted",
					LayoutOrder = 2,
					Text = tostring(t1.option.discountInformation.originalPrice),
					selection = {
						Selectable = false
					}
				})
			}),
			Strikethrough = React.createElement(Foundation.View, {
				tag = "position-center-center anchor-center-center bg-system-neutral",
				Size = UDim2.new(1, 0, 0, 1)
			})
		})
	})
end))
