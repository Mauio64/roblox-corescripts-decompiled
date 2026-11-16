local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local AlertViewTextbox = require("@game/CorePackages/Packages/_Index/SocialLibraries/SocialLibraries/Components/AlertView/AlertViewTextbox")
local module2 = require("@luauforge/bundled/fTi")
local module3 = require("@luauforge/deferred/gks")

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
		SetPriceSubHeader = 0,
		PriceInputBox = 0,
		MinAmountContainer = 0
	}

	local createElement2 = React.createElement
	local v13 = {
		LayoutOrder = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Text = v5.setPriceLabel,
		Font = 0,
		FontFace = 0,
		Size = 0,
		TextSize = 0,
		TextXAlignment = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		TextWrapped = true,
		BackgroundTransparency = 1
	}
	local v14 = if not foundationFontFaceMigration then subHeader1.Font else nil
	v13.Font = v14

	local v15 = if foundationFontFaceMigration then normalizeFontFace(v6.Tokens.Typography.TitleLarge.Font) else nil
	v13.FontFace = v15

	v13.Size = UDim2.fromScale(1, 0)
	v13.TextSize = v7
	v13.TextXAlignment = Enum.TextXAlignment.Left
	v13.TextColor3 = theme.TextEmphasis.Color
	v13.TextTransparency = theme.TextEmphasis.Transparency
	children.SetPriceSubHeader = createElement2("TextLabel", v13)

	local createElement3 = React.createElement
	local v16 = focusable[AlertViewTextbox]
	local v17 = {}
	v17.LayoutOrder = 2
	v17.Size = UDim2.fromScale(1, 0)
	v17.PlaceholderText = v5.pricePlaceholderText
	v17.Image = iconscommonrobux
	v17.TextInputType = Enum.TextInputType.Number

	if not module3() then
		ref = nil
	end

	v17.ref = ref
	local v18 = if module3() then props.NextSelectionUp else nil
	v17.NextSelectionUp = v18
	local v19 = if module3() then props.NextSelectionDown else nil
	v17.NextSelectionDown = v19
	local v20 = if module3() then props.NextSelectionLeft else nil
	v17.NextSelectionLeft = v20
	local v21 = if module3() then props.NextSelectionRight else nil
	v17.NextSelectionRight = v21
	v17[React.Change.Text] = function(p2)
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

	children.PriceInputBox = createElement3(v16, v17)

	local createElement4 = React.createElement
	local v23 = {
		LayoutOrder = 3,
		Size = UDim2.new(1, 0, 0, v8 + 2),
		BackgroundTransparency = 1
	}

	local priceInRobux = props.priceInRobux
	local priceFloor = props.priceFloor
	local v25

	if priceInRobux then
		local v26 = tonumber(priceInRobux)
		v25 = not v26 or v26 <= (priceFloor or 0)
	else
		v25 = true
	end

	if v25 then
		local createElement5 = React.createElement
		local v27 = {
			LayoutOrder = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = v9,
			Font = 0,
			FontFace = 0,
			Size = 0,
			TextSize = 0,
			TextXAlignment = 0,
			TextYAlignment = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			TextWrapped = true,
			BackgroundTransparency = 1
		}

		local v28 = if not foundationFontFaceMigration then captionBody.Font else nil
		v27.Font = v28

		local v29 = if foundationFontFaceMigration then normalizeFontFace(v6.Tokens.Typography.BodySmall.Font) else nil
		v27.FontFace = v29

		v27.Size = UDim2.fromScale(1, 0)
		v27.TextSize = v8
		v27.TextXAlignment = Enum.TextXAlignment.Left
		v27.TextYAlignment = Enum.TextYAlignment.Top
		v27.TextColor3 = theme.TextDefault.Color
		v27.TextTransparency = theme.TextDefault.Transparency
		v25 = createElement5("TextLabel", v27)
	end

	children.MinAmountContainer = createElement4("Frame", v23, { MinAmountText = v25 })
	return createElement("Frame", v11, children)
end))
