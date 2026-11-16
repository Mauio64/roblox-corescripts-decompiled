local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View

local ScrollSection = require(AvatarExperienceProfilePictureEditor.Components.ScrollSection)
require(AvatarExperienceProfilePictureEditor.Components.SectionTitle.SectionTitle)
local SectionHeader = require(AvatarExperienceProfilePictureEditor.Components.SectionTitle.SectionHeader)
local AssetPickerGrid = require(AvatarExperienceProfilePictureEditor.Components.AssetPicker.AssetPickerGrid)
local getAssetPickerStatus = require(AvatarExperienceProfilePictureEditor.Utils.getAssetPickerStatus)

local function AssetGridScrollSection(props)
	return React.createElement(ScrollSection, {
		layoutOrder = props.layoutOrder,
		pinHeader = true,
		useInternalScroll = props.useInternalScroll,
		header = React.createElement(View, { tag = "auto-xy padding-x-xlarge" }, {
			Title = React.createElement(SectionHeader, {
				title = props.title,
				leadingIconName = props.titleLeadingIconName,
				onBack = props.onTitleBack
			})
		})
	}, {
		Grid = React.createElement(AssetPickerGrid, {
			status = getAssetPickerStatus(props.gridProps.isLoading, props.gridProps.hasError),
			onRetry = props.gridProps.onRetry,
			bannerComponent = props.gridProps.bannerComponent,
			items = props.gridProps.items,
			selectedId = props.gridProps.selectedId,
			onSelect = props.gridProps.onSelect,
			onDetailsActivated = props.gridProps.onDetailsActivated,
			tileSize = props.gridProps.tileSize,
			containerWidth = props.gridProps.containerWidth,
			layoutOrder = props.gridProps.layoutOrder
		})
	})
end

return AssetGridScrollSection
