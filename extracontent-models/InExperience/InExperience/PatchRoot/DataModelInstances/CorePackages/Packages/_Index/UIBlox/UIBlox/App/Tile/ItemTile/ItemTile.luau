local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent.Parent
local parent4 = parent3.Parent

local React = require(parent4.React)
local Cryo = require(parent4.Cryo)
local t = require(parent4.t)

local Images = require(parent3.App.ImageSet.Images)
local ItemRestrictionStatus = require(parent.ItemRestrictionStatus)
local ItemTileStatusIcon = require(parent.ItemTileStatusIcon)
local ItemTileStatus = require(parent.ItemTileStatus)
local ItemTileEnums = require(parent2.Enum.ItemTileEnums)
local ItemIcon = require(parent.ItemIcon)
local Tile = require(parent2.BaseTile.Tile)

local extended = React.PureComponent:extend("ItemTile")

local function tileBannerUseValidator(props)
	if props.bannerText and props.footer then
		return false, "A custom footer and bannerText can't be used together"
	end

	return true
end

extended.validateProps = t.strictInterface({
	footer = t.optional(t.table),
	name = t.optional(t.string),
	nameTextColor = t.optional(t.Color3),
	nameTextTransparency = t.optional(t.number),
	subtitle = t.optional(t.string),
	titleTextLineCount = t.optional(t.integer),
	innerPadding = t.optional(t.integer),
	titleTopPadding = t.optional(t.integer),
	subtitleTopPadding = t.optional(t.integer),
	footerTopPadding = t.optional(t.integer),
	onActivated = t.optional(t.callback),
	thumbnail = t.optional(t.string),
	backgroundImage = t.optional(t.union(t.string, t.table)),
	bannerText = t.optional(t.string),
	itemIconType = t.optional(ItemTileEnums.ItemIconType.isEnumValue),
	isSelected = t.optional(t.boolean),
	Selectable = t.optional(t.boolean),
	multiSelect = t.optional(t.boolean),
	isPremium = t.optional(t.boolean),
	restrictionTypes = t.optional(t.map(ItemTileEnums.Restriction.isEnumValue, t.boolean)),
	restrictionInfo = t.optional(t.table),
	hasRoundedCorners = t.optional(t.boolean),
	statusText = t.optional(t.string),
	statusStyle = t.optional(ItemTileEnums.StatusStyle.isEnumValue),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	thumbnailRef = t.optional(t.table),
	textButtonRef = t.optional(t.table),
	inputBindings = t.optional(t.table),
	useMaxTitleHeight = t.optional(t.boolean),
	addSubtitleSpace = t.optional(t.boolean),
	titleFontStyle = t.optional(t.table),
	renderTileInset = t.optional(t.callback),
	hasVerifiedBadge = t.optional(t.boolean),
	[React.Tag] = t.optional(t.string),
	aspectRatio = t.optional(t.number),
	scaleType = t.optional(t.enum(Enum.ScaleType)),
	onThumbnailLoaded = t.optional(t.callback),
	isRoactGamepadEnabled = t.optional(t.boolean)
})

extended.defaultProps = {
	titleTextLineCount = 2,
	innerPadding = 8,
	isSelected = false,
	multiSelect = false,
	isPremium = false,
	hasRoundedCorners = true,
	Selectable = false,
	isRoactGamepadEnabled = true
}

local function isIconStatusStyle(statusStyle): boolean -- 1 equivalent call inferred from this helper
	return statusStyle == ItemTileEnums.StatusStyle.PendingIcon or statusStyle == ItemTileEnums.StatusStyle.AlertIcon
end

function extended.render(p)
	assert(tileBannerUseValidator(p.props))
	local footer = p.props.footer
	local bannerText = p.props.bannerText
	local hasRoundedCorners = p.props.hasRoundedCorners
	local innerPadding = p.props.innerPadding
	local isPremium = p.props.isPremium
	local isSelected = p.props.isSelected
	local multiSelect = p.props.multiSelect
	local itemIconType = p.props.itemIconType
	local name = p.props.name
	local nameTextColor = p.props.nameTextColor
	local nameTextTransparency = p.props.nameTextTransparency
	local subtitle = p.props.subtitle
	local titleTopPadding = p.props.titleTopPadding
	local subtitleTopPadding = p.props.subtitleTopPadding
	local footerTopPadding = p.props.footerTopPadding
	local onActivated = p.props.onActivated
	local restrictionInfo = p.props.restrictionInfo
	local restrictionTypes = p.props.restrictionTypes
	local statusStyle = p.props.statusStyle
	local statusText = p.props.statusText
	local titleTextLineCount = p.props.titleTextLineCount
	local thumbnail = p.props.thumbnail
	local backgroundImage = p.props.backgroundImage
	local useMaxTitleHeight = p.props.useMaxTitleHeight
	local addSubtitleSpace = p.props.addSubtitleSpace
	local selectable = p.props.Selectable
	local titleFontStyle = p.props.titleFontStyle
	local renderTileInset = p.props.renderTileInset
	local aspectRatio = p.props.aspectRatio
	local scaleType = p.props.scaleType

	local children = {}
	local v

	if itemIconType then
		children.ItemIconType = React.createElement(ItemIcon, { itemIconType = itemIconType })
		v = true
	else
		v = false
	end

	if restrictionTypes then
		children.RestrictionStatus = React.createElement(ItemRestrictionStatus, {
			restrictionInfo = restrictionInfo,
			restrictionTypes = restrictionTypes
		})
		v = true
	end

	if statusText then
		children.Status = React.createElement(ItemTileStatus, {
			statusStyle = statusStyle,
			statusText = statusText
		})
		v = true
	end

	if isIconStatusStyle(statusStyle) then -- inferred equivalent call
		children.Status = React.createElement(ItemTileStatusIcon, { statusStyle = statusStyle })
		v = true
	end

	return React.createElement(Tile, {
		bannerText = bannerText,
		footer = footer,
		hasRoundedCorners = hasRoundedCorners,
		innerPadding = innerPadding,
		isSelected = isSelected,
		Selectable = selectable,
		multiSelect = multiSelect,
		name = name,
		nameTextColor = nameTextColor,
		nameTextTransparency = nameTextTransparency,
		subtitle = subtitle,
		titleTopPadding = titleTopPadding,
		subtitleTopPadding = subtitleTopPadding,
		footerTopPadding = footerTopPadding,
		onActivated = onActivated,
		thumbnail = thumbnail,
		backgroundImage = backgroundImage,
		thumbnailOverlayComponents = v and children or nil,
		titleIcon = isPremium and Images["icons/status/premium_small"] or nil,
		titleTextLineCount = titleTextLineCount,
		useMaxTitleHeight = useMaxTitleHeight,
		addSubtitleSpace = addSubtitleSpace,
		titleFontStyle = titleFontStyle,
		renderTileInset = renderTileInset,
		thumbnailAspectRatio = aspectRatio,
		thumbnailScaleType = scaleType,
		hasVerifiedBadge = p.props.hasVerifiedBadge,
		NextSelectionLeft = p.props.NextSelectionLeft,
		NextSelectionRight = p.props.NextSelectionRight,
		NextSelectionUp = p.props.NextSelectionUp,
		NextSelectionDown = p.props.NextSelectionDown,
		textButtonRef = p.props.textButtonRef,
		inputBindings = p.props.inputBindings,
		ref = p.props.thumbnailRef,
		[React.Tag] = p.props[React.Tag],
		onThumbnailLoaded = p.props.onThumbnailLoaded,
		isRoactGamepadEnabled = p.props.isRoactGamepadEnabled
	})
end

return React.forwardRef(function(p, thumbnailRef)
	return React.createElement(extended, Cryo.Dictionary.join(p, { thumbnailRef = thumbnailRef }))
end)
