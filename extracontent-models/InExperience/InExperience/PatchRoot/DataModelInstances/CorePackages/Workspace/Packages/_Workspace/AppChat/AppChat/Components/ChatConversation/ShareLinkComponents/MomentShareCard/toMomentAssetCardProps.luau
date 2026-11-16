local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Foundation = require(parent.Foundation)
require(parent.React)

local AssetCardTypes = require(AppChat.Components.ChatConversation.AssetCardView.AssetCardTypes)
require(AppChat.Components.ChatConversation.Grouping.MessageGroupShape)
local MomentDetailsStatus = require(script.Parent.MomentDetailsStatus)
require(script.Parent.MomentShareCardView)

local IconName = Foundation.Enums.IconName
local Status = AssetCardTypes.Status

local v = {
	[MomentDetailsStatus.Loading] = Status.Loading,
	[MomentDetailsStatus.Ready] = Status.Ready,
	[MomentDetailsStatus.Unavailable] = Status.Error,
	[MomentDetailsStatus.Locked] = Status.Error,
	[MomentDetailsStatus.Error] = Status.Error
}

local function toMomentAssetCardProps(data, data2)
	local status = v[data.status] or Status.Loading
	local errorText

	if status == Status.Error then
		if data.status == MomentDetailsStatus.Error then
			errorText = data2.errorText
		else
			errorText = data2.unavailableText
		end
	end

	local momentAssetCardProps = {
		status = status,
		errorText = errorText,
		groupShape = data2.groupShape,
		mediaRef = data2.mediaRef,
		media = 0,
		footer = 0
	}
	local image

	if data.hasMedia then
		image = data.posterContent
	end

	local media = {
		image = image,
		aspectRatio = 1,
		isLoading = not data.isPosterLoaded,
		overlayIcon = 0,
		onActivated = 0,
		isSelectable = 0
	}
	local overlayIcon

	if data.isVideo then
		overlayIcon = IconName.PlayLarge
	end

	media.overlayIcon = overlayIcon
	media.onActivated = data.onActivated
	media.isSelectable = data.selectable
	momentAssetCardProps.media = media

	local footer = {
		titleText = data.username,
		isTitleLoading = data.isUsernameLoading,
		subtitleText = data.metadataText,
		subtitleIcon = 0,
		isSubtitleLoading = 0,
		onActivated = 0
	}
	local subtitleIcon

	if data2.showMomentsGlyph then
		subtitleIcon = IconName.Moments
	end

	footer.subtitleIcon = subtitleIcon
	footer.isSubtitleLoading = data.isMetadataLoading
	footer.onActivated = data.onActivated
	momentAssetCardProps.footer = footer
	return momentAssetCardProps
end

return toMomentAssetCardProps
