local parent = script.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local React = require(parent3.React)
local Cryo = require(parent3.Cryo)

require(parent.Style.StyleTypes)
require(parent.Style.Fonts)
local useStyle = require(parent2.Core.Style.useStyle)
local GenericTextLabel = require(parent2.Core.Text.GenericTextLabel.GenericTextLabel)
local GetTextSize = require(parent2.Core.Text.GetTextSize)
local ThreeSectionBar = require(parent2.Core.Bar.ThreeSectionBar)

local v = {
	barHeight = 48,
	title = "",
	isTitleCentered = true,
	isSecondary = false,
	isOnMedia = false,
	hasDivider = false
}

local function useHeaderBarStyle(joined, p)
	local tokens = p.Tokens
	local theme = p.Theme

	local backgroundStyle = joined.backgroundStyle
	local backgroundTransparency = joined.backgroundTransparency
	local isOnMedia = joined.isOnMedia
	local backgroundStyle2 = React.useMemo(function()
		if isOnMedia then
			return {}
		end

		local v2 = backgroundStyle
			or {
				Color3 = theme.BackgroundDefault.Color,
				Transparency = theme.BackgroundDefault.Transparency
			}

		if backgroundTransparency then
			v2.Transparency = backgroundTransparency
		end

		return v2
	end, { isOnMedia, backgroundStyle, backgroundTransparency, theme })

	local paddingTop = joined.paddingTop
	local paddingRight = joined.paddingRight
	local paddingBottom = joined.paddingBottom
	local paddingLeft = joined.paddingLeft
	local margin = joined.margin
	return {
		BackgroundStyle = backgroundStyle2,
		Padding = React.useMemo(function()
			local v2 = {
				Top = paddingTop or UDim.new(0, tokens.Size.Size_200),
				Right = paddingRight or UDim.new(0, tokens.Size.Size_500),
				Bottom = paddingBottom or UDim.new(0, tokens.Size.Size_200),
				Left = paddingLeft or UDim.new(0, tokens.Size.Size_500)
			}

			if margin then
				v2.Left = UDim.new(0, margin)
				v2.Right = UDim.new(0, margin)
			end

			return v2
		end, { paddingTop, paddingRight, paddingBottom, paddingLeft, margin, tokens })
	}
end

local function useRenderLeft(joined, data)
	return React.useMemo(function()
		local title = joined.title
		local renderLeft = joined.renderLeft
		local isTitleCentered = joined.isTitleCentered
		local isSecondary = joined.isSecondary
		local shouldHideSecondaryLeftItem = joined.shouldHideSecondaryLeftItem
		local v2 = renderLeft == nil or renderLeft == React.None
		local tokens = data.Tokens

		local renderLeft2 = joined.renderLeft

		if v2 and string.len(title) > 0 then
			return function(p)
				local joined2 = Cryo.Dictionary.join(p.children, {
					TextPadding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, tokens.Size.Size_50),
						PaddingBottom = UDim.new(0, tokens.Size.Size_50)
					})
				})

				return React.createElement(React.Fragment, nil, {
					Text = React.createElement(GenericTextLabel, {
						fluidSizing = true,
						Text = title,
						TextXAlignment = Enum.TextXAlignment.Left,
						fontStyle = tokens.Typography.HeadingLarge,
						colorStyle = tokens.Color.Content.Emphasis
					}, joined2)
				})
			end
		end

		if isSecondary and not shouldHideSecondaryLeftItem and string.len(title) > 0 then
			local theme = data.Theme
			local font = data.Font
			local header2 = font.Header2
			local v3 = header2.RelativeSize * font.BaseSize

			return function()
				local createElement = React.createElement
				local fragment = React.Fragment
				local createElement2 = React.createElement
				local v4 = {
					Size = UDim2.new(1, 0, 0, v3),
					BorderSizePixel = 0,
					BackgroundTransparency = 1
				}

				local children = {
					Layout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = UDim.new(0, 12)
					}),
					Left = 0,
					Divider = 0,
					TextLabel = 0
				}

				local createElement3 = React.createElement
				local v5 = {
					LayoutOrder = 1,
					Selectable = false,
					Size = UDim2.fromOffset(0, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY
				}
				local leftContent

				if renderLeft then
					leftContent = renderLeft()
				end

				children.Left = createElement3("Frame", v5, { LeftContent = leftContent })

				children.Divider = React.createElement("Frame", {
					LayoutOrder = 2,
					Selectable = false,
					BackgroundColor3 = theme.Divider.Color,
					BackgroundTransparency = theme.Divider.Transparency,
					BorderSizePixel = 0,
					Size = UDim2.new(0, 1, 1, 0)
				})

				children.TextLabel = React.createElement(GenericTextLabel, {
					LayoutOrder = 3,
					Selectable = false,
					ClipsDescendants = true,
					Text = title,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextWrapped = false,
					TextXAlignment = Enum.TextXAlignment.Left,
					fontStyle = header2,
					colorStyle = theme.TextEmphasis
				})
				return createElement(fragment, nil, {
					Text = createElement2("Frame", v4, children)
				})
			end
		end

		if not (isSecondary or isTitleCentered) then
			local headingSmall = tokens.Typography.HeadingSmall
			local fontSize = headingSmall.FontSize

			return function()
				local createElement = React.createElement
				local fragment = React.Fragment
				local createElement2 = React.createElement
				local v3 = {
					Selectable = false,
					Size = UDim2.new(1, 0, 0, fontSize),
					BorderSizePixel = 0,
					BackgroundTransparency = 1
				}

				local children = {
					Layout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = UDim.new(0, tokens.Size.Size_300)
					}),
					Left = 0,
					TextLabel = 0
				}

				local createElement3 = React.createElement
				local v4 = {
					LayoutOrder = 1,
					Selectable = false,
					Size = UDim2.fromOffset(0, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY
				}
				local leftContent

				if renderLeft then
					leftContent = renderLeft()
				end

				children.Left = createElement3("Frame", v4, { LeftContent = leftContent })

				children.TextLabel = React.createElement(GenericTextLabel, {
					LayoutOrder = 2,
					Selectable = false,
					ClipsDescendants = true,
					Text = title,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextWrapped = false,
					TextXAlignment = Enum.TextXAlignment.Left,
					fontStyle = headingSmall,
					colorStyle = tokens.Color.Content.Emphasis
				}, {
					TextPadding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, tokens.Size.Size_50),
						PaddingBottom = UDim.new(0, tokens.Size.Size_50)
					})
				})
				return createElement(fragment, nil, {
					LeftFrame = createElement2("Frame", v3, children)
				})
			end
		end

		return renderLeft2
	end, {
		joined.title,
		joined.isTitleCentered,
		joined.renderLeft,
		joined.isSecondary,
		joined.shouldHideSecondaryLeftItem,
		data
	})
end

local function HeaderBar(p)
	local joined = Cryo.Dictionary.join(v, p)
	local v2 = useStyle()
	local tokens = v2.Tokens

	local title = joined.title
	local renderCenter = joined.renderCenter
	local renderRight = joined.renderRight
	local isTitleCentered = joined.isTitleCentered
	local isSecondary = joined.isSecondary
	local onHeaderActivated = joined.onHeaderActivated
	local contentPaddingRight = joined.contentPaddingRight
	local automaticHeight = joined.automaticHeight
	local isOnMedia = joined.isOnMedia
	local zIndex = joined.zIndex
	local hasDivider = joined.hasDivider
	local v3 = joined.renderLeft == nil or joined.renderLeft == React.None

	local renderLeft = useRenderLeft(joined, v2)

	local renderCenter2 = React.useMemo(function()
		local renderCenter2 = renderCenter

		if not renderCenter2 and not v3 and not isSecondary and isTitleCentered then
			local headingSmall = tokens.Typography.HeadingSmall
			local fontSize = headingSmall.FontSize
			return function()
				return React.createElement(GenericTextLabel, {
					Selectable = false,
					ClipsDescendants = true,
					Size = UDim2.new(1, 0, 0, fontSize),
					Text = title,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextWrapped = false,
					fontStyle = headingSmall,
					colorStyle = tokens.Color.Content.Emphasis
				}, {
					TextPadding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, tokens.Size.Size_50),
						PaddingBottom = UDim.new(0, tokens.Size.Size_50)
					})
				})
			end
		end

		return renderCenter2
	end, { renderCenter, v3, isSecondary, isTitleCentered, tokens, title })

	local estimatedCenterWidth = React.useMemo(function()
		if renderLeft and renderCenter and renderRight then
			return 0
		end

		if renderCenter or v3 or isSecondary or not isTitleCentered then
			return 1e999
		end

		local headingSmall = tokens.Typography.HeadingSmall
		return GetTextSize(title, headingSmall.FontSize, headingSmall.Font, Vector2.new(1e999, 1e999)).X
	end, { title, isTitleCentered, v3, renderLeft, renderCenter, renderRight, isSecondary, tokens })

	local contentPaddingRight2 = React.useMemo(function()
		if contentPaddingRight then
			return contentPaddingRight
		end

		if v3 then
			return UDim.new(0, 0)
		end

		return UDim.new(0, tokens.Size.Size_600)
	end, { contentPaddingRight, v3, tokens })

	local v4 = useHeaderBarStyle(joined, v2)
	local backgroundStyle = v4.BackgroundStyle
	local padding = v4.Padding
	local v5

	if isOnMedia then
		v5 = joined.barHeight + tokens.Size.Size_1000
	else
		v5 = joined.barHeight
	end

	local barHeight = automaticHeight and 0
		or math.max(0, joined.barHeight - padding.Top.Offset - padding.Bottom.Offset)

	local createElement = React.createElement
	local v6 = {
		Selectable = false,
		Size = UDim2.new(1, 0, 0, v5),
		BorderSizePixel = 0,
		BackgroundColor3 = backgroundStyle.Color3,
		BackgroundTransparency = backgroundStyle.Transparency,
		AutomaticSize = 0,
		ZIndex = 0
	}
	local automaticSize

	if automaticHeight then
		automaticSize = Enum.AutomaticSize.Y
	end

	v6.AutomaticSize = automaticSize
	v6.ZIndex = zIndex
	local gradient

	if isOnMedia then
		gradient = React.createElement("UIGradient", {
			Rotation = 90,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
				ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
			}),
			Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.7), NumberSequenceKeypoint.new(1, 1) })
		})
	end

	local onMediaExtendedHeight

	if isOnMedia then
		onMediaExtendedHeight = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, tokens.Size.Size_1000)
		})
	end

	local v7 = {
		Gradient = gradient,
		OnMediaExtendedHeight = onMediaExtendedHeight,
		Bar = React.createElement("Frame", {
			Selectable = false,
			Size = UDim2.fromScale(1, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = padding.Top,
				PaddingRight = padding.Right,
				PaddingBottom = padding.Bottom,
				PaddingLeft = padding.Left
			}),
			ThreeSectionBar = React.createElement(ThreeSectionBar, {
				BackgroundTransparency = 1,
				barHeight = barHeight,
				automaticHeight = automaticHeight,
				renderLeft = renderLeft,
				renderCenter = renderCenter2,
				renderRight = renderRight,
				estimatedCenterWidth = estimatedCenterWidth,
				sectionSpacing = tokens.Size.Size_300,
				contentPaddingRight = contentPaddingRight2
			})
		}),
		HeaderClickArea = 0,
		BottomDivider = 0
	}
	local headerClickArea

	if onHeaderActivated then
		headerClickArea = React.createElement("TextButton", {
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = "",
			Size = UDim2.fromScale(1, 1),
			Selectable = false,
			[React.Event.Activated] = onHeaderActivated,
			ZIndex = 0
		})
	end

	v7.HeaderClickArea = headerClickArea
	local bottomDivider

	if hasDivider then
		bottomDivider = React.createElement("Frame", {
			Selectable = false,
			Size = UDim2.new(1, 0, 0, tokens.Stroke.Standard),
			Position = UDim2.new(0, 0, 1, -tokens.Stroke.Standard),
			BackgroundColor3 = tokens.Color.Stroke.Emphasis.Color3,
			BackgroundTransparency = tokens.Color.Stroke.Emphasis.Transparency,
			BorderSizePixel = 0,
			ZIndex = 1
		})
	end

	v7.BottomDivider = bottomDivider
	return createElement("Frame", v6, v7)
end

return HeaderBar
