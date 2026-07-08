local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local RoactGamepad = require(ParentParentParentParent.RoactGamepad)
local React = require(ParentParentParentParent.React)
local Cryo = require(ParentParentParentParent.Cryo)
local t = require(ParentParentParentParent.t)
local withStyle = require(ParentParentParent.Core.Style.withStyle)
local validateFontInfo = require(ParentParentParent.Core.Style.Validator.validateFontInfo)
local validateTypographyInfo = require(ParentParentParent.Core.Style.Validator.validateTypographyInfo)
local GetTextSize = require(ParentParentParent.Core.Text.GetTextSize)
local GetWrappedTextWithIcon = require(ParentParentParent.Core.Text.GetWrappedTextWithIcon)
local withTextSizeOffset = require(ParentParentParent.Core.Style.withTextSizeOffset)
local CursorKind = require(ParentParent.SelectionImage.CursorKind)
local withSelectionCursorProvider = require(ParentParent.SelectionImage.withSelectionCursorProvider)
local useCursor = require(ParentParentParent.App.SelectionCursor.useCursor)
local TileName = require(scriptParent.TileName)
local TileThumbnail = require(scriptParent.TileThumbnail)
local TileBanner = require(scriptParent.TileBanner)
local StyledTextLabel = require(ParentParent.Text.StyledTextLabel)
local Images = require(ParentParentParent.App.ImageSet.Images)
local Interactable = require(ParentParentParent.Core.Control.Interactable)
local uDim = UDim.new(0, 10)
local v25 = React.PureComponent:extend("Tile")
local v26 = t.strictInterface({
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

local function tileBannerUseValidator(p1) -- line: 175
	if p1.bannerText and p1.footer then
		return false, "A custom footer and bannerText can't be used together"
	end

	return true
end

v25.validateProps = t.intersection(v26, tileBannerUseValidator)
v25.defaultProps = {
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
	titleRichText = false,
	isRoactGamepadEnabled = true,
	thumbnailFrameSize = UDim2.new(1, 0, 1, 0)
}

function v25.init(p2) -- line: 203
	p2.state = {
		tileWidth = 0,
		tileHeight = 0
	}

	function p2.onAbsoluteSizeChange(p3) -- line: 209
		-- upvalues: p2 (copy)
		local AbsoluteSizeX = p3.AbsoluteSize.X
		local AbsoluteSizeY = p3.AbsoluteSize.Y

		p2:setState({
			tileWidth = AbsoluteSizeX,
			tileHeight = AbsoluteSizeY
		})
	end
end
function v25.render(p4) -- line: 219
	-- upvalues: withTextSizeOffset (copy), withStyle (copy), withSelectionCursorProvider (copy), Images (copy), GetWrappedTextWithIcon (copy), GetTextSize (copy), React (copy), RoactGamepad (copy), Interactable (copy), CursorKind (copy), TileThumbnail (copy), uDim (copy), TileName (copy), StyledTextLabel (copy), TileBanner (copy)
	local footer = p4.props.footer
	local name = p4.props.name
	local subtitle = p4.props.subtitle
	local hasVerifiedBadge = p4.props.hasVerifiedBadge
	local titleTextLineCount = p4.props.titleTextLineCount
	local innerPadding = p4.props.innerPadding
	local titleTopPadding = p4.props.titleTopPadding
	local subtitleTopPadding = p4.props.subtitleTopPadding
	local footerTopPadding = p4.props.footerTopPadding
	local onActivated = p4.props.onActivated
	local thumbnail = p4.props.thumbnail
	local thumbnailSize = p4.props.thumbnailSize
	local thumbnailFrameSize = p4.props.thumbnailFrameSize
	local thumbnailColor = p4.props.thumbnailColor
	local thumbnailTransparency = p4.props.thumbnailTransparency
	local bannerText = p4.props.bannerText
	local hasRoundedCorners = p4.props.hasRoundedCorners
	local isSelected = p4.props.isSelected
	local multiSelect = p4.props.multiSelect
	local isDisabled = p4.props.isDisabled
	local titleIcon = p4.props.titleIcon
	local thumbnailOverlayComponents = p4.props.thumbnailOverlayComponents
	local backgroundImage = p4.props.backgroundImage
	local useMaxTitleHeight = p4.props.useMaxTitleHeight
	local addSubtitleSpace = p4.props.addSubtitleSpace
	local horizontalAlignment = p4.props.horizontalAlignment

	return withTextSizeOffset(function(p5) -- line: 247
		-- upvalues: withStyle (copy), withSelectionCursorProvider (copy), p4 (copy), titleTextLineCount (copy), innerPadding (copy), titleTopPadding (copy), addSubtitleSpace (copy), useMaxTitleHeight (copy), name (copy), titleIcon (copy), Images (copy), GetWrappedTextWithIcon (copy), GetTextSize (copy), subtitle (copy), footer (copy), bannerText (copy), React (copy), isDisabled (copy), onActivated (copy), RoactGamepad (copy), Interactable (copy), CursorKind (copy), horizontalAlignment (copy), thumbnailFrameSize (copy), TileThumbnail (copy), thumbnail (copy), hasRoundedCorners (copy), uDim (copy), isSelected (copy), multiSelect (copy), thumbnailOverlayComponents (copy), thumbnailSize (copy), thumbnailColor (copy), thumbnailTransparency (copy), backgroundImage (copy), subtitleTopPadding (copy), TileName (copy), hasVerifiedBadge (copy), StyledTextLabel (copy), footerTopPadding (copy), TileBanner (copy)
		return withStyle(function(p6) -- line: 248
			-- upvalues: withSelectionCursorProvider (copy), p4 (copy), titleTextLineCount (copy), p5 (copy), innerPadding (copy), titleTopPadding (copy), addSubtitleSpace (copy), useMaxTitleHeight (copy), name (copy), titleIcon (copy), Images (copy), GetWrappedTextWithIcon (copy), GetTextSize (copy), subtitle (copy), footer (copy), bannerText (copy), React (copy), isDisabled (copy), onActivated (copy), RoactGamepad (copy), Interactable (copy), CursorKind (copy), horizontalAlignment (copy), thumbnailFrameSize (copy), TileThumbnail (copy), thumbnail (copy), hasRoundedCorners (copy), uDim (copy), isSelected (copy), multiSelect (copy), thumbnailOverlayComponents (copy), thumbnailSize (copy), thumbnailColor (copy), thumbnailTransparency (copy), backgroundImage (copy), subtitleTopPadding (copy), TileName (copy), hasVerifiedBadge (copy), StyledTextLabel (copy), footerTopPadding (copy), TileBanner (copy)
			return withSelectionCursorProvider(function(p7) -- line: 249
				-- upvalues: p6 (copy), p4 (copy), titleTextLineCount (copy), p5 (copy), innerPadding (copy), titleTopPadding (copy), addSubtitleSpace (copy), useMaxTitleHeight (copy), name (copy), titleIcon (copy), Images (copy), GetWrappedTextWithIcon (copy), GetTextSize (copy), subtitle (copy), footer (copy), bannerText (copy), React (copy), isDisabled (copy), onActivated (copy), RoactGamepad (copy), Interactable (copy), CursorKind (copy), horizontalAlignment (copy), thumbnailFrameSize (copy), TileThumbnail (copy), thumbnail (copy), hasRoundedCorners (copy), uDim (copy), isSelected (copy), multiSelect (copy), thumbnailOverlayComponents (copy), thumbnailSize (copy), thumbnailColor (copy), thumbnailTransparency (copy), backgroundImage (copy), subtitleTopPadding (copy), TileName (copy), hasVerifiedBadge (copy), StyledTextLabel (copy), footerTopPadding (copy), TileBanner (copy)
				local p6Font = p6.Font
				local Theme = p6.Theme
				local tileHeight = p4.state.tileHeight
				local tileWidth = p4.state.tileWidth
				local v73 = p4.props.titleFontStyle or p6Font.Header2
				local titleRichText = p4.props.titleRichText
				local v75 = p4.props.subtitleFontStyle or p6Font.CaptionHeader
				local v76 = if not v73.RelativeSize then v73.FontSize else p6Font.BaseSize * v73.RelativeSize
				local v77 = if not v75.RelativeSize then v75.FontSize else p6Font.BaseSize * v75.RelativeSize

				math.ceil(v76 * titleTextLineCount)

				local v78 = math.ceil((v76 + p5) * titleTextLineCount)
				local v79 = tileHeight - tileWidth / (p4.props.thumbnailAspectRatio or 1) - innerPadding - v78 - innerPadding - titleTopPadding

				Vector2.new(0, 0)

				local n1 = 0
				local vector2

				if addSubtitleSpace then
					vector2 = Vector2.new(0, v78)
					n1 = math.ceil(v77) + p5
					v79 -= n1
				else
					if useMaxTitleHeight then
						vector2 = Vector2.new(0, v78)
					else
						local v82 = name or ""
						local Font = v73.Font

						if titleIcon then
							local v84 = titleIcon.ImageRectSize.X / Images.ImagesResolutionScale

							v82 = GetWrappedTextWithIcon(v82, v76, Font, v84, 4)
						end

						local v85 = GetTextSize(v82, v76, Font, Vector2.new(tileWidth, v78))

						vector2 = Vector2.new(v85.X, (math.min(v85.Y, v78)))
					end

					if subtitle ~= nil and subtitle ~= "" then
						n1 = math.ceil(v77) + p5
						v79 -= n1
					end
				end

				local v86 = math.max(0, v79)
				local v87 = footer ~= nil or bannerText ~= nil
				local renderTileInset = p4.props.renderTileInset
				local uDim2 = UDim2.new(1, 0, 0, vector2.Y + n1 + titleTopPadding)
				local v90 = nil

				if p4.props.nameOverThumbnail then
					uDim2 = UDim2.new(0, tileWidth - 10, 0, -(vector2.Y + 20))
					v90 = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, 10)
					})
				end

				local v91 = p4.props.inputBindings or (not isDisabled and (not not onActivated and {
					Activate = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, onActivated)
				}) or nil)

				return React.createElement(Interactable, {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Selectable = p4.props.Selectable,
					[React.Event.Activated] = if not isDisabled then onActivated else nil,
					[React.Change.AbsoluteSize] = p4.onAbsoluteSizeChange,
					ref = p4.props.textButtonRef,
					SelectionImageObject = if not p4.props.cursor then p7(CursorKind.RoundedRect) else p4.props.cursor
				}, {
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, innerPadding),
						HorizontalAlignment = if p4.props.nameOverThumbnail then nil else horizontalAlignment
					}),
					Thumbnail = React.createElement(not p4.props.isRoactGamepadEnabled and "Frame" or RoactGamepad.Focusable.Frame, {
						Size = thumbnailFrameSize,
						SizeConstraint = Enum.SizeConstraint.RelativeXX,
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						NextSelectionLeft = p4.props.NextSelectionLeft,
						NextSelectionRight = p4.props.NextSelectionRight,
						NextSelectionUp = p4.props.NextSelectionUp,
						NextSelectionDown = p4.props.NextSelectionDown,
						ref = p4.props.thumbnailRef,
						[React.Tag] = p4.props[React.Tag],
						SelectionImageObject = if not p4.props.cursor then p7(CursorKind.RoundedRectNoInset) else p4.props.cursor,
						inputBindings = if not p4.props.isRoactGamepadEnabled then nil else v91
					}, {
						Image = React.createElement(TileThumbnail, {
							Image = thumbnail,
							hasRoundedCorners = hasRoundedCorners,
							cornerRadius = if not p4.props.isCircular then uDim else UDim.new(0.5, 0),
							isSelected = isSelected,
							multiSelect = multiSelect,
							overlayComponents = thumbnailOverlayComponents,
							imageSize = thumbnailSize,
							imageColor = thumbnailColor,
							imageTransparency = thumbnailTransparency,
							backgroundImage = backgroundImage,
							scaleType = p4.props.thumbnailScaleType,
							onThumbnailLoaded = p4.props.onThumbnailLoaded
						}),
						TileInset = renderTileInset and renderTileInset() or nil,
						UIAspectRatioConstraint = if p4.props.thumbnailAspectRatio == nil then nil else React.createElement("UIAspectRatioConstraint", {
							AspectRatio = p4.props.thumbnailAspectRatio,
							AspectType = Enum.AspectType.ScaleWithParentSize
						})
					}),
					TitleArea = React.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						Size = uDim2
					}, {
						TitleTopPadding = React.createElement("UIPadding", {
							PaddingTop = UDim.new(0, titleTopPadding)
						}),
						UIListLayout = React.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, subtitleTopPadding),
							HorizontalAlignment = horizontalAlignment
						}),
						NameOverThumbnailPadding = v90,
						Name = titleTextLineCount > 0 and (tileWidth > 0 and React.createElement(TileName, {
							LayoutOrder = 1,
							titleIcon = titleIcon,
							name = name,
							nameTextColor = p4.props.nameTextColor,
							nameTextTransparency = p4.props.nameTextTransparency,
							hasVerifiedBadge = hasVerifiedBadge,
							maxHeight = v78,
							maxWidth = tileWidth,
							useMaxHeight = useMaxTitleHeight,
							titleFontStyle = v73,
							richText = titleRichText,
							horizontalAlignment = horizontalAlignment
						})),
						Subtitle = subtitle ~= "" and (subtitle ~= nil and React.createElement(StyledTextLabel, {
							layoutOrder = 2,
							fluidSizing = false,
							richText = false,
							lineHeight = 1,
							size = UDim2.new(0, 0, 0, n1),
							automaticSize = Enum.AutomaticSize.X,
							text = subtitle,
							colorStyle = Theme.TextDefault,
							fontStyle = v75,
							openTypeFeatures = p4.props.openTypeFeatures,
							textTruncate = Enum.TextTruncate.AtEnd
						}))
					}),
					FooterContainer = v87 and React.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 3,
						Size = UDim2.new(1, 0, 0, v86)
					}, {
						FooterTopPadding = React.createElement("UIPadding", {
							PaddingTop = UDim.new(0, footerTopPadding)
						}),
						Banner = bannerText and React.createElement(TileBanner, {
							bannerText = bannerText
						}),
						Footer = not bannerText and footer
					})
				})
			end)
		end)
	end)
end

local function v28(p8) -- line: 463
	-- upvalues: useCursor (copy), uDim (copy), Cryo (copy), React (copy), v25 (copy)
	local v59 = useCursor(uDim)
	local v60 = Cryo.Dictionary.join({
		cursor = v59
	}, p8)

	return React.createElement(v25, v60)
end

return React.forwardRef(function(p9, p10) -- line: 471
	-- upvalues: React (copy), v28 (copy), Cryo (copy)
	return React.createElement(v28, Cryo.Dictionary.join(p9, {
		thumbnailRef = p10
	}))
end)
