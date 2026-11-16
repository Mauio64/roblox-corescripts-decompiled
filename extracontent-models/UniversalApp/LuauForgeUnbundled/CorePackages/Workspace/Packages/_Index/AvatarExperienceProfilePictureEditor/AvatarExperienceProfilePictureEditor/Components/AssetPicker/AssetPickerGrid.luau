local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Localization")
local AvatarExperienceUIKit = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/AvatarExperienceUIKit")

local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local useLocalization = Localization.Hooks.useLocalization

local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Common/TextKeys")
local SectionTitle = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/SectionTitle/SectionTitle")
local AssetPickerGridBody = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/AssetPicker/AssetPickerGridBody")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/AssetPicker/AssetPickerTile")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/getAssetPickerStatus")
local getGridMetrics = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/getGridMetrics")

local widgetHeader = AvatarExperienceUIKit.WidgetComponents.WidgetHeader

local function AssetPickerGrid(props)
	local status = props.status or "ready"
	local v5 = useTokens()
	local containerWidth = props.containerWidth
	local v6 = useLocalization({ details = TextKeys.DetailsButton })

	local tileSize = props.tileSize
	local medium = v5.Gap.Medium
	local shimmerTileCount = props.shimmerTileCount or 30
	local v7 = React.useMemo(function()
		return { details = v6.details }
	end, { v6.details })

	local v8 = React.useMemo(function()
		return getGridMetrics({
			containerWidth = containerWidth,
			minTileSize = tileSize,
			gap = medium,
			horizontalPadding = v5.Padding.XLarge,
			strokeInset = v5.Padding.XSmall
		})
	end, { containerWidth, tileSize, medium, v5.Padding.XLarge, v5.Padding.XSmall })

	local title = props.title or ""
	local v9 = 1
	local children = {}

	if props.bannerComponent then
		children.Banner = React.createElement(view, {
			tag = "size-full-0 auto-y",
			LayoutOrder = v9
		}, {
			Banner = props.bannerComponent
		})

		v9 += 1
	end

	if status ~= "ready" or #props.items > 0 then
		children.Grid = React.createElement(
			view,
			{
				tag = "size-full-0 auto-y padding-x-xsmall padding-y-xsmall",
				LayoutOrder = v9
			},
			{
				Content = React.createElement(AssetPickerGridBody, {
					status = status,
					items = props.items,
					selectedId = props.selectedId,
					itemsPerRow = v8.itemsPerRow,
					gap = medium,
					shimmerTileCount = shimmerTileCount,
					onSelect = props.onSelect,
					onDetailsActivated = props.onDetailsActivated,
					labels = v7,
					onRetry = props.onRetry
				})
			}
		)

		v9 += 1
	end

	if props.footerComponent then
		children.Footer = React.createElement(
			view,
			{ tag = "size-full-0 auto-y padding-y-medium", LayoutOrder = v9 },
			{ Footer = props.footerComponent }
		)
	end

	local v10 = 1
	local children2 = {}

	if title ~= "" then
		local v11

		if props.seeAllCallback then
			v11 = React.createElement(widgetHeader, {
				titleText = title,
				seeAllCallback = props.seeAllCallback
			})
		else
			v11 = React.createElement(SectionTitle, { title = title })
		end

		children2.Title = React.createElement(
			view,
			{ tag = "auto-xy padding-x-xlarge", LayoutOrder = v10 },
			{ Header = v11 }
		)

		v10 += 1
	end

	children2.Body = React.createElement(
		view,
		{ tag = "col gap-small size-full-0 auto-y padding-x-xlarge", LayoutOrder = v10 },
		children
	)

	return React.createElement(
		view,
		{ tag = "col size-full-0 auto-y", LayoutOrder = props.layoutOrder },
		children2
	)
end

return AssetPickerGrid
