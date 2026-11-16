local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local AssetCardTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/AssetCardView/AssetCardTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Grouping/MessageGroupShape")
local MomentDetailsStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/MomentShareCard/MomentDetailsStatus")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/MomentShareCard/MomentShareCardView")

local iconName = Foundation.Enums.IconName
local status = AssetCardTypes.Status

local v5 = {
	[MomentDetailsStatus.Loading] = status.Loading,
	[MomentDetailsStatus.Ready] = status.Ready,
	[MomentDetailsStatus.Unavailable] = status.Error,
	[MomentDetailsStatus.Locked] = status.Error,
	[MomentDetailsStatus.Error] = status.Error
}

local function toMomentAssetCardProps(data, data2)
	local v6 = v5[data.status] or status.Loading
	local v7

	if v6 == status.Error then
		v7 = if data.status == MomentDetailsStatus.Error then data2.errorText else data2.unavailableText
	end

	local momentAssetCardProps = {
		status = v6,
		errorText = v7,
		groupShape = data2.groupShape,
		mediaRef = data2.mediaRef,
		media = 0,
		footer = 0
	}

	local v9 = if data.hasMedia then data.posterContent else nil
	local v8 = {
		image = v9,
		aspectRatio = 1,
		isLoading = not data.isPosterLoaded,
		overlayIcon = 0,
		onActivated = 0,
		isSelectable = 0
	}
	local v10 = if data.isVideo then iconName.PlayLarge else nil
	v8.overlayIcon = v10
	v8.onActivated = data.onActivated
	v8.isSelectable = data.selectable
	momentAssetCardProps.media = v8

	local v11 = {
		titleText = data.username,
		isTitleLoading = data.isUsernameLoading,
		subtitleText = data.metadataText,
		subtitleIcon = 0,
		isSubtitleLoading = 0,
		onActivated = 0
	}
	local v12 = if data2.showMomentsGlyph then iconName.Moments else nil
	v11.subtitleIcon = v12
	v11.isSubtitleLoading = data.isMetadataLoading
	v11.onActivated = data.onActivated
	momentAssetCardProps.footer = v11
	return momentAssetCardProps
end

return toMomentAssetCardProps
