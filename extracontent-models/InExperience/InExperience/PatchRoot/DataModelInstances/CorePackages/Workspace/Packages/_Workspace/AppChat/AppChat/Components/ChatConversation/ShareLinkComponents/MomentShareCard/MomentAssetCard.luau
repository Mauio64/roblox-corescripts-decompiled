local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(parent.MomentsTypes)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local AssetCardView = require(AppChat.Components.ChatConversation.AssetCardView.AssetCardView)
require(AppChat.Components.ChatConversation.Grouping.MessageGroupShape)
local toMomentAssetCardProps = require(script.Parent.toMomentAssetCardProps)
local useMomentShareCardViewModel = require(script.Parent.useMomentShareCardViewModel)

local FFlagAppChatMomentShareCardHideMomentsGlyph = require(AppChat.Flags.FFlagAppChatMomentShareCardHideMomentsGlyph)

local function MomentAssetCard(props)
	local v = useMomentShareCardViewModel({
		momentId = props.momentId,
		targetIdType = props.targetIdType,
		openMomentsDeepLink = props.openMomentsDeepLink
	})

	local v2 = useLocalization({
		errorText = "Feature.Chat.Label.ContentLoadingFailed",
		unavailableText = "Feature.Moments.Label.MomentUnavailableDefault"
	})

	return React.createElement(AssetCardView, toMomentAssetCardProps(v, {
		groupShape = props.groupShape,
		mediaRef = props.mediaRef,
		errorText = v2.errorText,
		unavailableText = v2.unavailableText,
		showMomentsGlyph = not FFlagAppChatMomentShareCardHideMomentsGlyph
	}))
end

return React.memo(MomentAssetCard)
