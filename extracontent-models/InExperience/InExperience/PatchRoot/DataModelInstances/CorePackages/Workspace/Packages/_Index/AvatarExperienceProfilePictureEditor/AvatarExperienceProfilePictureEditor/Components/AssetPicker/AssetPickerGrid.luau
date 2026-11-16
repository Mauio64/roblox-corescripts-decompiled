local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local AvatarExperienceUIKit = require(parent.AvatarExperienceUIKit)

local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local useLocalization = Localization.Hooks.useLocalization

local TextKeys = require(AvatarExperienceProfilePictureEditor.Common.TextKeys)
local SectionTitle = require(AvatarExperienceProfilePictureEditor.Components.SectionTitle.SectionTitle)
local AssetPickerGridBody = require(script.Parent.AssetPickerGridBody)
require(script.Parent.AssetPickerTile)
require(AvatarExperienceProfilePictureEditor.Utils.getAssetPickerStatus)
local getGridMetrics = require(AvatarExperienceProfilePictureEditor.Utils.getGridMetrics)

local WidgetHeader = AvatarExperienceUIKit.WidgetComponents.WidgetHeader

local function AssetPickerGrid(props)
	local status = props.status or "ready"
	local v = useTokens()
	local containerWidth = props.containerWidth
	local v2 = useLocalization({ details = TextKeys.DetailsButton })

	local tileSize = props.tileSize
	local medium = v.Gap.Medium
	local shimmerTileCount = props.shimmerTileCount or 30
	local labels = React.useMemo(function()
		return { details = v2.details }
	end, { v2.details })

	local v3 = React.useMemo(function()
		return getGridMetrics({
			containerWidth = containerWidth,
			minTileSize = tileSize,
			gap = medium,
			horizontalPadding = v.Padding.XLarge,
			strokeInset = v.Padding.XSmall
		})
	end, { containerWidth, tileSize, medium, v.Padding.XLarge, v.Padding.XSmall })

	local title = props.title or ""
	local layoutOrder = 1
	local children = {}

	if props.bannerComponent then
		children.Banner = React.createElement(View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = layoutOrder
		}, {
			Banner = props.bannerComponent
		})

		layoutOrder += 1
	end

	if status ~= "ready" or #props.items > 0 then
		children.Grid = React.createElement(
			View,
			{
				tag = "size-full-0 auto-y padding-x-xsmall padding-y-xsmall",
				LayoutOrder = layoutOrder
			},
			{
				Content = React.createElement(AssetPickerGridBody, {
					status = status,
					items = props.items,
					selectedId = props.selectedId,
					itemsPerRow = v3.itemsPerRow,
					gap = medium,
					shimmerTileCount = shimmerTileCount,
					onSelect = props.onSelect,
					onDetailsActivated = props.onDetailsActivated,
					labels = labels,
					onRetry = props.onRetry
				})
			}
		)

		layoutOrder += 1
	end

	if props.footerComponent then
		children.Footer = React.createElement(
			View,
			{ tag = "size-full-0 auto-y padding-y-medium", LayoutOrder = layoutOrder },
			{ Footer = props.footerComponent }
		)
	end

	local layoutOrder2 = 1
	local children2 = {}

	if title ~= "" then
		local header

		if props.seeAllCallback then
			header = React.createElement(WidgetHeader, {
				titleText = title,
				seeAllCallback = props.seeAllCallback
			})
		else
			header = React.createElement(SectionTitle, { title = title })
		end

		children2.Title = React.createElement(View, {
			tag = "auto-xy padding-x-xlarge",
			LayoutOrder = layoutOrder2
		}, {
			Header = header
		})

		layoutOrder2 += 1
	end

	children2.Body = React.createElement(
		View,
		{ tag = "col gap-small size-full-0 auto-y padding-x-xlarge", LayoutOrder = layoutOrder2 },
		children
	)

	return React.createElement(View, {
		tag = "col size-full-0 auto-y",
		LayoutOrder = props.layoutOrder
	}, children2)
end

return AssetPickerGrid
