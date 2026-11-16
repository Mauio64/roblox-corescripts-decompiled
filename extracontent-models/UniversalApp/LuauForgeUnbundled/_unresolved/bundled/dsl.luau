local module = require("@luauforge/bundled/drY")
local module2 = require("@luauforge/bundled/drd")
local module3 = require("@luauforge/bundled/dsg")
local normalizeFontFace = module3.Utility.normalizeFontFace
local foundationFontFaceMigration = module3.Utility.Flags.FoundationFontFaceMigration

local useStyle = module2.Core.Style.useStyle
local useTextSizeOffset = module2.Core.Style.useTextSizeOffset
local module4 = require("@luauforge/bundled/dsh")
local module5 = require("@luauforge/bundled/drl")
local gridTileTextFooter = module5.GridTileTextFooter
local experienceFooter = module5.ExperienceFooter

local module6 = require("@luauforge/bundled/dsi")

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

	local joined = module4.join(props.footerData, {
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
	local v16

	if props.title and string.len(props.title) > 0 then
		local createElement3 = module.createElement
		local v18 = {
			Size = UDim2.new(1, 0, 0, state),
			BackgroundTransparency = 1,
			Text = props.title,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextTransparency = 0,
			TextColor3 = 0,
			TextWrapped = true,
			TextTruncate = 0,
			TextXAlignment = 0,
			TextYAlignment = 0,
			LayoutOrder = 1
		}
		local v19 = if not foundationFontFaceMigration then font.Header2.Font else nil
		v18.Font = v19

		local v20 = if foundationFontFaceMigration then normalizeFontFace(v5.Tokens.Typography.TitleLarge.Font) else nil
		v18.FontFace = v20

		v18.TextSize = v7
		v18.TextTransparency = theme.TextEmphasis.Transparency
		v18.TextColor3 = theme.TextEmphasis.Color

		v18.TextTruncate = Enum.TextTruncate.AtEnd
		v18.TextXAlignment = Enum.TextXAlignment.Left
		v18.TextYAlignment = Enum.TextYAlignment.Top
		v16 = createElement3("TextLabel", v18)
	end

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
			Text = module.createElement(module6, {
				name = props.creatorName,
				hasVerifiedBadge = props.creatorVerified,
				creatorId = props.creatorId
			})
		}
	) else nil
	children.CreatorName = v17
	local v18

	if props.description and string.len(props.description) > 0 then
		local createElement3 = module.createElement
		local v20 = {
			Size = UDim2.new(1, 0, 0, state * 3),
			BackgroundTransparency = 1,
			Text = props.description,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextTransparency = 0,
			TextColor3 = 0,
			TextWrapped = true,
			TextTruncate = 0,
			TextXAlignment = 0,
			TextYAlignment = 0,
			LayoutOrder = 4
		}
		local v21 = if not foundationFontFaceMigration then font.Body.Font else nil
		v20.Font = v21

		local v22 = if foundationFontFaceMigration then normalizeFontFace(v5.Tokens.Typography.BodyLarge.Font) else nil
		v20.FontFace = v22

		v20.TextSize = font.BaseSize * font.Body.RelativeSize
		v20.TextTransparency = theme.TextDefault.Transparency
		v20.TextColor3 = theme.TextDefault.Color

		v20.TextTruncate = Enum.TextTruncate.AtEnd
		v20.TextXAlignment = Enum.TextXAlignment.Left
		v20.TextYAlignment = Enum.TextYAlignment.Top
		v18 = createElement3("TextLabel", v20, {
			UITextSizeConstraint = module.createElement("UITextSizeConstraint", {
				MaxTextSize = v5.Tokens.FontSize.FontSize_600
			})
		})
	end

	children.Description = v18
	return createElement("Frame", v10, children)
end
