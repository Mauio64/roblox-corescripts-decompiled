local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization")

local AssetCardTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/AssetCardView/AssetCardTypes")
local AssetCardView = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/AssetCardView/AssetCardView")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Grouping/MessageGroupShape")

local iconName = Foundation.Enums.IconName
local status = AssetCardTypes.Status
local useAbbreviatedNumberLocalization = Localization.Hooks.useAbbreviatedNumberLocalization
local useLocalization = Localization.Hooks.useLocalization

local function GameAssetCard(props)
	local v5 = useAbbreviatedNumberLocalization(props.gamePlayerCount)
	local v6 = useLocalization({ errorText = "Feature.Chat.Label.ContentLoadingFailed" })
	local v7

	if props.isError then
		v7 = status.Error
	else
		v7 = if props.isLoading then status.Loading else status.Ready
	end

	local v8 = not (props.gameThumbnail == nil) and props.gameThumbnail ~= ""

	local createElement = React.createElement
	local v10 = {
		status = v7,
		errorText = v6.errorText,
		groupShape = props.groupShape,
		mediaRef = props.mediaRef,
		LayoutOrder = props.LayoutOrder,
		media = 0,
		footer = 0
	}

	local v12 = if v8 then Content.fromUri(props.gameThumbnail) else nil
	v10.media = {
		image = v12,
		aspectRatio = 16 / 9,
		onActivated = props.onThumbnailActivated,
		isSelectable = props.onThumbnailActivated ~= nil
	}

	local v13 = {
		titleText = props.gameName,
		isTitleLoading = props.isLoading,
		gameStats = { rating = props.gameRating, playerCount = v5 },
		isGameStatsLoading = props.isLoading,
		onActivated = props.onMetadataActivated,
		action = 0
	}
	local v14

	if props.onPlayButtonActivated then
		v14 = {
			icon = 0,
			label = 0,
			variant = 0,
			onActivated = 0,
			isSelectable = true
		}
		local v15 = if not props.playButtonLabel then iconName.PlayLarge else nil
		v14.icon = v15
		v14.label = props.playButtonLabel
		local v16 = if props.playButtonLabel then Foundation.Enums.ButtonVariant.SubEmphasis else nil
		v14.variant = v16
		v14.onActivated = props.onPlayButtonActivated
	end

	v13.action = v14
	v10.footer = v13
	return createElement(AssetCardView, v10)
end

return React.memo(GameAssetCard)
