local module = require("@luauforge/bundled/dva")
local module2 = require("@luauforge/bundled/duf")
local normalizeFontFace = require("@luauforge/bundled/dvi").Utility.normalizeFontFace

local useStyle = module2.Core.Style.useStyle
local useTextSizeOffset = module2.Core.Style.useTextSizeOffset
local module3 = require("@luauforge/bundled/dvj")
local module4 = require("@luauforge/bundled/dun")
local gridTileTextFooter = module4.GridTileTextFooter
local experienceFooter = module4.ExperienceFooter

local module5 = require("@luauforge/bundled/dvk")

return function(props)
	local v5 = useStyle()
	local font = v5.Font
	local theme = v5.Theme
	local v6 = useTextSizeOffset()
	local padding = props.padding or 0

	local v7 = math.ceil(font.BaseSize * font.Header2.RelativeSize)
	local state, setState = module.useState(v7)

	module.useEffect(function()
		setState(v7 + v6)
	end, { v7, v6 })

	local joined = module3.join(props.footerData, {
		size = UDim2.new(0, 132, 0, v7),
		layoutOrder = 2,
		isStatsOnly = true
	})

	local v8 = nil

	if props.licenseDescription then
		v8 = module.createElement(gridTileTextFooter, {
			text = props.licenseDescription,
			useLargerFont = true,
			LayoutOrder = 2
		})
	elseif props.paidAccessDescription then
		v8 = module.createElement(gridTileTextFooter, {
			text = props.paidAccessDescription,
			useLargerFont = true,
			LayoutOrder = 2
		})
	else
		module.createElement(experienceFooter, joined)
	end

	local createElement = module.createElement
	local v10 = {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ClipsDescendants = true
	}

	local createElement2 = module.createElement
	local v12 = {
		PaddingTop = UDim.new(0, padding),
		PaddingLeft = 0,
		PaddingRight = 0,
		PaddingBottom = 0
	}
	local v13 = if props.hasBackground then UDim.new(0, padding) else nil
	v12.PaddingLeft = v13
	local v14 = if props.hasBackground then UDim.new(0, padding) else nil
	v12.PaddingRight = v14
	local v15 = if props.hasBackground then UDim.new(0, padding) else nil
	v12.PaddingBottom = v15
	local children = {
		UIPadding = createElement2("UIPadding", v12),
		Layout = module.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, padding)
		}),
		Title = 0,
		Footer = 0,
		CreatorName = 0,
		Description = 0
	}

	local v16 = if props.title and string.len(props.title) > 0 then module.createElement("TextLabel", {
		Size = UDim2.new(1, 0, 0, state),
		BackgroundTransparency = 1,
		Text = props.title,
		FontFace = normalizeFontFace(v5.Tokens.Typography.TitleLarge.Font),
		TextSize = v7,
		TextTransparency = theme.TextEmphasis.Transparency,
		TextColor3 = theme.TextEmphasis.Color,
		TextWrapped = true,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		LayoutOrder = 1
	}) else nil
	children.Title = v16

	children.Footer = v8
	local v17 = if props.creatorName then module.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, state),
			BackgroundTransparency = 1,
			LayoutOrder = 3
		},
		{
			Text = module.createElement(module5, {
				name = props.creatorName,
				hasVerifiedBadge = props.creatorVerified,
				creatorId = props.creatorId
			})
		}
	) else nil
	children.CreatorName = v17

	local v18 = if props.description and string.len(props.description) > 0 then module.createElement("TextLabel", {
		Size = UDim2.new(1, 0, 0, state * 3),
		BackgroundTransparency = 1,
		Text = props.description,
		FontFace = normalizeFontFace(v5.Tokens.Typography.BodyLarge.Font),
		TextSize = font.BaseSize * font.Body.RelativeSize,
		TextTransparency = theme.TextDefault.Transparency,
		TextColor3 = theme.TextDefault.Color,
		TextWrapped = true,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		LayoutOrder = 4
	}, {
		UITextSizeConstraint = module.createElement("UITextSizeConstraint", {
			MaxTextSize = v5.Tokens.FontSize.FontSize_600
		})
	}) else nil
	children.Description = v18
	return createElement("Frame", v10, children)
end
