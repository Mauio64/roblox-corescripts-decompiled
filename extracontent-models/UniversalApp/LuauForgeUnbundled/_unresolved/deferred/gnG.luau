local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local numberLocalization = require("@game/CorePackages/Workspace/Packages/Localization").NumberLocalization
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local itemTile = UIBlox.Tile.ItemTile
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle

local module = require("@luauforge/bundled/dRQ")
local module2 = require("@luauforge/bundled/dME")
local module3 = require("@luauforge/bundled/fTi")
local module4 = require("@luauforge/bundled/eeH")
local module5 = require("@luauforge/bundled/edB")
local getRbxthumbWithTypeSizeAndOptions = require("@luauforge/bundled/cgr").Utils.getRbxthumbWithTypeSizeAndOptions
local module6 = require("@luauforge/deferred/gks")
local fFlagAXThumbTypeNilCheck = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXThumbTypeNilCheck
require("@luauforge/bundled/dMc")

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

	local createElement3 = React.createElement
	local v20 = { Size = UDim2.fromScale(1, 0), BackgroundTransparency = 1 }

	local v21 = {
		Layout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, 4),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		ItemTitleLabel = 0,
		BuyPriceLabel = 0,
		SalePriceLabel = 0
	}

	local createElement4 = React.createElement
	local v23 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		Text = props.title,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextColor3 = 0,
		TextTruncate = 0,
		TextXAlignment = 0,
		BackgroundTransparency = 1,
		LayoutOrder = 1
	}
	local v24 = if not foundationFontFaceMigration then v6.Font.Header2.Font else nil
	v23.Font = v24

	local v25 = if foundationFontFaceMigration then normalizeFontFace(v6.Tokens.Typography.TitleLarge.Font) else nil
	v23.FontFace = v25

	v23.TextSize = v6.Font.BaseSize * v6.Font.Header2.RelativeSize
	v23.TextColor3 = v6.Theme.TextEmphasis.Color
	v23.TextTruncate = Enum.TextTruncate.AtEnd
	v23.TextXAlignment = Enum.TextXAlignment.Left
	v21.ItemTitleLabel = createElement4("TextLabel", v23)

	if v9 then
		local createElement5 = React.createElement
		local v27 = {
			AutomaticSize = Enum.AutomaticSize.XY,
			Text = v5.buyPriceLabel .. " " .. module2.RobloxEmoji.Robux .. v9,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextColor3 = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 2
		}
		local v28 = if not foundationFontFaceMigration then v6.Font.Body.Font else nil
		v27.Font = v28

		local v29 = if foundationFontFaceMigration then normalizeFontFace(v6.Tokens.Typography.BodyLarge.Font) else nil
		v27.FontFace = v29

		v27.TextSize = v6.Font.BaseSize * v6.Font.Body.RelativeSize
		v27.TextColor3 = v6.Theme.TextEmphasis.Color
		v9 = createElement5("TextLabel", v27)
	end

	v21.BuyPriceLabel = v9

	if v11 then
		local createElement5 = React.createElement
		local v27 = {
			AutomaticSize = Enum.AutomaticSize.XY,
			Text = v5.salePriceLabel .. " " .. module2.RobloxEmoji.Robux .. v11,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextColor3 = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 3
		}
		local v28 = if not foundationFontFaceMigration then v6.Font.Body.Font else nil
		v27.Font = v28

		local v29 = if foundationFontFaceMigration then normalizeFontFace(v6.Tokens.Typography.BodyLarge.Font) else nil
		v27.FontFace = v29

		v27.TextSize = v6.Font.BaseSize * v6.Font.Body.RelativeSize
		v27.TextColor3 = v6.Theme.TextEmphasis.Color
		v11 = createElement5("TextLabel", v27)
	end

	v21.SalePriceLabel = v11
	local v18 = {
		LabelsContainer = createElement3("Frame", v20, v21),
		Button = 0,
		ButtonContainer = 0
	}
	local v26

	if props.resaleRestriction == module2.ResaleRestriction.Disabled then
		v26 = false
	else
		v26 = not module6()

		if v26 then
			local createElement5 = React.createElement
			local v29 = if props.isOnSale then buttonType.Secondary else buttonType.PrimarySystem
			v26 = createElement5(button, {
				buttonType = v29,
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

	v18.Button = v26
	local v27

	if props.resaleRestriction == module2.ResaleRestriction.Disabled then
		v27 = false
	else
		v27 = module6()

		if v27 then
			local createElement5 = React.createElement
			local frame = focusable.Frame
			local v28 = {
				Size = UDim2.new(1, 0, 0, 28),
				Position = UDim2.fromScale(0, 1),
				AnchorPoint = Vector2.new(0, 1),
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				NextSelectionUp = 0,
				NextSelectionDown = 0,
				ref = 0
			}

			local v29 = if module6() then props.NextSelectionUp else nil
			v28.NextSelectionUp = v29
			local v30 = if module6() then props.NextSelectionDown else nil
			v28.NextSelectionDown = v30

			if not module6() then
				ref = nil
			end

			v28.ref = ref
			v27 = createElement5(frame, v28, {
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

	v18.ButtonContainer = v27
	v15.DetailsContainer = createElement2("Frame", v17, v18)
	return createElement("Frame", v14, v15)
end))
