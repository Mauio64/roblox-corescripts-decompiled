local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent
local parent4 = parent3.Parent

local RoactGamepad = require(parent4.RoactGamepad)

local React = require(parent4.React)
local Cryo = require(parent4.Cryo)
local t = require(parent4.t)
local withStyle = require(parent3.Core.Style.withStyle)
local validateFontInfo = require(parent3.Core.Style.Validator.validateFontInfo)
local validateTypographyInfo = require(parent3.Core.Style.Validator.validateTypographyInfo)
local GetTextSize = require(parent3.Core.Text.GetTextSize)
local GetFontFromFontStyle = require(parent3.Core.Text.GetFontFromFontStyle)
local GetWrappedTextWithIcon = require(parent3.Core.Text.GetWrappedTextWithIcon)
local withTextSizeOffset = require(parent3.Core.Style.withTextSizeOffset)

local CursorKind = require(parent2.SelectionImage.CursorKind)
local withSelectionCursorProvider = require(parent2.SelectionImage.withSelectionCursorProvider)
local useCursor = require(parent3.App.SelectionCursor.useCursor)

local TileName = require(parent.TileName)
local TileThumbnail = require(parent.TileThumbnail)
local TileBanner = require(parent.TileBanner)
local StyledTextLabel = require(parent2.Text.StyledTextLabel)
local Images = require(parent3.App.ImageSet.Images)
local Interactable = require(parent3.Core.Control.Interactable)

local udim = UDim.new(0, 10)

local extended = React.PureComponent:extend("Tile")

local v = t.strictInterface({
	footer = t.optional(t.table),
	name = t.optional(t.string),
	nameTextColor = t.optional(t.Color3),
	nameTextTransparency = t.optional(t.number),
	nameOverThumbnail = t.optional(t.boolean),
	titleRichText = t.optional(t.boolean),
	subtitle = t.optional(t.string),
	hasVerifiedBadge = t.optional(t.boolean),
	titleTextLineCount = t.optional(t.integer),
	innerPadding = t.optional(t.number),
	titleTopPadding = t.optional(t.number),
	subtitleTopPadding = t.optional(t.number),
	footerTopPadding = t.optional(t.number),
	onActivated = t.optional(t.callback),
	thumbnail = t.optional(t.union(t.string, t.table)),
	thumbnailSize = t.optional(t.UDim2),
	thumbnailFrameSize = t.optional(t.UDim2),
	thumbnailColor = t.optional(t.Color3),
	thumbnailTransparency = t.optional(t.number),
	thumbnailAspectRatio = t.optional(t.number),
	thumbnailScaleType = t.optional(t.enum(Enum.ScaleType)),
	bannerText = t.optional(t.string),
	backgroundImage = t.optional(t.union(t.string, t.table)),
	isSelected = t.optional(t.boolean),
	Selectable = t.optional(t.boolean),
	multiSelect = t.optional(t.boolean),
	isDisabled = t.optional(t.boolean),
	hasRoundedCorners = t.optional(t.boolean),
	titleIcon = t.optional(t.table),
	thumbnailOverlayComponents = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	thumbnailRef = t.optional(t.table),
	textButtonRef = t.optional(t.table),
	inputBindings = t.optional(t.table),
	useMaxTitleHeight = t.optional(t.boolean),
	addSubtitleSpace = t.optional(t.boolean),
	titleFontStyle = t.optional(t.union(validateFontInfo, validateTypographyInfo)),
	subtitleFontStyle = t.optional(t.union(validateFontInfo, validateTypographyInfo)),
	renderTileInset = t.optional(t.callback),
	[React.Tag] = t.optional(t.string),
	cursor = t.optional(t.any),
	isCircular = t.optional(t.boolean),
	horizontalAlignment = t.optional(t.EnumItem),
	openTypeFeatures = t.optional(t.string),
	onThumbnailLoaded = t.optional(t.callback),
	isRoactGamepadEnabled = t.optional(t.boolean)
})

local function tileBannerUseValidator(p)
	if p.bannerText and p.footer then
		return false, "A custom footer and bannerText can't be used together"
	end

	return true
end

extended.validateProps = t.intersection(v, tileBannerUseValidator)

extended.defaultProps = {
	titleTextLineCount = 2,
	innerPadding = 8,
	titleTopPadding = 0,
	subtitleTopPadding = 0,
	footerTopPadding = 0,
	isSelected = false,
	multiSelect = false,
	isDisabled = false,
	hasRoundedCorners = true,
	Selectable = false,
	isCircular = false,
	horizontalAlignment = nil,
	thumbnailFrameSize = UDim2.new(1, 0, 1, 0),
	titleRichText = false,
	isRoactGamepadEnabled = true
}

function extended:init()
	self.state = { tileWidth = 0, tileHeight = 0 }

	function self.onAbsoluteSizeChange(p)
		self:setState({ tileWidth = p.AbsoluteSize.X, tileHeight = p.AbsoluteSize.Y })
	end
end

function extended.render(data)
	local footer = data.props.footer
	local name = data.props.name
	local subtitle = data.props.subtitle
	local hasVerifiedBadge = data.props.hasVerifiedBadge
	local titleTextLineCount = data.props.titleTextLineCount
	local innerPadding = data.props.innerPadding
	local titleTopPadding = data.props.titleTopPadding
	local subtitleTopPadding = data.props.subtitleTopPadding
	local footerTopPadding = data.props.footerTopPadding
	local onActivated = data.props.onActivated
	local thumbnail = data.props.thumbnail
	local thumbnailSize = data.props.thumbnailSize
	local thumbnailFrameSize = data.props.thumbnailFrameSize
	local thumbnailColor = data.props.thumbnailColor
	local thumbnailTransparency = data.props.thumbnailTransparency
	local bannerText = data.props.bannerText
	local hasRoundedCorners = data.props.hasRoundedCorners
	local isSelected = data.props.isSelected
	local multiSelect = data.props.multiSelect
	local isDisabled = data.props.isDisabled
	local titleIcon = data.props.titleIcon
	local thumbnailOverlayComponents = data.props.thumbnailOverlayComponents
	local backgroundImage = data.props.backgroundImage
	local useMaxTitleHeight = data.props.useMaxTitleHeight
	local addSubtitleSpace = data.props.addSubtitleSpace
	local horizontalAlignment = data.props.horizontalAlignment

	return withTextSizeOffset(function(p)
		return withStyle(function(p2)
			return withSelectionCursorProvider(function(callback)
				local font = p2.Font
				local theme = p2.Theme

				local tileHeight = data.state.tileHeight
				local tileWidth = data.state.tileWidth

				local titleFontStyle = data.props.titleFontStyle or font.Header2
				local titleRichText = data.props.titleRichText
				local subtitleFontStyle = data.props.subtitleFontStyle or font.CaptionHeader
				local v2

				if titleFontStyle.RelativeSize then
					v2 = font.BaseSize * titleFontStyle.RelativeSize
				else
					v2 = titleFontStyle.FontSize
				end

				local v3

				if subtitleFontStyle.RelativeSize then
					v3 = font.BaseSize * subtitleFontStyle.RelativeSize
				else
					v3 = subtitleFontStyle.FontSize
				end

				math.ceil(v2 * titleTextLineCount)
				local maxHeight = math.ceil((v2 + p) * titleTextLineCount)

				local v4 = tileHeight - tileWidth / (data.props.thumbnailAspectRatio or 1) - innerPadding - maxHeight - innerPadding - titleTopPadding
				Vector2.new(0, 0)
				local v5 = 0
				local vector2

				if addSubtitleSpace then
					vector2 = Vector2.new(0, maxHeight)
					v5 = math.ceil(v3) + p
					v4 -= v5
				else
					if useMaxTitleHeight then
						vector2 = Vector2.new(0, maxHeight)
					else
						local v6 = name or ""

						local fontFromFontStyle = GetFontFromFontStyle(titleFontStyle)

						if titleIcon then
							v6 = GetWrappedTextWithIcon(
								v6,
								v2,
								fontFromFontStyle,
								titleIcon.ImageRectSize.X / Images.ImagesResolutionScale,
								4
							)
						end

						local textSize = GetTextSize(v6, v2, fontFromFontStyle, Vector2.new(tileWidth, maxHeight))

						vector2 = Vector2.new(textSize.X, (math.min(textSize.Y, maxHeight)))
					end

					if subtitle ~= nil and subtitle ~= "" then
						v5 = math.ceil(v3) + p
						v4 -= v5
					end
				end

				local v6 = math.max(0, v4)
				local v7 = footer ~= nil or bannerText ~= nil
				local renderTileInset = data.props.renderTileInset

				local udim2 = UDim2.new(1, 0, 0, vector2.Y + v5 + titleTopPadding)
				local nameOverThumbnailPadding

				if data.props.nameOverThumbnail then
					udim2 = UDim2.new(0, tileWidth - 10, 0, -(vector2.Y + 20))
					nameOverThumbnailPadding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, 10)
					})
				end

				local inputBindings = data.props.inputBindings
					or not isDisabled
					and onActivated
					and ({
						Activate = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, onActivated)
					} or nil)
					or nil

				local createElement = React.createElement
				local v8 = {}
				v8.Size = UDim2.new(1, 0, 1, 0)
				v8.BackgroundTransparency = 1
				v8.Selectable = data.props.Selectable
				local activated = React.Event.Activated
				local v9

				if not isDisabled then
					v9 = onActivated
				end

				v8[activated] = v9
				v8[React.Change.AbsoluteSize] = data.onAbsoluteSizeChange
				v8.ref = data.props.textButtonRef
				local selectionImageObject

				if data.props.cursor then
					selectionImageObject = data.props.cursor
				else
					selectionImageObject = callback(CursorKind.RoundedRect)
				end

				v8.SelectionImageObject = selectionImageObject

				local createElement2 = React.createElement
				local v10 = {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, innerPadding),
					HorizontalAlignment = 0
				}
				local horizontalAlignment2

				if not data.props.nameOverThumbnail then
					horizontalAlignment2 = horizontalAlignment
				end

				v10.HorizontalAlignment = horizontalAlignment2
				local children = {
					UIListLayout = createElement2("UIListLayout", v10),
					Thumbnail = 0,
					TitleArea = 0,
					FooterContainer = 0
				}

				local createElement3 = React.createElement
				local v11 = not data.props.isRoactGamepadEnabled and "Frame" or RoactGamepad.Focusable.Frame
				local v12 = {
					Size = thumbnailFrameSize,
					SizeConstraint = Enum.SizeConstraint.RelativeXX,
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					NextSelectionLeft = data.props.NextSelectionLeft,
					NextSelectionRight = data.props.NextSelectionRight,
					NextSelectionUp = data.props.NextSelectionUp,
					NextSelectionDown = data.props.NextSelectionDown,
					ref = data.props.thumbnailRef,
					[React.Tag] = data.props[React.Tag]
				}
				local selectionImageObject2

				if data.props.cursor then
					selectionImageObject2 = data.props.cursor
				else
					selectionImageObject2 = callback(CursorKind.RoundedRectNoInset)
				end

				v12.SelectionImageObject = selectionImageObject2

				if not data.props.isRoactGamepadEnabled then
					inputBindings = nil
				end

				v12.inputBindings = inputBindings

				local createElement4 = React.createElement
				local v13 = {
					Image = thumbnail,
					hasRoundedCorners = hasRoundedCorners,
					cornerRadius = 0,
					isSelected = 0,
					multiSelect = 0,
					overlayComponents = 0,
					imageSize = 0,
					imageColor = 0,
					imageTransparency = 0,
					backgroundImage = 0,
					scaleType = 0,
					onThumbnailLoaded = 0
				}
				local cornerRadius

				if data.props.isCircular then
					cornerRadius = UDim.new(0.5, 0)
				else
					cornerRadius = udim
				end

				v13.cornerRadius = cornerRadius

				v13.isSelected = isSelected
				v13.multiSelect = multiSelect
				v13.overlayComponents = thumbnailOverlayComponents
				v13.imageSize = thumbnailSize
				v13.imageColor = thumbnailColor
				v13.imageTransparency = thumbnailTransparency
				v13.backgroundImage = backgroundImage
				v13.scaleType = data.props.thumbnailScaleType
				v13.onThumbnailLoaded = data.props.onThumbnailLoaded
				local v14 = {
					Image = createElement4(TileThumbnail, v13),
					TileInset = renderTileInset and renderTileInset() or nil,
					UIAspectRatioConstraint = 0
				}
				local uiAspectRatioConstraint

				if data.props.thumbnailAspectRatio ~= nil then
					uiAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
						AspectRatio = data.props.thumbnailAspectRatio,
						AspectType = Enum.AspectType.ScaleWithParentSize
					})
				end

				v14.UIAspectRatioConstraint = uiAspectRatioConstraint
				children.Thumbnail = createElement3(v11, v12, v14)

				children.TitleArea = React.createElement(
					"Frame",
					{ Size = udim2, BackgroundTransparency = 1, LayoutOrder = 2 },
					{
						TitleTopPadding = React.createElement("UIPadding", {
							PaddingTop = UDim.new(0, titleTopPadding)
						}),
						UIListLayout = React.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, subtitleTopPadding),
							HorizontalAlignment = horizontalAlignment
						}),
						NameOverThumbnailPadding = nameOverThumbnailPadding,
						Name = titleTextLineCount > 0 and tileWidth > 0 and React.createElement(TileName, {
							titleIcon = titleIcon,
							name = name,
							nameTextColor = data.props.nameTextColor,
							nameTextTransparency = data.props.nameTextTransparency,
							hasVerifiedBadge = hasVerifiedBadge,
							maxHeight = maxHeight,
							maxWidth = tileWidth,
							LayoutOrder = 1,
							useMaxHeight = useMaxTitleHeight,
							titleFontStyle = titleFontStyle,
							richText = titleRichText,
							horizontalAlignment = horizontalAlignment
						}),
						Subtitle = subtitle ~= "" and subtitle ~= nil and React.createElement(StyledTextLabel, {
							size = UDim2.new(0, 0, 0, v5),
							automaticSize = Enum.AutomaticSize.X,
							text = subtitle,
							colorStyle = theme.TextDefault,
							fontStyle = subtitleFontStyle,
							openTypeFeatures = data.props.openTypeFeatures,
							layoutOrder = 2,
							fluidSizing = false,
							textTruncate = Enum.TextTruncate.AtEnd,
							richText = false,
							lineHeight = 1
						})
					}
				)

				children.FooterContainer = v7
					and React.createElement(
						"Frame",
						{
							Size = UDim2.new(1, 0, 0, v6),
							BackgroundTransparency = 1,
							LayoutOrder = 3
						},
						{
							FooterTopPadding = React.createElement("UIPadding", {
								PaddingTop = UDim.new(0, footerTopPadding)
							}),
							Banner = bannerText and React.createElement(TileBanner, {
								bannerText = bannerText
							}),
							Footer = not bannerText and footer
						}
					)
				return createElement(Interactable, v8, children)
			end)
		end)
	end)
end

local function fn(p)
	local cursor = useCursor(udim)
	local joined = Cryo.Dictionary.join({ cursor = cursor }, p)

	return React.createElement(extended, joined)
end

return React.forwardRef(function(p, thumbnailRef)
	return React.createElement(fn, Cryo.Dictionary.join(p, { thumbnailRef = thumbnailRef }))
end)
