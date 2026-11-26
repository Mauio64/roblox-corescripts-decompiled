local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local numberLocalization = require("@game/CorePackages/Workspace/Packages/Localization").NumberLocalization
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local itemTile = UIBlox.Tile.ItemTile
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle

local module = require("@luauforge/bundled/dVl")
local module2 = require("@luauforge/bundled/dPU")
local module3 = require("@luauforge/bundled/gxM")
local module4 = require("@luauforge/bundled/eie")
local module5 = require("@luauforge/bundled/egY")
local getRbxthumbWithTypeSizeAndOptions = require("@luauforge/bundled/ciE").Utils.getRbxthumbWithTypeSizeAndOptions
local module6 = require("@luauforge/deferred/gOY")
local fFlagAXThumbTypeNilCheck = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXThumbTypeNilCheck
require("@luauforge/bundled/dPs")

return (React.forwardRef(function(props, ref)
	local itemType = props.itemType
	local rbxThumbType = module.GetRbxThumbType(itemType)

	if fFlagAXThumbTypeNilCheck and rbxThumbType then
	end

	local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(
		props.itemId,
		rbxThumbType,
		150
	)

	local v5 = module3({
		holdingLabel = "Feature.Catalog.Label.Holding",
		offSaleLabel = "Feature.Catalog.Heading.TakeOffSale",
		sellAction = "Feature.Catalog.Action.Sell",
		buyPriceLabel = "Feature.Catalog.Label.BuyPrice",
		salePriceLabel = "Feature.Catalog.Label.SalePrice"
	})

	local v6 = useStyle()

	local v7 = module4(module5)
	local v8 = props.buyPrice and string.format("%.0f", props.buyPrice)
	local v9 = v8 and numberLocalization.localize(v8, v7:GetLocale())
	local v10 = props.salePrice and string.format("%.0f", props.salePrice)
	local v11 = v10 and numberLocalization.localize(v10, v7:GetLocale())
	local v12

	if props.isOnHold then
		v12 = v5.holdingLabel
	else
		v12 = if props.isOnSale then v5.offSaleLabel else v5.sellAction
	end

	local createElement = React.createElement
	local v14 = {
		Size = UDim2.new(1, 0, 0, 100),
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder
	}
	local v15 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8)
		}),
		ItemTileContainer = React.createElement(
			"Frame",
			{
				Size = UDim2.fromOffset(100, 100),
				BackgroundTransparency = 1,
				LayoutOrder = 1
			},
			{
				ItemTile = React.createElement(itemTile, {
					thumbnail = rbxthumbWithTypeSizeAndOptions,
					name = "",
					restrictionTypes = props.restrictionTypes
				})
			}
		),
		DetailsContainer = 0
	}

	local createElement2 = React.createElement
	local v17 = {
		Size = UDim2.new(1, -108, 1, 0),
		BackgroundTransparency = 1,
		LayoutOrder = 2
	}

	local v18 = {
		LabelsContainer = React.createElement(
			"Frame",
			{ Size = UDim2.fromScale(1, 0), BackgroundTransparency = 1 },
			{
				Layout = React.createElement("UIListLayout", {
					Padding = UDim.new(0, 4),
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				ItemTitleLabel = React.createElement("TextLabel", {
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.fromScale(1, 0),
					Text = props.title,
					FontFace = normalizeFontFace(v6.Tokens.Typography.TitleLarge.Font),
					TextSize = v6.Font.BaseSize * v6.Font.Header2.RelativeSize,
					TextColor3 = v6.Theme.TextEmphasis.Color,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundTransparency = 1,
					LayoutOrder = 1
				}),
				BuyPriceLabel = v9 and React.createElement("TextLabel", {
					AutomaticSize = Enum.AutomaticSize.XY,
					Text = v5.buyPriceLabel .. " " .. module2.RobloxEmoji.Robux .. v9,
					FontFace = normalizeFontFace(v6.Tokens.Typography.BodyLarge.Font),
					TextSize = v6.Font.BaseSize * v6.Font.Body.RelativeSize,
					TextColor3 = v6.Theme.TextEmphasis.Color,
					BackgroundTransparency = 1,
					LayoutOrder = 2
				}),
				SalePriceLabel = v11 and React.createElement("TextLabel", {
					AutomaticSize = Enum.AutomaticSize.XY,
					Text = v5.salePriceLabel .. " " .. module2.RobloxEmoji.Robux .. v11,
					FontFace = normalizeFontFace(v6.Tokens.Typography.BodyLarge.Font),
					TextSize = v6.Font.BaseSize * v6.Font.Body.RelativeSize,
					TextColor3 = v6.Theme.TextEmphasis.Color,
					BackgroundTransparency = 1,
					LayoutOrder = 3
				})
			}
		),
		Button = 0,
		ButtonContainer = 0
	}
	local v19

	if props.resaleRestriction == module2.ResaleRestriction.Disabled then
		v19 = false
	else
		v19 = not module6()

		if v19 then
			local createElement3 = React.createElement
			local v22 = if props.isOnSale then buttonType.Secondary else buttonType.PrimarySystem
			v19 = createElement3(button, {
				buttonType = v22,
				size = UDim2.new(1, 0, 0, 28),
				text = v12,
				position = UDim2.fromScale(0, 1),
				anchorPoint = Vector2.new(0, 1),
				layoutOrder = 2,
				onActivated = props.onActivated,
				isDisabled = props.isOnHold
			})
		end
	end

	v18.Button = v19
	local v20

	if props.resaleRestriction == module2.ResaleRestriction.Disabled then
		v20 = false
	else
		v20 = module6()

		if v20 then
			local createElement3 = React.createElement
			local frame = focusable.Frame
			local v21 = {
				Size = UDim2.new(1, 0, 0, 28),
				Position = UDim2.fromScale(0, 1),
				AnchorPoint = Vector2.new(0, 1),
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				NextSelectionUp = 0,
				NextSelectionDown = 0,
				ref = 0
			}

			local v22 = if module6() then props.NextSelectionUp else nil
			v21.NextSelectionUp = v22
			local v23 = if module6() then props.NextSelectionDown else nil
			v21.NextSelectionDown = v23

			if not module6() then
				ref = nil
			end

			v21.ref = ref
			v20 = createElement3(frame, v21, {
				OnSaleButton = props.isOnSale and React.createElement(button, {
					buttonType = buttonType.Secondary,
					size = UDim2.fromScale(1, 1),
					text = v12,
					onActivated = props.onActivated,
					isDisabled = props.isOnHold
				}),
				OffSaleButton = not props.isOnSale and React.createElement(button, {
					buttonType = buttonType.PrimarySystem,
					size = UDim2.fromScale(1, 1),
					text = v12,
					onActivated = props.onActivated,
					isDisabled = props.isOnHold
				})
			})
		end
	end

	v18.ButtonContainer = v20
	v15.DetailsContainer = createElement2("Frame", v17, v18)
	return createElement("Frame", v14, v15)
end))
