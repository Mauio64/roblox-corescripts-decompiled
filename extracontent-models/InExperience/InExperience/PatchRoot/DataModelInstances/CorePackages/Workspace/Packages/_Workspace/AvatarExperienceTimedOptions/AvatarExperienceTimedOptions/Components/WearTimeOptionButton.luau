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

return (React.forwardRef(function(t1: {[any]: any}, _) -- line: 21
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
			["stroke-thick"] = t1.option.selected,
			["stroke-system-contrast"] = t1.option.selected,
			["stroke-emphasis"] = not t1.option.selected
		},
		onActivated = t1.onActivated,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 0, 0, if not FFlagAXDurables2Option then v12.Size.Size_1000 else v12.Size.Size_800),
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
			tag = "row align-y-center gap-xsmall auto-xy",
			LayoutOrder = 2
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
				Text = tostring(t1.option.price),
				selection = {
					Selectable = false
				}
			})
		})
	})
end))
