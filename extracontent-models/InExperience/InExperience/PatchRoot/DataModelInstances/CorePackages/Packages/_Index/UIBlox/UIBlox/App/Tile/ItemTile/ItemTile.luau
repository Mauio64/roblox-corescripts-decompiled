local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local ParentParent = scriptParentParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Cryo = require(ParentParentParent.Cryo)
local t = require(ParentParentParent.t)
local Images = require(ParentParent.App.ImageSet.Images)
local ItemRestrictionStatus = require(scriptParent.ItemRestrictionStatus)
local ItemTileStatusIcon = require(scriptParent.ItemTileStatusIcon)
local ItemTileStatus = require(scriptParent.ItemTileStatus)
local ItemTileEnums = require(scriptParentParent.Enum.ItemTileEnums)
local ItemIcon = require(scriptParent.ItemIcon)
local Tile = require(scriptParentParent.BaseTile.Tile)
local v15 = React.PureComponent:extend("ItemTile")

local function tileBannerUseValidator(p1) -- line: 22
	if p1.bannerText and p1.footer then
		return false, "A custom footer and bannerText can't be used together"
	end

	return true
end

v15.validateProps = t.strictInterface({
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
v15.defaultProps = {
	titleTextLineCount = 2,
	innerPadding = 8,
	isSelected = false,
	multiSelect = false,
	isPremium = false,
	hasRoundedCorners = true,
	Selectable = false,
	isRoactGamepadEnabled = true
}

local function isIconStatusStyle(p2) -- line: 155
	-- upvalues: ItemTileEnums (copy)
	return p2 == ItemTileEnums.StatusStyle.PendingIcon or p2 == ItemTileEnums.StatusStyle.AlertIcon
end

function v15.render(p3) -- line: 159
	-- upvalues: tileBannerUseValidator (copy), React (copy), ItemIcon (copy), ItemRestrictionStatus (copy), ItemTileStatus (copy), ItemTileEnums (copy), ItemTileStatusIcon (copy), Tile (copy), Images (copy)
	assert(tileBannerUseValidator(p3.props))

	local footer = p3.props.footer
	local bannerText = p3.props.bannerText
	local hasRoundedCorners = p3.props.hasRoundedCorners
	local innerPadding = p3.props.innerPadding
	local isPremium = p3.props.isPremium
	local isSelected = p3.props.isSelected
	local multiSelect = p3.props.multiSelect
	local itemIconType = p3.props.itemIconType
	local name = p3.props.name
	local nameTextColor = p3.props.nameTextColor
	local nameTextTransparency = p3.props.nameTextTransparency
	local subtitle = p3.props.subtitle
	local titleTopPadding = p3.props.titleTopPadding
	local subtitleTopPadding = p3.props.subtitleTopPadding
	local footerTopPadding = p3.props.footerTopPadding
	local onActivated = p3.props.onActivated
	local restrictionInfo = p3.props.restrictionInfo
	local restrictionTypes = p3.props.restrictionTypes
	local statusStyle = p3.props.statusStyle
	local statusText = p3.props.statusText
	local titleTextLineCount = p3.props.titleTextLineCount
	local thumbnail = p3.props.thumbnail
	local backgroundImage = p3.props.backgroundImage
	local useMaxTitleHeight = p3.props.useMaxTitleHeight
	local addSubtitleSpace = p3.props.addSubtitleSpace
	local Selectable = p3.props.Selectable
	local titleFontStyle = p3.props.titleFontStyle
	local renderTileInset = p3.props.renderTileInset
	local aspectRatio = p3.props.aspectRatio
	local scaleType = p3.props.scaleType
	local v51 = false
	local t1 = {}

	if itemIconType then
		v51 = true
		t1.ItemIconType = React.createElement(ItemIcon, {
			itemIconType = itemIconType
		})
	end

	if restrictionTypes then
		v51 = true
		t1.RestrictionStatus = React.createElement(ItemRestrictionStatus, {
			restrictionInfo = restrictionInfo,
			restrictionTypes = restrictionTypes
		})
	end

	if statusText then
		v51 = true
		t1.Status = React.createElement(ItemTileStatus, {
			statusStyle = statusStyle,
			statusText = statusText
		})
	end

	if statusStyle == ItemTileEnums.StatusStyle.PendingIcon or statusStyle == ItemTileEnums.StatusStyle.AlertIcon then
		v51 = true
		t1.Status = React.createElement(ItemTileStatusIcon, {
			statusStyle = statusStyle
		})
	end

	return React.createElement(Tile, {
		bannerText = bannerText,
		footer = footer,
		hasRoundedCorners = hasRoundedCorners,
		innerPadding = innerPadding,
		isSelected = isSelected,
		Selectable = Selectable,
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
		thumbnailOverlayComponents = v51 and t1 or nil,
		titleIcon = isPremium and Images["icons/status/premium_small"] or nil,
		titleTextLineCount = titleTextLineCount,
		useMaxTitleHeight = useMaxTitleHeight,
		addSubtitleSpace = addSubtitleSpace,
		titleFontStyle = titleFontStyle,
		renderTileInset = renderTileInset,
		thumbnailAspectRatio = aspectRatio,
		thumbnailScaleType = scaleType,
		hasVerifiedBadge = p3.props.hasVerifiedBadge,
		NextSelectionLeft = p3.props.NextSelectionLeft,
		NextSelectionRight = p3.props.NextSelectionRight,
		NextSelectionUp = p3.props.NextSelectionUp,
		NextSelectionDown = p3.props.NextSelectionDown,
		textButtonRef = p3.props.textButtonRef,
		inputBindings = p3.props.inputBindings,
		ref = p3.props.thumbnailRef,
		[React.Tag] = p3.props[React.Tag],
		onThumbnailLoaded = p3.props.onThumbnailLoaded,
		isRoactGamepadEnabled = p3.props.isRoactGamepadEnabled
	})
end

return React.forwardRef(function(p4, p5) -- line: 270
	-- upvalues: React (copy), v15 (copy), Cryo (copy)
	return React.createElement(v15, Cryo.Dictionary.join(p4, {
		thumbnailRef = p5
	}))
end)
