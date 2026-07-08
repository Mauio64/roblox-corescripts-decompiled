local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local ParentParent = scriptParentParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Core = ParentParentParent.Core
local ParentParentParentParent = ParentParentParent.Parent
local Cryo = require(ParentParentParentParent.Cryo)
local React = require(ParentParentParentParent.React)
local Roact = require(ParentParentParentParent.Roact)
local getControlStateColor = require(ParentParentParent.Utility.getControlStateColor)
local setDefault = require(ParentParentParent.Utility.setDefault)
local useStyle = require(Core.Style.useStyle)
local Interactable = require(Core.Control.Interactable)
local useControlState = require(Core.Control.useControlState)

require(ParentParent.Style.StyleTypes)
require(ParentParent.Style.Fonts)

local useCursor = require(ParentParent.SelectionCursor.useCursor)
local Constants = require(scriptParent.Constants)
local ExperienceActionRow = require(scriptParent.ExperienceActionRow)
local AspectRatioMode = require(scriptParent.Enum.AspectRatioMode)
local getAspectRatio = require(scriptParent.getAspectRatio)
local VerticalTile = require(scriptParentParent.VerticalTile.VerticalTile)
local TileContentPanel = require(scriptParentParent.TileContentPanel)
local VerticalTileThumbnail = require(scriptParentParent.VerticalTile.VerticalTileThumbnail)

local function renderContentWithPadding(p1, p2, t1: {[any]: any}, t2: {[any]: any}) -- line: 82
	-- upvalues: React (copy), Cryo (copy), Roact (copy)
	return React.createElement(p1, Cryo.Dictionary.join({
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, t1), {
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, p2.Left),
			PaddingRight = UDim.new(0, p2.Right),
			PaddingTop = UDim.new(0, p2.Top),
			PaddingBottom = UDim.new(0, p2.Bottom)
		}),
		Content = Roact.createFragment(t2)
	})
end
local function getFinalAspectRatioMode(p3, b1: boolean) -- line: 106
	-- upvalues: AspectRatioMode (copy)
	if p3 ~= nil then
		if b1 then
			return AspectRatioMode.Wide
		end

		return p3
	end

	if b1 then
		return AspectRatioMode.Wide
	end

	return AspectRatioMode.Square
end
local function ExperienceTileV3(t3: {[any]: any}) -- line: 122
	-- upvalues: useStyle (copy), setDefault (copy), Constants (copy), Cryo (copy), React (copy), AspectRatioMode (copy), getAspectRatio (copy), renderContentWithPadding (copy), VerticalTileThumbnail (copy), Roact (copy), TileContentPanel (copy), ExperienceActionRow (copy), useControlState (copy), useCursor (copy), getControlStateColor (copy), Interactable (copy), VerticalTile (copy)
	local v33 = useStyle()
	local v34 = setDefault(t3.footerHeight, Constants.DEFAULT_FOOTER_HEIGHT)
	local v35 = setDefault(t3.isHoverEnabled, false)
	local v36 = setDefault(t3.hasBackground, true)
	local v37 = Constants.getDefaultStyleProps(v33)
	local v38 = Cryo.Dictionary.join(v37, t3.styleProps or {})
	local backgroundColor = v38.backgroundColor
	local border = v38.border
	local dropShadow = v38.dropShadow
	local topContentPadding = v38.topContentPadding
	local bottomContentPadding = v38.bottomContentPadding
	local overlayColors = v38.overlayColors
	local selectionCursorPadding = v38.selectionCursorPadding
	local contentTitlePadding = v38.contentTitlePadding
	local contentTitleFont = v38.contentTitleFont
	local v48 = setDefault(t3.contentTextLineCount, Constants.DEFAULT_TEXT_LINE_COUNT)
	local v49 = React.useCallback(function(b2: boolean) -- line: 140
		-- upvalues: v33 (copy), t3 (copy), AspectRatioMode (copy), getAspectRatio (copy), renderContentWithPadding (copy), topContentPadding (copy), React (copy), VerticalTileThumbnail (copy), border (copy), v36 (copy), Roact (copy)
		local v59 = b2 and not v33.Settings.ReducedMotion
		local thumbnailAspectRatioOverride = t3.thumbnailAspectRatioOverride
		local v61 = if thumbnailAspectRatioOverride == nil then if not v59 then AspectRatioMode.Square else AspectRatioMode.Wide else if not v59 then thumbnailAspectRatioOverride else AspectRatioMode.Wide
		local v62 = getAspectRatio(v61)
		local v63 = if v61 ~= AspectRatioMode.Wide then t3.thumbnail else t3.wideThumbnail

		return renderContentWithPadding("Frame", topContentPadding, {
			ZIndex = 3,
			Size = UDim2.new(1, 0, v62, 0),
			SizeConstraint = Enum.SizeConstraint.RelativeXX
		}, {
			Thumbnail = React.createElement(VerticalTileThumbnail, {
				isTopRounded = true,
				aspectRatio = v62,
				border = border,
				isBottomRounded = not v36,
				thumbnail = v63
			}),
			TopContentOverlay = if t3.renderTopContentOverlay == nil then nil else Roact.createFragment((t3.renderTopContentOverlay(v59, border)))
		})
	end, {
		t3.renderTopContentOverlay,
		t3.wideThumbnail,
		t3.thumbnail,
		t3.thumbnailAspectRatioOverride,
		topContentPadding,
		border,
		v36
	})
	local v50 = React.useCallback(function(b3: boolean) -- line: 174
		-- upvalues: v48 (copy), contentTitleFont (copy), v33 (copy), contentTitlePadding (copy), v34 (copy), bottomContentPadding (copy), t3 (copy), renderContentWithPadding (copy), border (copy), React (copy), TileContentPanel (copy)
		local v65 = math.floor(v48 * contentTitleFont.RelativeSize * v33.Font.BaseSize + contentTitlePadding) + v34 + bottomContentPadding.Top + bottomContentPadding.Bottom

		if t3.renderBottomContent ~= nil then
			return renderContentWithPadding("Frame", bottomContentPadding, {
				Size = UDim2.new(1, 0, 0, v65)
			}, {
				BottomContent = t3.renderBottomContent(b3, border)
			})
		end

		return React.createElement(TileContentPanel, {
			hasSidePadding = true,
			contentTitle = t3.experienceName,
			panelHeight = UDim.new(0, v65),
			outerPadding = bottomContentPadding,
			footerHeight = UDim.new(0, v34),
			textLineCount = v48,
			titleFont = contentTitleFont,
			titlePadding = contentTitlePadding,
			contentFooter = if not b3 then nil else t3.footer
		})
	end, {
		t3.experienceName,
		t3.renderBottomContent,
		t3.footer,
		v48,
		contentTitlePadding,
		bottomContentPadding,
		v34,
		contentTitleFont,
		border,
		v33
	})
	local v51 = React.useCallback(function(b4: boolean?) -- line: 213
		-- upvalues: t3 (copy), React (copy), ExperienceActionRow (copy), v34 (copy), bottomContentPadding (copy), renderContentWithPadding (copy)
		if t3.renderBottomContent ~= nil then
			return nil
		end

		if b4 then
			if t3.renderActionRow ~= nil then
				return t3.renderActionRow()
			end

			return React.createElement(ExperienceActionRow, t3.actionRowProps)
		end

		local v67 = v34 + bottomContentPadding.Top + bottomContentPadding.Bottom

		return renderContentWithPadding("Frame", bottomContentPadding, {
			Size = UDim2.new(1, 0, 0, v67),
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1)
		}, {
			FooterContent = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				Position = UDim2.new(0, 0, 1, 0),
				AnchorPoint = Vector2.new(0, 1),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				Footer = t3.footer
			})
		})
	end, {
		t3.footer,
		t3.actionRowProps,
		t3.renderBottomContent,
		t3.renderActionRow,
		bottomContentPadding,
		v34
	})
	local v52, v53 = useControlState()
	local v54 = useCursor(border.CornerRadius)
	local v55 = getControlStateColor(v52, overlayColors)
	local Color, Transparency

	if v55 ~= nil then
		Color = v55.Color
		Transparency = v55.Transparency
	else
		Color = nil
		Transparency = 1
	end

	return renderContentWithPadding(Interactable, selectionCursorPadding, {
		Size = UDim2.new(1, 0, 1, 0),
		SelectionImageObject = v54,
		onStateChanged = v53,
		isDisabled = t3.isDisabled,
		[React.Event.Activated] = t3.onActivated,
		[React.Event.SelectionGained] = t3.onSelectionGained,
		[React.Event.SelectionLost] = t3.onSelectionLost
	}, {
		VerticalTile = React.createElement(VerticalTile, {
			isOverlayVisible = false,
			isActive = false,
			reservedBottomHeight = 0,
			hasBackground = v36,
			hasOutline = setDefault(t3.hasOutline, true),
			isHoverEnabled = v35,
			hoverDelay = t3.hoverDelay,
			onHoverChanged = t3.onHoverChanged,
			renderTopContent = v49,
			renderBottomContent = v50,
			renderFooterRow = v51,
			backgroundColor = backgroundColor,
			border = border,
			dropShadow = dropShadow
		}),
		OverlayColor = React.createElement("Frame", {
			ZIndex = 10,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color,
			BackgroundTransparency = Transparency
		}, {
			Corner = React.createElement("UICorner", {
				CornerRadius = border.CornerRadius
			})
		})
	})
end

return ExperienceTileV3
