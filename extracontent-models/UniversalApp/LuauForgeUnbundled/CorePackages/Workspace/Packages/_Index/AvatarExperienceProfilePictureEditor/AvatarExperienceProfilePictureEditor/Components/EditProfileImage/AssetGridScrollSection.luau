local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local view = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Foundation").View

local ScrollSection = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/ScrollSection")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/SectionTitle/SectionTitle")
local SectionHeader = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/SectionTitle/SectionHeader")
local AssetPickerGrid = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/AssetPicker/AssetPickerGrid")
local getAssetPickerStatus = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/getAssetPickerStatus")

local function AssetGridScrollSection(props)
	return React.createElement(ScrollSection, {
		layoutOrder = props.layoutOrder,
		pinHeader = true,
		useInternalScroll = props.useInternalScroll,
		header = React.createElement(view, { tag = "auto-xy padding-x-xlarge" }, {
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
