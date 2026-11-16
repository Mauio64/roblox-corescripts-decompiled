local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent
local UIBloxConfig = require(parent.UIBloxConfig)

local Cryo = require(parent2.Cryo)
local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local ImageSetComponent = require(parent.Core.ImageSet.ImageSetComponent)
local Label = ImageSetComponent.Label
local GenericTextLabel = require(parent.Core.Text.GenericTextLabel.GenericTextLabel)
local useStyle = require(parent.Core.Style.useStyle)
require(parent.App.Style.StyleTypes)
require(parent.App.Style.Fonts)

local v = {
	size = UDim2.fromScale(1, 1),
	faceGroupCount = 3,
	maxBadgeDisplayNumber = 99,
	styleProps = {},
	showEmphasisBorder = false
}

local v2 = {
	containerGap = 6,
	faceGroupGap = -9,
	faceBorderWidth = 3,
	faceBorderRadius = 50,
	faceWidth = 24,
	faceHeight = 24,
	badgeBorderWidth = 3,
	badgeBorderRadius = 50,
	badgeSpacingLeading = 9,
	badgeSpacingTrailing = 9,
	badgeHeight = 24
}

local function getAvatarImage(user: string) -- 1 equivalent call inferred from this helper
	return string.format("rbxthumb://type=AvatarHeadShot&id=%s&w=150&h=150", (tostring(user)))
end

local function renderCornerStroke(props)
	return React.createElement(React.Fragment, nil, {
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, props.borderRadius)
		}),
		Stroke = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = props.borderColor.Color,
			Transparency = props.borderColor.Transparency,
			Thickness = props.borderWidth
		})
	})
end

local function renderEmphasisBorder(p: number, props, p2, zIndex: number?)
	local theme = p2.Theme
	local v3 = p - 1
	local v4 = (1 - p) / 2
	return React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Position = UDim2.new(0, v4, 0, v4),
			Size = UDim2.new(1, v3, 1, v3),
			ZIndex = zIndex
		},
		{ renderCornerStroke({
				borderWidth = 1,
				borderColor = theme.ContextualPrimaryDefault,
				borderRadius = props.badgeBorderRadius
			}) }
	)
end

local function renderBadge(props, props2, p)
	local text

	if props.usersCount > props.maxDisplayNumber then
		text = tostring(props.maxDisplayNumber) .. "+"
	else
		text = tostring(props.usersCount)
	end

	local theme = p.Theme
	local font = p.Font

	local badgeBackgroundColor = props2.badgeBackgroundColor or theme.BackgroundUIDefault
	local badgeBorderWidth = props2.badgeBorderWidth
	local badgeBorderColor = props2.badgeBorderColor or p.Theme.BackgroundDefault
	local badgeBorderRadius = props2.badgeBorderRadius
	local badgeSpacingLeading = props2.badgeSpacingLeading
	local badgeSpacingTrailing = props2.badgeSpacingTrailing
	local badgeHeight = props2.badgeHeight
	local badgeContentColor = props2.badgeContentColor or theme.TextMuted

	local element = React.createElement("Frame", {
		LayoutOrder = props.layoutOrder,
		ZIndex = props.ZIndex,
		Size = UDim2.fromOffset(0, badgeHeight),
		BorderSizePixel = 0,
		BackgroundColor3 = badgeBackgroundColor.Color,
		BackgroundTransparency = badgeBackgroundColor.Transparency,
		AutomaticSize = Enum.AutomaticSize.X
	}, {
		renderCornerStroke({
			borderWidth = badgeBorderWidth,
			borderColor = badgeBorderColor,
			borderRadius = badgeBorderRadius
		}),
		SizeConstraint = React.createElement("UISizeConstraint", {
			MinSize = Vector2.new(badgeHeight, 0)
		}),
		Content = React.createElement("TextLabel", {
			Size = UDim2.fromScale(1, 1),
			BorderSizePixel = 0,
			Text = text,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			FontFace = normalizeFontFace(font.CaptionHeader.Font),
			TextSize = font.BaseSize * font.CaptionHeader.RelativeSize,
			TextColor3 = badgeContentColor.Color,
			TextTransparency = badgeContentColor.Transparency,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.X,
			ZIndex = props.ZIndex + 1
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, badgeSpacingLeading),
				PaddingRight = UDim.new(0, badgeSpacingTrailing)
			})
		})
	})

	local createElement = React.createElement
	local v3 = {
		LayoutOrder = props.layoutOrder,
		ZIndex = props.ZIndex,
		Size = UDim2.fromOffset(0, badgeHeight),
		BorderSizePixel = 0,
		BackgroundColor3 = badgeBackgroundColor.Color,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.X
	}
	local emphasisBorder

	if props.showEmphasisBorder then
		emphasisBorder = renderEmphasisBorder(badgeBorderWidth, props2, p, props.ZIndex + 1)
	end

	return createElement("Frame", v3, { BadgeContainer = element, emphasisBorder = emphasisBorder })
end

local function renderFaceImage(props, props2, p)
	local faceBackgroundColor = props2.faceBackgroundColor or p.Theme.TextDefault
	local faceBorderWidth = props2.faceBorderWidth
	local faceBorderColor = props2.faceBorderColor or p.Theme.BackgroundDefault
	local faceBorderRadius = props2.faceBorderRadius
	local faceWidth = props2.faceWidth
	local faceHeight = props2.faceHeight
	local createElement = React.createElement
	local v3 = {
		LayoutOrder = props.layoutOrder,
		ZIndex = props.ZIndex,
		Size = UDim2.fromOffset(faceWidth, faceHeight),
		Image = getAvatarImage(props.user), -- inferred equivalent call
		BackgroundColor3 = faceBackgroundColor.Color,
		BackgroundTransparency = faceBackgroundColor.Transparency,
		BorderSizePixel = 0
	}

	local v4 = { [1] = nil, (renderCornerStroke({
			borderWidth = faceBorderWidth,
			borderColor = faceBorderColor,
			borderRadius = faceBorderRadius
		})) }
	local emphasisBorder

	if props.showEmphasisBorder then
		emphasisBorder = renderEmphasisBorder(faceBorderWidth, props2, p, props.ZIndex + 1)
	end

	v4.emphasisBorder = emphasisBorder
	return createElement(Label, v3, v4)
end

local function renderFaces(props, props2, p, p2: number, flag: boolean, faceGroupCount: number)
	local users = props.users
	local faceGroupGap = props2.faceGroupGap
	local badgeBorderWidth = props2.badgeBorderWidth
	local faceBorderWidth = props2.faceBorderWidth
	local v3 = math.max(badgeBorderWidth, faceBorderWidth)

	local v4 = {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, faceGroupGap)
		}),
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, badgeBorderWidth),
			PaddingTop = UDim.new(0, v3),
			PaddingRight = UDim.new(0, faceBorderWidth),
			PaddingBottom = UDim.new(0, v3)
		}),
		Badge = 0
	}
	local badge

	if flag then
		badge = renderBadge({
			usersCount = #users,
			layoutOrder = 0,
			ZIndex = p2 + 1,
			maxDisplayNumber = props.maxBadgeDisplayNumber,
			showEmphasisBorder = props.showEmphasisBorder
		}, props2, p)
	end

	v4.Badge = badge

	for i = 1, math.min(faceGroupCount, #users) do
		v4["Face_" .. i] = renderFaceImage({
			user = users[i],
			layoutOrder = i,
			ZIndex = p2 - i,
			showEmphasisBorder = props.showEmphasisBorder
		}, props2, p)
	end

	return React.createElement(
		"Frame",
		{ AutomaticSize = Enum.AutomaticSize.XY, BackgroundTransparency = 1, BorderSizePixel = 0 },
		v4
	)
end

local function CoPlayFooter(p)
	local joined = Cryo.Dictionary.join(v, p)

	if not UIBloxConfig.fixCoplayFooterConditionalHooks and (not joined.users or #joined.users == 0) then
		return nil
	end

	local v3 = useStyle()
	local v4, v5 = React.useBinding(Vector2.new(0, 0))
	local joined2 = Cryo.Dictionary.join(v2, joined.styleProps)
	local v6

	if UIBloxConfig.fixCoplayFooterConditionalHooks then
		v6 = React.useCallback(function(p2)
			v5(p2.AbsoluteSize)
		end, { v5 })

		if not joined.users or #joined.users == 0 then
			return nil
		end
	end

	local containerGap = joined2.containerGap
	local labelContentColor = joined2.labelContentColor or v3.Theme.TextMuted

	local faceGroupCount = joined.faceGroupCount
	local v7 = #joined.users
	local v8 = faceGroupCount + 1 < v7

	if not v8 then
		faceGroupCount += 1
	end

	local v9 = faceGroupCount + 1

	if not UIBloxConfig.fixCoplayFooterConditionalHooks then
		v6 = React.useCallback(function(p2)
			v5(p2.AbsoluteSize)
		end, { v5 })
	end

	local createElement = React.createElement
	local v10 = {
		Size = joined.size,
		Position = joined.position,
		AnchorPoint = joined.anchorPoint,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = joined.layoutOrder
	}
	local v11 = {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, containerGap)
		}),
		FacesFrame = React.createElement("Frame", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.XY,
			[React.Change.AbsoluteSize] = v6
		}, {
			Faces = renderFaces(joined, joined2, v3, v9, v8, faceGroupCount)
		}),
		LabelFrame = 0
	}
	local labelFrame

	if joined.labelText then
		labelFrame = React.createElement("Frame", {
			LayoutOrder = 2,
			Size = v4:map(function(vector2: Vector2)
				return UDim2.new(1, -vector2.X - containerGap, 1, 0)
			end),
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}, {
			Label = React.createElement(GenericTextLabel, {
				Size = UDim2.fromScale(1, 1),
				Text = joined.labelText,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextWrapped = false,
				fontStyle = joined2.fontStyle or v3.Font.CaptionBody,
				colorStyle = labelContentColor
			})
		})
	end

	v11.LabelFrame = labelFrame
	return createElement("Frame", v10, v11)
end

return CoPlayFooter
