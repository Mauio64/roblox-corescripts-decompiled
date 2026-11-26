local module = require("@luauforge/bundled/dva")
local module2 = require("@luauforge/bundled/dtG")
local module3 = require("@luauforge/bundled/duf")
local normalizeFontFace = require("@luauforge/bundled/dvi").Utility.normalizeFontFace

local useStyle = module3.Core.Style.useStyle
local useTextSizeOffset = module3.Core.Style.useTextSizeOffset
local module4 = require("@luauforge/bundled/dvj")
local experienceFooter = require("@luauforge/bundled/dun").ExperienceFooter

local module5 = require("@luauforge/bundled/dvk")

return function(props)
	local v5 = useStyle()
	local font = v5.Font
	local theme = v5.Theme
	local v6 = useTextSizeOffset()

	local state, setState = module.useState(2)

	local v7 = math.max(0, state - 2)
	local v8 = state > 3
	local v9 = state == 2
	local padding = props.padding or 0

	local v10 = math.ceil(font.BaseSize * font.Header2.RelativeSize)
	local state2, setState2 = module.useState(v10)
	local fontSize_600 = v5.Tokens.FontSize.FontSize_600

	module.useEffect(function()
		setState2(v10 + v6)
	end, { v10, v6 })

	local v11 = module.useCallback(function(p2)
		if p2 and state2 > 0 then
			local absoluteSize = p2.AbsoluteSize

			local x = absoluteSize.X

			local v12 = absoluteSize.Y - padding - math.max(padding, 8) - x - 48

			local v13 = math.floor(v12 / (state2 + 8))

			if v13 > 3 then
				local v14 = math.floor((v12 - math.floor(v12 - (state2 + 8) * 2)) / fontSize_600)
				module2.assert(
					v14 >= 0,
					"bodyRows should always be at least 0. Otherwise, it will subtract from newContentRows, breaking component behavior."
				)

				v13 = v14 + 2
			end

			setState(v13)
		end
	end, { padding, state2 })

	local join = module4.join
	local footerData = props.footerData
	local v12 = {
		size = UDim2.new(0, 132, 0, state2),
		position = 0,
		anchorPoint = 0,
		isStatsOnly = true,
		automaticSize = 0
	}
	local v13 = if v8 or v9 then UDim2.new(1, 0, 0, 0) else nil
	v12.position = v13
	local v14 = if v8 or v9 then Vector2.new(1, 0) else nil
	v12.anchorPoint = v14

	v12.automaticSize = Enum.AutomaticSize.X
	local joined = join(footerData, v12)

	local v15 = module.createElement(experienceFooter, joined)

	local createElement = module.createElement
	local v17 = {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		ref = v11,
		[module.Change.AbsoluteSize] = v11
	}

	local createElement2 = module.createElement
	local v20 = if props.hasBackground then UDim.new(0, padding) else nil
	local children = {
		UIPadding = createElement2("UIPadding", {
			PaddingLeft = v20,
			PaddingRight = UDim.new(0, padding),
			PaddingTop = UDim.new(0, (math.max(padding, 8))),
			PaddingBottom = UDim.new(0, padding)
		}),
		Layout = module.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 8)
		}),
		TitleFrame = 0,
		LicenseDescription = 0,
		PaidAccessDescription = 0,
		SubtitleFrame = 0,
		BodyFrame = 0
	}

	local createElement3 = module.createElement
	local v22 = {
		Size = UDim2.new(1, 0, 0, state2),
		BackgroundTransparency = 1,
		LayoutOrder = 1
	}

	local v23 = {
		UIListLayout = module.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Title = 0,
		InlineFooter = 0
	}

	local v24 = if props.title and string.len(props.title) > 0 then module.createElement("TextLabel", {
		Size = UDim2.new(1, v8 and -132 or 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Text = props.title,
		FontFace = normalizeFontFace(v5.Tokens.Typography.TitleLarge.Font),
		TextSize = v10,
		TextTransparency = theme.TextEmphasis.Transparency,
		TextColor3 = theme.TextEmphasis.Color,
		TextWrapped = true,
		TextTruncate = Enum.TextTruncate.SplitWord,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		LayoutOrder = -1
	}, {
		UIFlexItem = module.createElement("UIFlexItem", {
			FlexMode = Enum.UIFlexMode.Shrink
		})
	}) else nil
	v23.Title = v24

	v23.InlineFooter = if v8 then v15 else nil
	children.TitleFrame = createElement3("Frame", v22, v23)

	local v26 = if props.licenseDescription then module.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, state2),
			BackgroundTransparency = 1,
			LayoutOrder = 2
		},
		{
			LicenseDescription = module.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Text = props.licenseDescription,
				FontFace = normalizeFontFace(v5.Tokens.Typography.BodyLarge.Font),
				TextSize = v10,
				TextTransparency = theme.TextEmphasis.Transparency,
				TextColor3 = theme.TextEmphasis.Color,
				TextWrapped = true,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top
			})
		}
	) else nil
	children.LicenseDescription = v26

	local v27 = if props.paidAccessDescription and not props.licenseDescription then module.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, state2),
			BackgroundTransparency = 1,
			LayoutOrder = 2
		},
		{
			PaidAccessDescription = module.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Text = props.paidAccessDescription,
				FontFace = normalizeFontFace(v5.Tokens.Typography.BodyLarge.Font),
				TextSize = v10,
				TextTransparency = theme.TextEmphasis.Transparency,
				TextColor3 = theme.TextEmphasis.Color,
				TextWrapped = true,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top
			})
		}
	) else nil
	children.PaidAccessDescription = v27

	local createElement4 = module.createElement
	local v29 = {
		Size = UDim2.new(1, 0, 0, state2),
		BackgroundTransparency = 1,
		LayoutOrder = 3
	}

	local v31 = if props.creatorName then module.createElement("Frame", {
		Size = UDim2.new(1, v9 and -132 or 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1
	}, {
		Text = module.createElement(module5, {
			name = props.creatorName,
			hasVerifiedBadge = props.creatorVerified,
			creatorId = props.creatorId
		})
	}) else nil
	children.SubtitleFrame = createElement4("Frame", v29, {
		CreatorName = v31,
		InlineFooter = if v9 then v15 else nil
	})
	local v33

	if v7 > 0 then
		local createElement5 = module.createElement
		local newUDim2 = UDim2.new

		local v39 = if v7 > 1 then fontSize_600 * v7 else state2 * v7
		local v35 = {
			Size = newUDim2(1, 0, 0, v39),
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			LayoutOrder = 4
		}

		if v7 > 1 then
			v15 = module.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = props.description,
				FontFace = normalizeFontFace(v5.Tokens.Typography.BodyLarge.Font),
				TextSize = font.BaseSize * font.Body.RelativeSize,
				TextTransparency = theme.TextDefault.Transparency,
				TextColor3 = theme.TextDefault.Color,
				TextWrapped = true,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top
			}, {
				UITextSizeConstraint = module.createElement("UITextSizeConstraint", {
					MaxTextSize = fontSize_600
				})
			})
		end

		v33 = createElement5("Frame", v35, { ExperienceInfo = v15 })
	end

	children.BodyFrame = v33
	return createElement("Frame", v17, children)
end
