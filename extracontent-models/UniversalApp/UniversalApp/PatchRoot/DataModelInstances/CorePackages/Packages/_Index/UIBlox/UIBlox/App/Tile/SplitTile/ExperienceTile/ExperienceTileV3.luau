local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent.Parent
local parent4 = parent3.Parent
local core = parent4.Core
local parent5 = parent4.Parent

local Cryo = require(parent5.Cryo)
local React = require(parent5.React)
local Roact = require(parent5.Roact)
local getControlStateColor = require(parent4.Utility.getControlStateColor)
local setDefault = require(parent4.Utility.setDefault)

local useStyle = require(core.Style.useStyle)
local Interactable = require(core.Control.Interactable)
local useControlState = require(core.Control.useControlState)
require(parent3.Style.StyleTypes)
require(parent3.Style.Fonts)
local useCursor = require(parent3.SelectionCursor.useCursor)

local Constants = require(parent.Constants)
local ExperienceActionRow = require(parent.ExperienceActionRow)
local AspectRatioMode = require(parent.Enum.AspectRatioMode)
local getAspectRatio = require(parent.getAspectRatio)
local VerticalTile = require(parent2.VerticalTile.VerticalTile)
local TileContentPanel = require(parent2.TileContentPanel)
local VerticalTileThumbnail = require(parent2.VerticalTile.VerticalTileThumbnail)

local function renderContentWithPadding(p, props, p2, p3)
	return React.createElement(
		p,
		Cryo.Dictionary.join({ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }, p2),
		{
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, props.Left),
				PaddingRight = UDim.new(0, props.Right),
				PaddingTop = UDim.new(0, props.Top),
				PaddingBottom = UDim.new(0, props.Bottom)
			}),
			Content = Roact.createFragment(p3)
		}
	)
end

local function getFinalAspectRatioMode(thumbnailAspectRatioOverride, flag: boolean) -- 1 equivalent call inferred from this helper
	if thumbnailAspectRatioOverride == nil then
		if flag then
			return AspectRatioMode.Wide
		end

		return AspectRatioMode.Square
	elseif flag then
		return AspectRatioMode.Wide
	else
		return thumbnailAspectRatioOverride
	end
end

local function ExperienceTileV3(props)
	local v = useStyle()
	local v2 = setDefault(props.footerHeight, Constants.DEFAULT_FOOTER_HEIGHT)
	local isHoverEnabled = setDefault(props.isHoverEnabled, false)
	local hasBackground = setDefault(props.hasBackground, true)
	local defaultStyleProps = Constants.getDefaultStyleProps(v)
	local joined = Cryo.Dictionary.join(defaultStyleProps, props.styleProps or {})
	local backgroundColor = joined.backgroundColor
	local border = joined.border
	local dropShadow = joined.dropShadow
	local topContentPadding = joined.topContentPadding
	local bottomContentPadding = joined.bottomContentPadding
	local overlayColors = joined.overlayColors
	local selectionCursorPadding = joined.selectionCursorPadding
	local contentTitlePadding = joined.contentTitlePadding
	local contentTitleFont = joined.contentTitleFont
	local textLineCount = setDefault(props.contentTextLineCount, Constants.DEFAULT_TEXT_LINE_COUNT)

	local renderTopContent = React.useCallback(function(flag: boolean)
		local v3 = flag and not v.Settings.ReducedMotion

		local finalAspectRatioMode = getFinalAspectRatioMode(props.thumbnailAspectRatioOverride, v3) -- inferred equivalent call
		local aspectRatio = getAspectRatio(finalAspectRatioMode)
		local thumbnail

		if finalAspectRatioMode == AspectRatioMode.Wide then
			thumbnail = props.wideThumbnail
		else
			thumbnail = props.thumbnail
		end

		local v4 = {
			Size = UDim2.new(1, 0, aspectRatio, 0),
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			ZIndex = 3
		}

		local v5 = {
			Thumbnail = React.createElement(VerticalTileThumbnail, {
				aspectRatio = aspectRatio,
				border = border,
				isTopRounded = true,
				isBottomRounded = not hasBackground,
				thumbnail = thumbnail
			}),
			TopContentOverlay = 0
		}
		local topContentOverlay

		if props.renderTopContentOverlay ~= nil then
			topContentOverlay = Roact.createFragment((props.renderTopContentOverlay(v3, border)))
		end

		v5.TopContentOverlay = topContentOverlay
		return renderContentWithPadding("Frame", topContentPadding, v4, v5)
	end, {
		props.renderTopContentOverlay,
		props.wideThumbnail,
		props.thumbnail,
		props.thumbnailAspectRatioOverride,
		topContentPadding,
		border,
		hasBackground
	})

	local renderBottomContent = React.useCallback(function(flag: boolean)
		local v3 = math.floor(textLineCount * contentTitleFont.RelativeSize * v.Font.BaseSize + contentTitlePadding) + v2 + bottomContentPadding.Top + bottomContentPadding.Bottom

		if props.renderBottomContent ~= nil then
			return renderContentWithPadding("Frame", bottomContentPadding, {
				Size = UDim2.new(1, 0, 0, v3)
			}, {
				BottomContent = props.renderBottomContent(flag, border)
			})
		end

		local createElement = React.createElement
		local v4 = {
			contentTitle = props.experienceName,
			panelHeight = UDim.new(0, v3),
			outerPadding = bottomContentPadding,
			footerHeight = UDim.new(0, v2),
			textLineCount = textLineCount,
			titleFont = contentTitleFont,
			titlePadding = contentTitlePadding,
			contentFooter = 0,
			hasSidePadding = true
		}
		local contentFooter

		if flag then
			contentFooter = props.footer
		end

		v4.contentFooter = contentFooter
		return createElement(TileContentPanel, v4)
	end, {
		props.experienceName,
		props.renderBottomContent,
		props.footer,
		textLineCount,
		contentTitlePadding,
		bottomContentPadding,
		v2,
		contentTitleFont,
		border,
		v
	})

	local renderFooterRow = React.useCallback(function(flag: boolean?)
		if props.renderBottomContent ~= nil then
			return nil
		end

		if not flag then
			local v3 = v2 + bottomContentPadding.Top + bottomContentPadding.Bottom
			return renderContentWithPadding(
				"Frame",
				bottomContentPadding,
				{
					Size = UDim2.new(1, 0, 0, v3),
					Position = UDim2.new(0, 0, 1, 0),
					AnchorPoint = Vector2.new(0, 1)
				},
				{
					FooterContent = React.createElement("Frame", {
						Size = UDim2.new(1, 0, 0, 0),
						Position = UDim2.new(0, 0, 1, 0),
						AnchorPoint = Vector2.new(0, 1),
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.Y
					}, { Footer = props.footer })
				}
			)
		end

		if props.renderActionRow == nil then
			return React.createElement(ExperienceActionRow, props.actionRowProps)
		end

		return props.renderActionRow()
	end, {
		props.footer,
		props.actionRowProps,
		props.renderBottomContent,
		props.renderActionRow,
		bottomContentPadding,
		v2
	})

	local v3, onStateChanged = useControlState()

	local selectionImageObject = useCursor(border.CornerRadius)
	local controlStateColor = getControlStateColor(v3, overlayColors)
	local color, backgroundTransparency

	if controlStateColor == nil then
		backgroundTransparency = 1
	else
		color = controlStateColor.Color
		backgroundTransparency = controlStateColor.Transparency
	end

	return renderContentWithPadding(Interactable, selectionCursorPadding, {
		Size = UDim2.new(1, 0, 1, 0),
		SelectionImageObject = selectionImageObject,
		onStateChanged = onStateChanged,
		isDisabled = props.isDisabled,
		[React.Event.Activated] = props.onActivated,
		[React.Event.SelectionGained] = props.onSelectionGained,
		[React.Event.SelectionLost] = props.onSelectionLost
	}, {
		VerticalTile = React.createElement(VerticalTile, {
			hasBackground = hasBackground,
			hasOutline = setDefault(props.hasOutline, true),
			isHoverEnabled = isHoverEnabled,
			hoverDelay = props.hoverDelay,
			onHoverChanged = props.onHoverChanged,
			isOverlayVisible = false,
			isActive = false,
			renderTopContent = renderTopContent,
			renderBottomContent = renderBottomContent,
			renderFooterRow = renderFooterRow,
			reservedBottomHeight = 0,
			backgroundColor = backgroundColor,
			border = border,
			dropShadow = dropShadow
		}),
		OverlayColor = React.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = color,
				ZIndex = 10,
				BackgroundTransparency = backgroundTransparency
			},
			{
				Corner = React.createElement("UICorner", { CornerRadius = border.CornerRadius })
			}
		)
	})
end

return ExperienceTileV3
