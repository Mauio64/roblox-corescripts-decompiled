local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local AlertViewTextbox = require("@game/CorePackages/Packages/_Index/SocialLibraries/SocialLibraries/Components/AlertView/AlertViewTextbox")
local module2 = require("@luauforge/bundled/gxM")
local module3 = require("@luauforge/deferred/gOY")

local focusable = RoactGamepad.Focusable
local images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle

local iconscommonrobux = images["icons/common/robux"]

local function shouldShowMinimumAmountMessage(p2, value): boolean
	if not p2 then
		return true
	end

	local v5 = tonumber(p2)
	return not v5 or v5 <= (value or 0)
end

return (React.forwardRef(function(props, ref)
	local v5 = module2({
		setPriceLabel = "Feature.Catalog.Heading.SetPrice",
		pricePlaceholderText = "Feature.Catalog.Label.Price",
		minAmountText = "Feature.Catalog.Label.MinimumAmount",
		minAmountTextWithPrice = "Feature.Catalog.Label.MinimumAmountCustom"
	})

	local v6 = useStyle()

	local theme = v6.Theme
	local font = v6.Font
	local subHeader1 = font.SubHeader1
	local captionBody = font.CaptionBody
	local relativeSize = subHeader1.RelativeSize
	local relativeSize2 = captionBody.RelativeSize
	local baseSize = font.BaseSize

	local v7 = relativeSize * baseSize
	local v8 = relativeSize2 * baseSize

	local v9 = v5.minAmountText

	if props.priceFloor and props.priceFloor > 0 then
		v9 = v5.minAmountTextWithPrice:gsub("{minimumAmount}", (tostring(props.priceFloor)))
	end

	local createElement = React.createElement
	local v11 = {
		LayoutOrder = props.layoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1
	}

	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 10)
		}),
		SetPriceSubHeader = React.createElement("TextLabel", {
			LayoutOrder = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = v5.setPriceLabel,
			FontFace = normalizeFontFace(v6.Tokens.Typography.TitleLarge.Font),
			Size = UDim2.fromScale(1, 0),
			TextSize = v7,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = theme.TextEmphasis.Color,
			TextTransparency = theme.TextEmphasis.Transparency,
			TextWrapped = true,
			BackgroundTransparency = 1
		}),
		PriceInputBox = 0,
		MinAmountContainer = 0
	}

	local createElement2 = React.createElement
	local v12 = focusable[AlertViewTextbox]
	local v13 = {}
	v13.LayoutOrder = 2
	v13.Size = UDim2.fromScale(1, 0)
	v13.PlaceholderText = v5.pricePlaceholderText
	v13.Image = iconscommonrobux
	v13.TextInputType = Enum.TextInputType.Number

	if not module3() then
		ref = nil
	end

	v13.ref = ref
	local v14 = if module3() then props.NextSelectionUp else nil
	v13.NextSelectionUp = v14
	local v15 = if module3() then props.NextSelectionDown else nil
	v13.NextSelectionDown = v15
	local v16 = if module3() then props.NextSelectionLeft else nil
	v13.NextSelectionLeft = v16
	local v17 = if module3() then props.NextSelectionRight else nil
	v13.NextSelectionRight = v17
	v13[React.Change.Text] = function(p2)
		local text = p2.Text

		if string.len(text) > 10 then
			p2.Text = props.priceInRobux
		elseif text == nil or text == "" then
			props.setPriceInRobux("")
		elseif string.match(text, "^[0-9]+$") then
			props.setPriceInRobux(text)
		else
			p2.Text = props.priceInRobux
		end
	end

	children.PriceInputBox = createElement2(v12, v13)

	local createElement3 = React.createElement
	local v19 = {
		LayoutOrder = 3,
		Size = UDim2.new(1, 0, 0, v8 + 2),
		BackgroundTransparency = 1
	}

	local priceInRobux = props.priceInRobux
	local priceFloor = props.priceFloor
	local v21

	if priceInRobux then
		local v22 = tonumber(priceInRobux)
		v21 = not v22 or v22 <= (priceFloor or 0)
	else
		v21 = true
	end

	children.MinAmountContainer = createElement3("Frame", v19, {
		MinAmountText = v21 and React.createElement("TextLabel", {
			LayoutOrder = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = v9,
			FontFace = normalizeFontFace(v6.Tokens.Typography.BodySmall.Font),
			Size = UDim2.fromScale(1, 0),
			TextSize = v8,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextColor3 = theme.TextDefault.Color,
			TextTransparency = theme.TextDefault.Transparency,
			TextWrapped = true,
			BackgroundTransparency = 1
		})
	})
	return createElement("Frame", v11, children)
end))
