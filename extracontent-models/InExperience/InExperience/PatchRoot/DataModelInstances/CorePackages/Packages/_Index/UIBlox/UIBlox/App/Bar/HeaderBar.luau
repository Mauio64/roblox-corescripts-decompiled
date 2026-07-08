local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local React = require(ParentParentParentParent.React)
local Cryo = require(ParentParentParentParent.Cryo)

require(ParentParent.Style.StyleTypes)
require(ParentParent.Style.Fonts)

local useStyle = require(ParentParentParent.Core.Style.useStyle)
local GenericTextLabel = require(ParentParentParent.Core.Text.GenericTextLabel.GenericTextLabel)
local GetTextSize = require(ParentParentParent.Core.Text.GetTextSize)
local ThreeSectionBar = require(ParentParentParent.Core.Bar.ThreeSectionBar)
local t1 = {
	barHeight = 48,
	title = "",
	isTitleCentered = true,
	isSecondary = false,
	isOnMedia = false,
	hasDivider = false
}

local function useHeaderBarStyle(t2: {[any]: any}, p1) -- line: 92
	-- upvalues: React (copy)
	local Tokens = p1.Tokens
	local Theme = p1.Theme
	local backgroundStyle = t2.backgroundStyle
	local backgroundTransparency = t2.backgroundTransparency
	local isOnMedia = t2.isOnMedia
	local v21 = React.useMemo(function() -- line: 99
		-- upvalues: isOnMedia (copy), backgroundStyle (copy), Theme (copy), backgroundTransparency (copy)
		if isOnMedia then
			return {}
		end

		local v55 = backgroundStyle or {
			Color3 = Theme.BackgroundDefault.Color,
			Transparency = Theme.BackgroundDefault.Transparency
		}

		if backgroundTransparency then
			v55.Transparency = backgroundTransparency
		end

		return v55
	end, {
		isOnMedia,
		backgroundStyle,
		backgroundTransparency,
		Theme
	})
	local paddingTop = t2.paddingTop
	local paddingRight = t2.paddingRight
	local paddingBottom = t2.paddingBottom
	local paddingLeft = t2.paddingLeft
	local margin = t2.margin
	local v27 = React.useMemo(function() -- line: 123
		-- upvalues: paddingTop (copy), Tokens (copy), paddingRight (copy), paddingBottom (copy), paddingLeft (copy), margin (copy)
		local t3 = {
			Top = paddingTop or UDim.new(0, Tokens.Global.Space_100),
			Right = paddingRight or UDim.new(0, Tokens.Global.Space_250),
			Bottom = paddingBottom or UDim.new(0, Tokens.Global.Space_100),
			Left = paddingLeft or UDim.new(0, Tokens.Global.Space_250)
		}

		if margin then
			t3.Left = UDim.new(0, margin)
			t3.Right = UDim.new(0, margin)
		end

		return t3
	end, {
		paddingTop,
		paddingRight,
		paddingBottom,
		paddingLeft,
		margin,
		Tokens
	})

	return {
		BackgroundStyle = v21,
		Padding = v27
	}
end
local function useRenderLeft(t4: {[any]: any}, p2) -- line: 144
	-- upvalues: React (copy), Cryo (copy), GenericTextLabel (copy)
	return React.useMemo(function() -- line: 145
		-- upvalues: t4 (copy), React (copy), p2 (copy), Cryo (copy), GenericTextLabel (copy)
		local title = t4.title
		local renderLeft = t4.renderLeft
		local isTitleCentered = t4.isTitleCentered
		local isSecondary = t4.isSecondary
		local shouldHideSecondaryLeftItem = t4.shouldHideSecondaryLeftItem
		local v62 = renderLeft == nil or renderLeft == React.None
		local Tokens = p2.Tokens
		local renderLeft2 = t4.renderLeft

		if v62 and string.len(title) > 0 then
			return function(p3) -- line: 156
				-- upvalues: Cryo (copy), React (copy), Tokens (copy), GenericTextLabel (copy), title (copy)
				local v77 = Cryo.Dictionary.join(p3.children, {
					TextPadding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, Tokens.Global.Space_25),
						PaddingBottom = UDim.new(0, Tokens.Global.Space_25)
					})
				})

				return React.createElement(React.Fragment, nil, {
					Text = React.createElement(GenericTextLabel, {
						fluidSizing = true,
						Text = title,
						TextXAlignment = Enum.TextXAlignment.Left,
						fontStyle = Tokens.Semantic.Typography.Title,
						colorStyle = Tokens.Semantic.Color.Text.Emphasis
					}, v77)
				})
			end
		end

		if isSecondary and not shouldHideSecondaryLeftItem and string.len(title) > 0 then
			local Theme = p2.Theme
			local p2Font = p2.Font
			local Header2 = p2Font.Header2
			local v68 = Header2.RelativeSize * p2Font.BaseSize

			return function() -- line: 181
				-- upvalues: React (copy), v68 (copy), renderLeft (copy), Theme (copy), GenericTextLabel (copy), title (copy), Header2 (copy)
				return React.createElement(React.Fragment, nil, {
					Text = React.createElement("Frame", {
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v68)
					}, {
						Layout = React.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Horizontal,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							Padding = UDim.new(0, 12)
						}),
						Left = React.createElement("Frame", {
							LayoutOrder = 1,
							Selectable = false,
							BorderSizePixel = 0,
							BackgroundTransparency = 1,
							Size = UDim2.fromOffset(0, 0),
							AutomaticSize = Enum.AutomaticSize.XY
						}, {
							LeftContent = if not renderLeft then nil else renderLeft()
						}),
						Divider = React.createElement("Frame", {
							LayoutOrder = 2,
							Selectable = false,
							BorderSizePixel = 0,
							BackgroundColor3 = Theme.Divider.Color,
							BackgroundTransparency = Theme.Divider.Transparency,
							Size = UDim2.new(0, 1, 1, 0)
						}),
						TextLabel = React.createElement(GenericTextLabel, {
							LayoutOrder = 3,
							Selectable = false,
							ClipsDescendants = true,
							TextWrapped = false,
							Text = title,
							TextTruncate = Enum.TextTruncate.AtEnd,
							TextXAlignment = Enum.TextXAlignment.Left,
							fontStyle = Header2,
							colorStyle = Theme.TextEmphasis
						})
					})
				})
			end
		end

		if not isSecondary and not isTitleCentered then
			local Header = Tokens.Semantic.Typography.Header
			local FontSize = Header.FontSize

			function renderLeft2() -- line: 230
				-- upvalues: React (copy), FontSize (copy), Tokens (copy), renderLeft (copy), GenericTextLabel (copy), title (copy), Header (copy)
				return React.createElement(React.Fragment, nil, {
					LeftFrame = React.createElement("Frame", {
						Selectable = false,
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, FontSize)
					}, {
						Layout = React.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Horizontal,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							Padding = UDim.new(0, Tokens.Global.Space_150)
						}),
						Left = React.createElement("Frame", {
							LayoutOrder = 1,
							Selectable = false,
							BorderSizePixel = 0,
							BackgroundTransparency = 1,
							Size = UDim2.fromOffset(0, 0),
							AutomaticSize = Enum.AutomaticSize.XY
						}, {
							LeftContent = if not renderLeft then nil else renderLeft()
						}),
						TextLabel = React.createElement(GenericTextLabel, {
							LayoutOrder = 2,
							Selectable = false,
							ClipsDescendants = true,
							TextWrapped = false,
							Text = title,
							TextTruncate = Enum.TextTruncate.AtEnd,
							TextXAlignment = Enum.TextXAlignment.Left,
							fontStyle = Header,
							colorStyle = Tokens.Semantic.Color.Text.Emphasis
						}, {
							TextPadding = React.createElement("UIPadding", {
								PaddingTop = UDim.new(0, Tokens.Global.Space_25),
								PaddingBottom = UDim.new(0, Tokens.Global.Space_25)
							})
						})
					})
				})
			end
		end

		return renderLeft2
	end, {
		t4.title,
		t4.isTitleCentered,
		t4.renderLeft,
		t4.isSecondary,
		t4.shouldHideSecondaryLeftItem,
		p2
	})
end
local function HeaderBar(t5: {[any]: any}) -- line: 286
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), React (copy), useRenderLeft (copy), GenericTextLabel (copy), GetTextSize (copy), useHeaderBarStyle (copy), ThreeSectionBar (copy)
	local v31 = Cryo.Dictionary.join(t1, t5)
	local v32 = useStyle()
	local Tokens = v32.Tokens
	local title = v31.title
	local renderCenter = v31.renderCenter
	local renderRight = v31.renderRight
	local isTitleCentered = v31.isTitleCentered
	local isSecondary = v31.isSecondary
	local onHeaderActivated = v31.onHeaderActivated
	local contentPaddingRight = v31.contentPaddingRight
	local automaticHeight = v31.automaticHeight
	local isOnMedia = v31.isOnMedia
	local zIndex = v31.zIndex
	local hasDivider = v31.hasDivider
	local v45 = v31.renderLeft == nil or v31.renderLeft == React.None
	local v46 = useRenderLeft(v31, v32)
	local v47 = React.useMemo(function() -- line: 306
		-- upvalues: renderCenter (copy), v45 (copy), isSecondary (copy), isTitleCentered (copy), Tokens (copy), React (copy), GenericTextLabel (copy), title (copy)
		local v71 = renderCenter

		if not v71 and (not v45 and not isSecondary and isTitleCentered) then
			local Header = Tokens.Semantic.Typography.Header
			local FontSize = Header.FontSize

			function v71() -- line: 313
				-- upvalues: React (copy), GenericTextLabel (copy), FontSize (copy), title (copy), Header (copy), Tokens (copy)
				return React.createElement(GenericTextLabel, {
					Selectable = false,
					ClipsDescendants = true,
					TextWrapped = false,
					Size = UDim2.new(1, 0, 0, FontSize),
					Text = title,
					TextTruncate = Enum.TextTruncate.AtEnd,
					fontStyle = Header,
					colorStyle = Tokens.Semantic.Color.Text.Emphasis
				}, {
					TextPadding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, Tokens.Global.Space_25),
						PaddingBottom = UDim.new(0, Tokens.Global.Space_25)
					})
				})
			end
		end

		return v71
	end, {
		renderCenter,
		v45,
		isSecondary,
		isTitleCentered,
		Tokens,
		title
	})
	local v48 = React.useMemo(function() -- line: 334
		-- upvalues: v46 (copy), renderCenter (copy), renderRight (copy), v45 (copy), isSecondary (copy), isTitleCentered (copy), Tokens (copy), GetTextSize (copy), title (copy)
		if v46 and (renderCenter and renderRight) then
			return 0
		end

		if not renderCenter and not v45 and not isSecondary and isTitleCentered then
			local Header = Tokens.Semantic.Typography.Header
			local FontSize = Header.FontSize

			return GetTextSize(title, FontSize, Header.Font, Vector2.new(1e999, 1e999)).X
		end

		return 1e999
	end, {
		title,
		isTitleCentered,
		v45,
		v46,
		renderCenter,
		renderRight,
		isSecondary,
		Tokens
	})
	local v49 = React.useMemo(function() -- line: 351
		-- upvalues: contentPaddingRight (copy), v45 (copy), Tokens (copy)
		if contentPaddingRight then
			return contentPaddingRight
		end

		if v45 then
			return UDim.new(0, 0)
		end

		return UDim.new(0, Tokens.Global.Space_300)
	end, {
		contentPaddingRight,
		v45,
		Tokens
	})
	local v50 = useHeaderBarStyle(v31, v32)
	local BackgroundStyle = v50.BackgroundStyle
	local Padding = v50.Padding
	local v53 = if not isOnMedia then v31.barHeight else v31.barHeight + Tokens.Global.Size_500
	local v54 = if not automaticHeight then math.max(0, v31.barHeight - Padding.Top.Offset - Padding.Bottom.Offset) else 0

	return React.createElement("Frame", {
		Selectable = false,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, v53),
		BackgroundColor3 = BackgroundStyle.Color3,
		BackgroundTransparency = BackgroundStyle.Transparency,
		AutomaticSize = if not automaticHeight then nil else Enum.AutomaticSize.Y,
		ZIndex = zIndex
	}, {
		Gradient = if not isOnMedia then nil else React.createElement("UIGradient", {
			Rotation = 90,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
				ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
			}),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.7),
				NumberSequenceKeypoint.new(1, 1)
			})
		}),
		OnMediaExtendedHeight = if not isOnMedia then nil else React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, Tokens.Global.Size_500)
		}),
		Bar = React.createElement("Frame", {
			Selectable = false,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = Padding.Top,
				PaddingRight = Padding.Right,
				PaddingBottom = Padding.Bottom,
				PaddingLeft = Padding.Left
			}),
			ThreeSectionBar = React.createElement(ThreeSectionBar, {
				BackgroundTransparency = 1,
				barHeight = v54,
				automaticHeight = automaticHeight,
				renderLeft = v46,
				renderCenter = v47,
				renderRight = renderRight,
				estimatedCenterWidth = v48,
				sectionSpacing = Tokens.Global.Space_150,
				contentPaddingRight = v49
			})
		}),
		HeaderClickArea = if not onHeaderActivated then nil else React.createElement("TextButton", {
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = "",
			Size = UDim2.fromScale(1, 1),
			Selectable = false,
			[React.Event.Activated] = onHeaderActivated,
			ZIndex = 0
		}),
		BottomDivider = if not hasDivider then nil else React.createElement("Frame", {
			Selectable = false,
			BorderSizePixel = 0,
			ZIndex = 1,
			Size = UDim2.new(1, 0, 0, Tokens.Global.Stroke_100),
			Position = UDim2.new(0, 0, 1, -Tokens.Global.Stroke_100),
			BackgroundColor3 = Tokens.Semantic.Color.Common.Divider.Color3,
			BackgroundTransparency = Tokens.Semantic.Color.Common.Divider.Transparency
		})
	})
end

return HeaderBar
