require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/MomentsTypes")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization

local AssetCardView = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/AssetCardView/AssetCardView")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Grouping/MessageGroupShape")
local toMomentAssetCardProps = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/MomentShareCard/toMomentAssetCardProps")
local useMomentShareCardViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/MomentShareCard/useMomentShareCardViewModel")

local FFlagAppChatMomentShareCardHideMomentsGlyph = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMomentShareCardHideMomentsGlyph")

local function MomentAssetCard(props)
	local v5 = useMomentShareCardViewModel({
		momentId = props.momentId,
		targetIdType = props.targetIdType,
		openMomentsDeepLink = props.openMomentsDeepLink
	})

	local v6 = useLocalization({
		errorText = "Feature.Chat.Label.ContentLoadingFailed",
		unavailableText = "Feature.Moments.Label.MomentUnavailableDefault"
	})

	return React.createElement(AssetCardView, toMomentAssetCardProps(v5, {
		groupShape = props.groupShape,
		mediaRef = props.mediaRef,
		errorText = v6.errorText,
		unavailableText = v6.unavailableText,
		showMomentsGlyph = not FFlagAppChatMomentShareCardHideMomentsGlyph
	}))
end

return React.memo(MomentAssetCard)
