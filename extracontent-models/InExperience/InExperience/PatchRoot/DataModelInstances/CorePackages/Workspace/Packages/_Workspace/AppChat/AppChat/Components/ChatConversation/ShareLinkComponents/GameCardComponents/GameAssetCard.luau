local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)

local AssetCardTypes = require(AppChat.Components.ChatConversation.AssetCardView.AssetCardTypes)
local AssetCardView = require(AppChat.Components.ChatConversation.AssetCardView.AssetCardView)
require(AppChat.Components.ChatConversation.Grouping.MessageGroupShape)

local IconName = Foundation.Enums.IconName
local Status = AssetCardTypes.Status
local useAbbreviatedNumberLocalization = Localization.Hooks.useAbbreviatedNumberLocalization
local useLocalization = Localization.Hooks.useLocalization

local function GameAssetCard(props)
	local playerCount = useAbbreviatedNumberLocalization(props.gamePlayerCount)
	local v = useLocalization({ errorText = "Feature.Chat.Label.ContentLoadingFailed" })
	local status

	if props.isError then
		status = Status.Error
	elseif props.isLoading then
		status = Status.Loading
	else
		status = Status.Ready
	end

	local v2

	if props.gameThumbnail == nil then
		v2 = false
	else
		v2 = props.gameThumbnail ~= ""
	end

	local createElement = React.createElement
	local v3 = {
		status = status,
		errorText = v.errorText,
		groupShape = props.groupShape,
		mediaRef = props.mediaRef,
		LayoutOrder = props.LayoutOrder,
		media = 0,
		footer = 0
	}
	local image

	if v2 then
		image = Content.fromUri(props.gameThumbnail)
	end

	v3.media = {
		image = image,
		aspectRatio = 16 / 9,
		onActivated = props.onThumbnailActivated,
		isSelectable = props.onThumbnailActivated ~= nil
	}

	local footer = {
		titleText = props.gameName,
		isTitleLoading = props.isLoading,
		gameStats = { rating = props.gameRating, playerCount = playerCount },
		isGameStatsLoading = props.isLoading,
		onActivated = props.onMetadataActivated,
		action = 0
	}
	local action

	if props.onPlayButtonActivated then
		action = {
			icon = 0,
			label = 0,
			variant = 0,
			onActivated = 0,
			isSelectable = true
		}
		local icon

		if not props.playButtonLabel then
			icon = IconName.PlayLarge
		end

		action.icon = icon
		action.label = props.playButtonLabel
		local variant

		if props.playButtonLabel then
			variant = Foundation.Enums.ButtonVariant.SubEmphasis
		end

		action.variant = variant
		action.onActivated = props.onPlayButtonActivated
	end

	footer.action = action
	v3.footer = footer
	return createElement(AssetCardView, v3)
end

return React.memo(GameAssetCard)
